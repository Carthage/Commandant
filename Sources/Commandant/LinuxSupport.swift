import Foundation

// swift-corelibs-foundation is still written in Swift 2 API.
#if os(Linux)
	typealias Process = Task
#endif
