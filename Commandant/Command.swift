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
