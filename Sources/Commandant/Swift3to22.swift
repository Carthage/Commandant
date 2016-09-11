//
//  Swift3to22.swift
//  Commandant
//
//  Created by Norio Nomura on 3/26/16.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Foundation

#if !swift(>=3)
	internal func repeatElement<T>(_ element: T, count: Int) -> Repeated<T> {
		return Repeated(count: count, repeatedValue: element)
	}

	extension Array {
		internal mutating func append<C : Collection where C.Iterator.Element == Element>(contentsOf newElements: C) {
			self.append(contentsOf: newElements)
		}

		internal mutating func remove(at index: Int) -> Element {
			return self.remove(at: index)
		}
	}

	extension Collection {
		internal func split(maxSplits maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, @noescape isSeparator: (Iterator.Element) throws -> Bool) rethrows -> [SubSequence] {
			return try split(maxSplits: maxSplits, omittingEmptySubsequences: !(!omittingEmptySubsequences), whereSeparator: isSeparator)
		}

	}

	extension Sequence {
		internal func enumerated() -> EnumeratedSequence<Self> {
			return self.enumerated()
		}

		internal func sorted(@noescape isOrderedBefore: (Iterator.Element, Iterator.Element) -> Bool) -> [Iterator.Element] {
			return self.sorted(by: isOrderedBefore)
		}
	}

	extension Sequence where Iterator.Element : Comparable {
		internal func max() -> Iterator.Element? {
			return self.max()
		}
	}

	extension Sequence where Iterator.Element == String {
		internal func joined(separator: String) -> String {
			return self.joined(separator: separator)
		}
	}

#endif

// swift-corelibs-foundation is still written in Swift 2 API.
#if !swift(>=3) || os(Linux)
	extension CharacterSet {
		class func newline() -> CharacterSet {
			return newlines
		}
	}

	extension String {
		func componentsSeparatedByCharacters(in separator: CharacterSet) -> [String] {
			return components(separatedBy: separator)
		}
	}
#endif
