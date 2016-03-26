//
//  ArgumentParser.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-11-21.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import Result

/// Represents an argument passed on the command line.
private enum RawArgument: Equatable {
	/// A key corresponding to an option (e.g., `verbose` for `--verbose`).
	case Key(String)

	/// A value, either associated with an option or passed as a positional
	/// argument.
	case Value(String)

	/// One or more flag arguments (e.g 'r' and 'f' for `-rf`)
	case Flag(Set<Character>)
}

private func ==(lhs: RawArgument, rhs: RawArgument) -> Bool {
	switch (lhs, rhs) {
	case let (.Key(left), .Key(right)):
		return left == right

	case let (.Value(left), .Value(right)):
		return left == right

	case let (.Flag(left), .Flag(right)):
		return left == right

	default:
		return false
	}
}

extension RawArgument: CustomStringConvertible {
	private var description: String {
		switch self {
		case let .Key(key):
			return "--\(key)"

		case let .Value(value):
			return "\"\(value)\""

		case let .Flag(flags):
			return "-\(String(flags))"
		}
	}
}

/// Destructively parses a list of command-line arguments.
public final class ArgumentParser {
	/// The remaining arguments to be extracted, in their raw form.
	private var rawArguments: [RawArgument] = []

	/// Initializes the generator from a simple list of command-line arguments.
	public init(_ arguments: [String]) {
		// The first instance of `--` terminates the option list.
		let params = arguments.split(maxSplits: 1, omittingEmptySubsequences: true) { $0 == "--" }

		// Parse out the keyed and flag options.
		let options = params.first!
		rawArguments.append(contentsOf: options.map { arg in
			if arg.hasPrefix("-") {
				// Do we have `--{key}` or `-{flags}`.
				let opt = arg.characters.dropFirst()
				if opt.first == "-" {
					return .Key(String(opt.dropFirst()))
				} else {
					return .Flag(Set(opt))
				}
			} else {
				return .Value(arg)
			}
		})

		// Remaining arguments are all positional parameters.
		if params.count == 2 {
			let positional = params.last!
			rawArguments.append(contentsOf: positional.map(RawArgument.Value))
		}
	}

	/// Returns the remaining arguments.
	internal var remainingArguments: [String]? {
		return rawArguments.isEmpty ? nil : rawArguments.map { $0.description }
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
	internal func consumeValueForKey(key: String) -> Result<String?, CommandantError<NoError>> {
		let oldArguments = rawArguments
		rawArguments.removeAll()

		var foundValue: String?
		var index = 0

		while index < oldArguments.count {
			defer { index += 1 }
			let arg = oldArguments[index]

			guard arg == .Key(key) else {
				rawArguments.append(arg)
				continue
			}

			index += 1
			guard index < oldArguments.count, case let .Value(value) = oldArguments[index] else {
				return .Failure(missingArgumentError("--\(key)"))
			}

			foundValue = value
		}

		return .Success(foundValue)
	}

	/// Returns the next positional argument that hasn't yet been returned, or
	/// nil if there are no more positional arguments.
	internal func consumePositionalArgument() -> String? {
		for (index, arg) in rawArguments.enumerated() {
			if case let .Value(value) = arg {
				rawArguments.remove(at: index)
				return value
			}
		}

		return nil
	}

	/// Returns whether the given key was specified and removes it from the
	/// list of arguments remaining.
	internal func consumeKey(key: String) -> Bool {
		let oldArguments = rawArguments
		rawArguments = oldArguments.filter { $0 != .Key(key) }

		return rawArguments.count < oldArguments.count
	}

	/// Returns whether the given flag was specified and removes it from the
	/// list of arguments remaining.
	internal func consumeBooleanFlag(flag: Character) -> Bool {
		for (index, arg) in rawArguments.enumerated() {
			if case let .Flag(flags) = arg where flags.contains(flag) {
				var flags = flags
				flags.remove(flag)

				if flags.isEmpty {
					rawArguments.remove(at: index)
				} else {
					rawArguments[index] = .Flag(flags)
				}

				return true
			}
		}

		return false
	}
}
