//
//  Extensions.swift
//  Commandant
//
//  Created by Anton Domashnev on 16/12/2016.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Foundation

extension String {
	/// Split the string into substrings separated by the given separators.
	internal func split(by separators: [Character] = [ ",", " " ], omittingEmptySubsequences: Bool = true) -> [String] {
		return characters
			.split(omittingEmptySubsequences: omittingEmptySubsequences, whereSeparator: separators.contains)
			.map(String.init)
	}
}
