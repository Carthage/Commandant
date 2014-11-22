//
//  ArgumentParser.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-11-21.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import LlamaKit

/// Represents an argument passed on the command line.
private enum RawArgument: Equatable {
	/// A key corresponding to an option (e.g., `verbose` for `--verbose`).
	case Key(String)

	/// A value, either associated with an option or passed as a positional
	/// argument.
	case Value(String)
}

private func ==(lhs: RawArgument, rhs: RawArgument) -> Bool {
	switch (lhs, rhs) {
	case let (.Key(left), .Key(right)):
		return left == right

	case let (.Value(left), .Value(right)):
		return left == right

	default:
		return false
	}
}

extension RawArgument: Printable {
	private var description: String {
		switch self {
		case let .Key(key):
			return "--\(key)"

		case let .Value(value):
			return "\"\(value)\""
		}
	}
}

/// Destructively parses a list of command-line arguments.
public final class ArgumentParser {
	/// The remaining arguments to be extracted, in their raw form.
	private var rawArguments: [RawArgument] = []

	/// Initializes the generator from a simple list of command-line arguments.
	public init(_ arguments: [String]) {
		var permitKeys = true

		for arg in arguments {
			// Check whether this is a keyed argument.
			if permitKeys && arg.hasPrefix("--") {
				// Check for -- by itself, which should terminate the keyed
				// argument list.
				let keyStartIndex = arg.startIndex.successor().successor()
				if keyStartIndex == arg.endIndex {
					permitKeys = false
				} else {
					let key = arg.substringFromIndex(keyStartIndex)
					rawArguments.append(.Key(key))
				}
			} else {
				rawArguments.append(.Value(arg))
			}
		}
	}

	/// Returns whether the given key was enabled or disabled, or nil if it
	/// was not given at all.
	///
	/// If the key is found, it is then removed from the list of arguments
	/// remaining to be parsed.
	internal func consumeBooleanKey(key: String) -> Bool? {
		let oldArguments = rawArguments
		rawArguments.removeAll()

		var result: Bool?
		for arg in oldArguments {
			if arg == .Key(key) {
				result = true
			} else if arg == .Key("no-\(key)") {
				result = false
			} else {
				rawArguments.append(arg)
			}
		}

		return result
	}

	/// Returns the value associated with the given flag, or nil if the flag was
	/// not specified. If the key is presented, but no value was given, an error
	/// is returned.
	///
	/// If a value is found, the key and the value are both removed from the
	/// list of arguments remaining to be parsed.
	internal func consumeValueForKey(key: String) -> Result<String?> {
		let oldArguments = rawArguments
		rawArguments.removeAll()

		var foundValue: String?
		argumentLoop: for var index = 0; index < oldArguments.count; index++ {
			let arg = oldArguments[index]

			if arg == .Key(key) {
				if ++index < oldArguments.count {
					switch oldArguments[index] {
					case let .Value(value):
						foundValue = value
						continue argumentLoop

					default:
						break
					}
				}

				return failure(missingArgumentError("--\(key)"))
			} else {
				rawArguments.append(arg)
			}
		}

		return success(foundValue)
	}

	/// Returns the next positional argument that hasn't yet been returned, or
	/// nil if there are no more positional arguments.
	internal func consumePositionalArgument() -> String? {
		for var index = 0; index < rawArguments.count; index++ {
			switch rawArguments[index] {
			case let .Value(value):
				rawArguments.removeAtIndex(index)
				return value

			default:
				break
			}
		}

		return nil
	}
}
