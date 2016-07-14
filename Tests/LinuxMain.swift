import XCTest
import Quick

@testable import QuickTestSuite

Quick.QCKMain([
	CommandWrapperSpec.self,
	OptionsTypeSpec.self,
	])
