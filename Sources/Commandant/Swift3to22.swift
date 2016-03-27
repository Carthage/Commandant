//
//  Swift3to22.swift
//  Commandant
//
//  Created by Norio Nomura on 3/26/16.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Foundation

#if !swift(>=3)
	internal func repeatElement<T>(element: T, count: Int) -> Repeat<T> {
		return Repeat(count: count, repeatedValue: element)
	}

	extension Array {
		internal mutating func append<C : CollectionType where C.Generator.Element == Element>(contentsOf newElements: C) {
			appendContentsOf(newElements)
		}

		internal mutating func remove(at index: Int) -> Element {
			return removeAtIndex(index)
		}
	}

	extension CollectionType {
		internal func split(maxSplits maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, @noescape isSeparator: (Generator.Element) throws -> Bool) rethrows -> [SubSequence] {
			return try split(maxSplits, allowEmptySlices: !omittingEmptySubsequences, isSeparator: isSeparator)
		}

	}

	extension SequenceType {
		internal func enumerated() -> EnumerateSequence<Self> {
			return enumerate()
		}

		internal func sorted(@noescape isOrderedBefore isOrderedBefore: (Generator.Element, Generator.Element) -> Bool) -> [Generator.Element] {
			return sort(isOrderedBefore)
		}
	}

	extension SequenceType where Generator.Element : Comparable {
		internal func max() -> Generator.Element? {
			return maxElement()
		}
	}

	extension SequenceType where Generator.Element == String {
		internal func joined(separator separator: String) -> String {
			return joinWithSeparator(separator)
		}
	}

#endif

// swift-corelibs-foundation is still written in Swift 2 API.
#if !swift(>=3) || os(Linux)
	extension NSCharacterSet {
		class func newline() -> NSCharacterSet {
			return newlineCharacterSet()
		}
	}

	extension String {
		func componentsSeparatedByCharacters(in separator: NSCharacterSet) -> [String] {
			return componentsSeparatedByCharactersInSet(separator)
		}
	}
#endif
