/// A poor man's ordered set.
internal struct OrderedSet<T: Hashable>: Equatable {
	fileprivate var values: [T] = []

	init<S: Sequence>(_ sequence: S) where S.Element == T {
		for e in sequence where !values.contains(e) {
			values.append(e)
		}
	}

	@discardableResult
	mutating func remove(_ member: T) -> T? {
		if let index = values.firstIndex(of: member) {
			return values.remove(at: index)
		} else {
			return nil
		}
	}
}

extension OrderedSet: Collection {
	subscript(position: Int) -> T {
		return values[position]
	}

	var count: Int {
		return values.count
	}

	var isEmpty: Bool {
		return values.isEmpty
	}

	var startIndex: Int {
		return values.startIndex
	}

	var endIndex: Int {
		return values.endIndex
	}

	func index(after i: Int) -> Int {
		return values.index(after: i)
	}
}
