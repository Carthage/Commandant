import XCTest
import Quick

@testable import CommandantTests

Quick.QCKMain([
	CommandWrapperSpec.self,
	ExtensionsSpec.self,
	OptionsProtocolSpec.self,
])
