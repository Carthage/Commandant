//
//  Command.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-10.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import Result

/// Represents a subcommand that can be executed with its own set of arguments.
public protocol CommandType {
	
	/// The command's options type.
	typealias Options: OptionsType

	/// The action that users should specify to use this subcommand (e.g.,
	/// `help`).
	var verb: String { get }

	/// A human-readable, high-level description of what this command is used
	/// for.
	var function: String { get }

	/// Runs this subcommand with the given options.
	func run(options: Options) -> Result<(), Options.ClientError>
}

/// A type-erased command.
public struct CommandWrapper<ClientError: ErrorType> {
	public let verb: String
	public let function: String
	
	public let run: ArgumentParser -> Result<(), CommandantError<ClientError>>
	
	public let usage: () -> CommandantError<ClientError>

	/// Creates a command that wraps another.
	private init<C: CommandType where C.Options.ClientError == ClientError>(_ command: C) {
		verb = command.verb
		function = command.function
		run = { (arguments: ArgumentParser) -> Result<(), CommandantError<ClientError>> in
			let options = C.Options.evaluate(.Arguments(arguments))

			if let remainingArguments = arguments.remainingArguments {
				return .Failure(unrecognizedArgumentsError(remainingArguments))
			}

			if let options = options.value {
				return command
					.run(options)
					.mapError(CommandantError.CommandError)
			} else {
				return .Failure(options.error!)
			}
		}
		usage = { () -> CommandantError<ClientError> in
			return C.Options.evaluate(.Usage).error!
		}
	}
}

/// Describes the "mode" in which a command should run.
public enum CommandMode {
	/// Options should be parsed from the given command-line arguments.
	case Arguments(ArgumentParser)

	/// Each option should record its usage information in an error, for
	/// presentation to the user.
	case Usage
}

/// Maintains the list of commands available to run.
public final class CommandRegistry<ClientError: ErrorType> {
	private var commandsByVerb: [String: CommandWrapper<ClientError>] = [:]

	/// All available commands.
	public var commands: [CommandWrapper<ClientError>] {
		return commandsByVerb.values.sort { return $0.verb < $1.verb }
	}

	public init() {}

	/// Registers the given command, making it available to run.
	///
	/// If another command was already registered with the same `verb`, it will
	/// be overwritten.
	public func register<C: CommandType where C.Options.ClientError == ClientError>(command: C) {
		commandsByVerb[command.verb] = CommandWrapper(command)
	}

	/// Runs the command corresponding to the given verb, passing it the given
	/// arguments.
	///
	/// Returns the results of the execution, or nil if no such command exists.
	public func runCommand(verb: String, arguments: [String]) -> Result<(), CommandantError<ClientError>>? {
		return self[verb]?.run(ArgumentParser(arguments))
	}

	/// Returns the command matching the given verb, or nil if no such command
	/// is registered.
	public subscript(verb: String) -> CommandWrapper<ClientError>? {
		return commandsByVerb[verb]
	}
}

extension CommandRegistry {
	/// Hands off execution to the CommandRegistry, by parsing Process.arguments
	/// and then running whichever command has been identified in the argument
	/// list.
	///
	/// If the chosen command executes successfully, the process will exit with
	/// a successful exit code.
	///
	/// If the chosen command fails, the provided error handler will be invoked,
	/// then the process will exit with a failure exit code.
	///
	/// If a matching command could not be found or a usage error occurred,
	/// a helpful error message will be written to `stderr`, then the process
	/// will exit with a failure error code.
	@noreturn public func main(defaultVerb defaultVerb: String, errorHandler: ClientError -> ()) {
		main(arguments: Process.arguments, defaultVerb: defaultVerb, errorHandler: errorHandler)
	}
	
	/// Hands off execution to the CommandRegistry, by parsing `arguments`
	/// and then running whichever command has been identified in the argument
	/// list.
	///
	/// If the chosen command executes successfully, the process will exit with
	/// a successful exit code.
	///
	/// If the chosen command fails, the provided error handler will be invoked,
	/// then the process will exit with a failure exit code.
	///
	/// If a matching command could not be found or a usage error occurred,
	/// a helpful error message will be written to `stderr`, then the process
	/// will exit with a failure error code.
	@noreturn public func main(arguments arguments: [String], defaultVerb: String, errorHandler: ClientError -> ()) {
		assert(arguments.count >= 1)

		var arguments = arguments

		// Extract the executable name.
		let executableName = arguments.removeAtIndex(0)

		let verb = arguments.first ?? defaultVerb
		if arguments.count > 0 {
			// Remove the command name.
			arguments.removeAtIndex(0)
		}

		switch runCommand(verb, arguments: arguments) {
		case .Success?:
			exit(EXIT_SUCCESS)

		case let .Failure(error)?:
			switch error {
			case let .UsageError(description):
				fputs(description + "\n", stderr)

			case let .CommandError(error):
				errorHandler(error)
			}

			exit(EXIT_FAILURE)

		case nil:
			fputs("Unrecognized command: '\(verb)'. See `\(executableName) help`.\n", stderr)
			exit(EXIT_FAILURE)
		}
	}
}
