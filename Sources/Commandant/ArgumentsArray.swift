//
//  ArgumentsArray.swift
//  Commandant
//
//  Created by Anton Domashnev on 27/11/2016.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Foundation

/// Represents an array of arguments that are converted from the given string
/// Using comma as a separator
/// E.g. "banana, apple, peach" -> ["banana", "apple", "peach"]
struct ArgumentsArray: ArgumentProtocol {
	/// Array of arguments that were passed by a comma separated string
	public let arguments: Array<String>
	
	/// Separator to be used to split string into values
	private static let separator = ","
	
	public static let name = "array"
	
	public static func from(string: String) -> ArgumentsArray? {
		let trimmedComponents = string.components(separatedBy: separator).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
		if trimmedComponents.count > 1 {
			return ArgumentsArray(arguments: trimmedComponents)
		}
		return string.rangeOfCharacter(from: .whitespaces) == nil ? ArgumentsArray(arguments: [string]) : nil
	}
}

extension ArgumentsArray: Equatable {
	public static func ==(lhs: ArgumentsArray, rhs: ArgumentsArray) -> Bool {
		return lhs.arguments == rhs.arguments
	}
}
