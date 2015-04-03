//
//  Errors.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-24.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation

/// Possible errors that can originate from Commandant.
public enum CommandantError {
	/// An option was used incorrectly.
	case UsageError(description: String)

	/// Creates an NSError that represents the receiver.
	public func toNSError() -> NSError {
		let domain = "org.carthage.Commandant"

		switch self {
		case let .UsageError(description):
			return NSError(domain: domain, code: 0, userInfo: [ NSLocalizedDescriptionKey: description ])
		}
	}
}

extension CommandantError: Printable {
	public var description: String {
		switch self {
		case let .UsageError(description):
			return description
		}
	}
}

/// Constructs an `InvalidArgument` error that indicates a missing value for
/// the argument by the given name.
internal func missingArgumentError(argumentName: String) -> CommandantError {
	let description = "Missing argument for \(argumentName)"
	return CommandantError.UsageError(description: description)
}

/// Constructs an error by combining the example of key (and value, if applicable)
/// with the usage description.
internal func informativeUsageError(keyValueExample: String, usage: String) -> CommandantError {
	let lines = usage.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

	return .UsageError(description: reduce(lines, keyValueExample) { previous, value in
		return previous + "\n\t" + value
	})
}

/// Constructs an error that describes how to use the option, with the given
/// example of key (and value, if applicable) usage.
internal func informativeUsageError<T>(keyValueExample: String, option: Option<T>) -> CommandantError {
	if option.defaultValue != nil {
		return informativeUsageError("[\(keyValueExample)]", option.usage)
	} else {
		return informativeUsageError(keyValueExample, option.usage)
	}
}

/// Constructs an error that describes how to use the option.
internal func informativeUsageError<T: ArgumentType>(option: Option<T>) -> CommandantError {
	var example = ""

	if let key = option.key {
		example += "--\(key) "
	}

	var valueExample = ""
	if let defaultValue = option.defaultValue {
		valueExample = "\(defaultValue)"
	}

	if valueExample.isEmpty {
		example += "(\(T.name))"
	} else {
		example += valueExample
	}

	return informativeUsageError(example, option)
}

/// Constructs an error that describes how to use the given boolean option.
internal func informativeUsageError(option: Option<Bool>) -> CommandantError {
	precondition(option.key != nil)

	let key = option.key!

	if let defaultValue = option.defaultValue {
		return informativeUsageError((defaultValue ? "--no-\(key)" : "--\(key)"), option)
	} else {
		return informativeUsageError("--(no-)\(key)", option)
	}
}

/// Combines the text of the two errors, if they're both `UsageError`s.
/// Otherwise, uses whichever one is not (biased toward the left).
internal func combineUsageErrors(lhs: CommandantError, rhs: CommandantError) -> CommandantError {
	switch (lhs, rhs) {
	case let (.UsageError(left), .UsageError(right)):
		let combinedDescription = "\(left)\n\n\(right)"
		return CommandantError.UsageError(description: combinedDescription)

	case (.UsageError, _):
		return rhs
	
	case (_, .UsageError), (_, _):
		return lhs
	}
}
