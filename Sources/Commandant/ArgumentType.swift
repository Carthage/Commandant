//
//  ArgumentType.swift
//  Commandant
//
//  Created by Syo Ikeda on 12/14/15.
//  Copyright (c) 2015 Carthage. All rights reserved.
//

/// Represents a value that can be converted from a command-line argument.
public protocol ArgumentType {
	/// A human-readable name for this type.
	static var name: String { get }

	/// Attempts to parse a value from the given command-line argument.
	static func from(string: String) -> Self?
	
	@available(*, deprecated, renamed: "from(string:)")
	static func fromString(_ string: String) -> Self?
}

extension Int: ArgumentType {
	public static let name = "integer"
	
	public static func from(string: String) -> Int? {
	      return Int(string)
	}
	
	@available(*, deprecated, renamed: "from(string:)")
	public static func fromString(_ string: String) -> Int? {
	      fatalError()
	}
}

extension String: ArgumentType {
	public static let name = "string"
	
	public static func from(string: String) -> String? {
	      return string
	}
	
	@available(*, deprecated, renamed: "from(string:)")
	public static func fromString(_ string: String) -> String? {
	      fatalError()
	}
}
