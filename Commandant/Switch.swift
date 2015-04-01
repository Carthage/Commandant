//
//  Switch.swift
//  Commandant
//
//  Created by Neil Pankey on 3/31/15.
//  Copyright (c) 2015 Carthage. All rights reserved.
//

import LlamaKit

/// Describes a boolean value that can be switched on/off
public struct Switch {
	/// Optional single letter flag that controls this switch.
	///
	/// Multiple flags can be grouped together as a single argument and will split
	/// when parsing (e.g. `rm -rf` treats 'r' and 'f' as inidividual flags).
	public let flag: Character?

	/// The key that controls this option. For example, a key of `verbose` would
	/// be used for a `--verbose` option.
	public let key: String

	/// The default value for this option. This is the value that will be used
	/// if the option is never explicitly specified on the command line.
	public let defaultValue: Bool

	/// A human-readable string describing the purpose of this option. This will
	/// be shown in help messages. This should describe the effect of _not_ using
	/// the default value (i.e., what will happen if you disable/enable the flag
	/// differently from the default).
	public let usage: String

	public init(flag: Character? = nil, key: String, defaultValue: Bool, usage: String) {
		self.flag = flag
		self.key = key
		self.defaultValue = defaultValue
		self.usage = usage
	}

	/// Constructs an `InvalidArgument` error that describes how the option was
	/// used incorrectly. `value` should be the invalid value given by the user.
	private func invalidUsageError(value: String) -> CommandantError {
		let description = "Invalid value for '\(self)': \(value)"
		return CommandantError.UsageError(description: description)
	}
}

extension Switch: Printable {
	public var description: String {
		return key
	}
}
