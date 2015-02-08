//
//  Errors.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-24.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation

/// The domain for all errors originating within Commandant.
public let CommandantErrorDomain: NSString = "org.carthage.Commandant"

/// Possible error codes within `CommandantErrorDomain`.
public enum CommandantError: Int {
	/// One or more arguments was invalid.
	case InvalidArgument
}

/// Constructs an `InvalidArgument` error that indicates a missing value for
/// the argument by the given name.
internal func missingArgumentError(argumentName: String) -> NSError {
	let description = "Missing argument for \(argumentName)"
	return NSError(domain: CommandantErrorDomain, code: CommandantError.InvalidArgument.rawValue, userInfo: [ NSLocalizedDescriptionKey: description ])
}

/// Constructs an `InvalidArgument` error that describes how to use the
/// option, with the given example of key (and value, if applicable) usage.
internal func informativeUsageError<T>(keyValueExample: String, option: Option<T>) -> NSError {
	var description = ""

	if option.defaultValue != nil {
		description += "["
	}

	description += keyValueExample

	if option.defaultValue != nil {
		description += "]"
	}

	description += option.usage.componentsSeparatedByString("\n")
		.reduce(""){ previous, value in
			return previous + "\n\t" + value
		}

	return NSError(domain: CommandantErrorDomain, code: CommandantError.InvalidArgument.rawValue, userInfo: [ NSLocalizedDescriptionKey: description ])
}

/// Constructs an `InvalidArgument` error that describes how to use the
/// option.
internal func informativeUsageError<T: ArgumentType>(option: Option<T>) -> NSError {
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

/// Constructs an `InvalidArgument` error that describes how to use the
/// given boolean option.
internal func informativeUsageError(option: Option<Bool>) -> NSError {
	precondition(option.key != nil)

	let key = option.key!

	if let defaultValue = option.defaultValue {
		return informativeUsageError((defaultValue ? "--no-\(key)" : "--\(key)"), option)
	} else {
		return informativeUsageError("--(no-)\(key)", option)
	}
}

/// Combines the text of the two errors, if they're both `InvalidArgument`
/// errors. Otherwise, uses whichever one is not (biased toward the left).
internal func combineUsageErrors(left: NSError, right: NSError) -> NSError {
	let combinedDescription = "\(left.localizedDescription)\n\n\(right.localizedDescription)"
	let combinedError = NSError(domain: CommandantErrorDomain, code: CommandantError.InvalidArgument.rawValue, userInfo: [ NSLocalizedDescriptionKey: combinedDescription ])

	func isUsageError(error: NSError) -> Bool {
		return error.domain == combinedError.domain && error.code == combinedError.code
	}

	if isUsageError(left) {
		if isUsageError(right) {
			return combinedError
		} else {
			return right
		}
	} else {
		return left
	}
}
