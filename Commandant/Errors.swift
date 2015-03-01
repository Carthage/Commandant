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
	/// The named option did not include a value argument.
	case MissingArgument(optionName: String)

	/// An option was used incorrectly.
	case UsageError(description: String)

	/// Creates an NSError that represents the receiver.
	public func toNSError() -> NSError {
		let domain = "org.carthage.Commandant"

		switch self {
		case let .MissingArgument(optionName):
			let description = "Missing argument for \(optionName)"
			return NSError(domain: domain, code: 0, userInfo: [ NSLocalizedDescriptionKey: description ])

		case let .UsageError(description):
			return NSError(domain: domain, code: 1, userInfo: [ NSLocalizedDescriptionKey: description ])
		}
	}
}

/// Constructs an error that describes how to use the option, with the given
/// example of key (and value, if applicable) usage.
internal func informativeUsageError<T>(keyValueExample: String, option: Option<T>) -> CommandantError {
	var description = ""

	if option.defaultValue != nil {
		description += "["
	}

	description += keyValueExample

	if option.defaultValue != nil {
		description += "]"
	}

	description += option.usage.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		.reduce(""){ previous, value in
			return previous + "\n\t" + value
		}
	
	return CommandantError.UsageError(description: description)
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
