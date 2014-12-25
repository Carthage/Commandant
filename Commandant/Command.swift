//
//  Command.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-10.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import LlamaKit

/// Represents a subcommand that can be executed with its own set of arguments.
public protocol CommandType {
	/// The action that users should specify to use this subcommand (e.g.,
	/// `help`).
	var verb: String { get }

	/// A human-readable, high-level description of what this command is used
	/// for.
	var function: String { get }

	/// Runs this subcommand in the given mode.
	func run(mode: CommandMode) -> Result<()>
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
public final class CommandRegistry {
	private var commandsByVerb: [String: CommandType] = [:]

	/// All available commands.
	public var commands: [CommandType] {
		return sorted(commandsByVerb.values) { return $0.verb < $1.verb }
	}

	public init() {}

	/// Registers the given command, making it available to run.
	///
	/// If another command was already registered with the same `verb`, it will
	/// be overwritten.
	public func register(command: CommandType) {
		commandsByVerb[command.verb] = command
	}

	/// Runs the command corresponding to the given verb, passing it the given
	/// arguments.
	///
	/// Returns the results of the execution, or nil if no such command exists.
	public func runCommand(verb: String, arguments: [String]) -> Result<()>? {
		return self[verb]?.run(.Arguments(ArgumentParser(arguments)))
	}

	/// Returns the command matching the given verb, or nil if no such command
	/// is registered.
	public subscript(verb: String) -> CommandType? {
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
	/// If a matching command could not be found, a helpful error message will
	/// be written to `stderr`, then the process will exit with a failure error
	/// code.
	@noreturn public func main(#defaultCommand: CommandType, errorHandler: NSError -> ()) {
		var arguments = Process.arguments
		assert(arguments.count >= 1)

		// Extract the executable name.
		let executableName = arguments.first!
		arguments.removeAtIndex(0)

		let verb = arguments.first ?? defaultCommand.verb
		if arguments.count > 0 {
			// Remove the command name.
			arguments.removeAtIndex(0)
		}

		switch runCommand(verb, arguments: arguments) {
		case .Some(.Success):
			exit(EXIT_SUCCESS)

		case let .Some(.Failure(error)):
			errorHandler(error)
			exit(EXIT_FAILURE)

		case .None:
			fputs("Unrecognized command: '\(verb)'. See `\(executableName) help`.\n", stderr)
			exit(EXIT_FAILURE)
		}
	}
}
