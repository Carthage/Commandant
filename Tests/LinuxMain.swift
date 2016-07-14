import XCTest
import Quick

@testable import CommandantTestSuite

Quick.QCKMain([
	CommandWrapperSpec.self,
	OptionsTypeSpec.self,
])
