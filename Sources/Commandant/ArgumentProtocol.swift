//
//  ArgumentProtocol.swift
//  Commandant
//
//  Created by Syo Ikeda on 12/14/15.
//  Copyright (c) 2015 Carthage. All rights reserved.
//

/// Represents a value that can be converted from a command-line argument.
public protocol ArgumentProtocol {
	/// A human-readable name for this type.
	static var name: String { get }

	/// Attempts to parse a value from the given command-line argument.
	static func from(string: String) -> Self?
}

extension Int: ArgumentProtocol {
	public static let name = "integer"

	public static func from(string: String) -> Int? {
		return Int(string)
	}
}

extension String: ArgumentProtocol {
	public static let name = "string"

	public static func from(string: String) -> String? {
		return string
	}
}

public extension RawRepresentable where Self.RawValue: StringProtocol, Self: ArgumentProtocol {
	
	public static func from(string: String) -> Self? {
		
		guard let stringValue = Self.RawValue(string)
			else {
				return .none
		}
		
		return Self(rawValue: stringValue)
		
	}
	
}

public extension RawRepresentable where Self.RawValue: FixedWidthInteger, Self: ArgumentProtocol {
	
	public static func from(string: String) -> Self? {
		
		guard let intValue = Self.RawValue(string)
			else {
				return .none
		}
		
		return Self(rawValue: intValue)
		
	}
	
}
