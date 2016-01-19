//
//  Argument.swift
//  Commandant
//
//  Created by Syo Ikeda on 12/14/15.
//  Copyright (c) 2015 Carthage. All rights reserved.
//

import Result

/// Describes an argument that can be provided on the command line.
public struct Argument<T> {
	/// The default value for this argument. This is the value that will be used
	/// if the argument is never explicitly specified on the command line.
	///
	/// If this is nil, this argument is always required.
	public let defaultValue: T?

	/// A human-readable string describing the purpose of this argument. This will
	/// be shown in help messages.
	public let usage: String

	public init(defaultValue: T? = nil, usage: String) {
		self.defaultValue = defaultValue
		self.usage = usage
	}

	private func invalidUsageError<ClientError>(value: String) -> CommandantError<ClientError> {
		let description = "Invalid value for '\(self)': \(value)"
		return .UsageError(description: description)
	}
}

/// Evaluates the given argument in the given mode.
///
/// If parsing command line arguments, and no value was specified on the command
/// line, the argument's `defaultValue` is used.
public func <| <T: ArgumentType, ClientError>(mode: CommandMode, argument: Argument<T>) -> Result<T, CommandantError<ClientError>> {
	switch mode {
	case let .Arguments(arguments):
		guard let stringValue = arguments.consumePositionalArgument() else {
			if let defaultValue = argument.defaultValue {
				return .Success(defaultValue)
			} else {
				return .Failure(missingArgumentError(argument.usage))
			}
		}

		if let value = T.fromString(stringValue) {
			return .Success(value)
		} else {
			return .Failure(argument.invalidUsageError(stringValue))
		}

	case .Usage:
		return .Failure(informativeUsageError(argument))
	}
}

/// Evaluates the given argument list in the given mode.
///
/// If parsing command line arguments, and no value was specified on the command
/// line, the argument's `defaultValue` is used.
public func <| <T: ArgumentType, ClientError>(mode: CommandMode, argument: Argument<[T]>) -> Result<[T], CommandantError<ClientError>> {
	switch mode {
	case let .Arguments(arguments):
		guard let firstValue = arguments.consumePositionalArgument() else {
			if let defaultValue = argument.defaultValue {
				return .Success(defaultValue)
			} else {
				return .Failure(missingArgumentError(argument.usage))
			}
		}

		var values = [T]()

		guard let value = T.fromString(firstValue) else {
			return .Failure(argument.invalidUsageError(firstValue))
		}

		values.append(value)

		while let nextValue = arguments.consumePositionalArgument() {
			guard let value = T.fromString(nextValue) else {
				return .Failure(argument.invalidUsageError(nextValue))
			}

			values.append(value)
		}

		return .Success(values)

	case .Usage:
		return .Failure(informativeUsageError(argument))
	}
}
