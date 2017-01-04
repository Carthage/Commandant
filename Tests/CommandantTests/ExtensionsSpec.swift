//
//  ExtensionsSpec.swift
//  Commandant
//
//  Created by Anton Domashnev on 16/12/2016.
//  Copyright © 2016 Carthage. All rights reserved.
//

@testable import Commandant
import Foundation
import Nimble
import Quick

class ExtensionsSpec: QuickSpec {
	override func spec() {
		describe("String.split") {
			context("when `omittingEmptySubsequences` is false") {
				context("when there is one separator") {
					it("splits the string correctly") {
						expect("a, b, c".split(by: [","], omittingEmptySubsequences: false)).to(equal(["a"," b"," c"]))
					}
				}
				
				context("when there are multiple separators") {
					it("splits the string correctly") {
						expect(":a, :b, :c d".split(by: [",", " ", ":"], omittingEmptySubsequences: false)).to(equal(["","a","","","b","","","c","d"]))
					}
				}
			}
			
			context("when `omittingEmptySubsequences` is true") {
				context("when there is one separator") {
					it("splits the string correctly") {
						expect("a, b, c".split(by: [","], omittingEmptySubsequences: true)).to(equal(["a"," b"," c"]))
					}
				}
				
				context("when there are multiple separators") {
					it("splits the string correctly") {
						expect(":a, :b, :c d".split(by: [",", " ", ":"], omittingEmptySubsequences: true)).to(equal(["a","b","c","d"]))
					}
				}
			}
			
			context("when use default value for omittingEmptySubsequences") {
				context("when there is one separator") {
					it("splits the string correctly") {
						expect("a, b, c".split(by: [","])).to(equal(["a"," b"," c"]))
					}
				}
				
				context("when there are multiple separators") {
					it("splits the string correctly") {
						expect(":a, :b, :c d".split(by: [",", " ", ":"])).to(equal(["a","b","c","d"]))
					}
				}
			}
		}
	}
}


