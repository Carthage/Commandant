//
//  ArgumentArraySpec.swift
//  Commandant
//
//  Created by Anton Domashnev on 27/11/2016.
//  Copyright © 2016 Carthage. All rights reserved.
//

@testable import Commandant
import Nimble
import Quick

class ArgumentsArraySpec: QuickSpec {
	override func spec() {
		describe("Equatable") {
			context("when arguments are the same") {
				it("compares two ArgumentsArray as equal") {
					expect(ArgumentsArray(arguments: ["one", "two"]) == ArgumentsArray(arguments: ["one", "two"])).to(beTrue())
				}
			}
			
			context("when arguments are not the same") {
				it("compares two ArgumentsArray as not equal") {
					expect(ArgumentsArray(arguments: ["one", "two"]) == ArgumentsArray(arguments: ["one", "three"])).to(beFalse())
				}
			}
		}
		
		describe("ArgumentsArray.fromString") {
			context("when arguments are not comma-separated") {
				context("when only one word") {
					let arguments = "oneword"
					var argumentsArray: ArgumentsArray?
					
					beforeEach {
						argumentsArray = ArgumentsArray.from(string: arguments)
					}
					
					it("returns valid ArgumentsArray") {
						expect(argumentsArray?.arguments).to(equal(["oneword"]))
					}
				}
				
				context("when more than one word") {
					it("returns nil") {
						let arguments = "apple banana peach"
						expect(ArgumentsArray.from(string: arguments)).to(beNil())
					}
				}
			}
			
			context("when arguments are comme-separated") {
				context("when arguments string without spaces") {
					let arguments = "one,two,three"
					var argumentsArray: ArgumentsArray?
					
					beforeEach {
						argumentsArray = ArgumentsArray.from(string: arguments)
					}
					
					it("returns valid ArgumentsArray") {
						expect(argumentsArray?.arguments).to(equal(["one", "two", "three"]))
					}
				}
				
				context("when arguments string with spaces") {
					let arguments = "one, two, three"
					var argumentsArray: ArgumentsArray?
					
					beforeEach {
						argumentsArray = ArgumentsArray.from(string: arguments)
					}
					
					it("returns valid ArgumentsArray") {
						expect(argumentsArray?.arguments).to(equal(["one", "two", "three"]))
					}
				}
			}
		}
		
		describe("ArgumentsArray.name") {
			it("is named array") {
				expect(ArgumentsArray.name).to(equal("array"))
			}
		}
	}
}
