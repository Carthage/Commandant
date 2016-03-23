//
//  OptionSpec.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-25.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

@testable import Commandant
import Foundation
import Nimble
import Quick
import Result

class OptionsTypeSpec: QuickSpec {
	override func spec() {
		describe("CommandMode.Arguments") {
			func tryArguments(arguments: String...) -> Result<TestOptions, CommandantError<NoError>> {
				return TestOptions.evaluate(.Arguments(ArgumentParser(arguments)))
			}

			it("should fail if a required argument is missing") {
				expect(tryArguments().value).to(beNil())
			}

			it("should fail if an option is missing a value") {
				expect(tryArguments("required", "--intValue").value).to(beNil())
			}

			it("should succeed without optional arguments") {
				let value = tryArguments("required").value
				let expected = TestOptions(intValue: 42, stringValue: "foobar", optionalFilename: "filename", requiredName: "required", enabled: false, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should succeed with some optional arguments") {
				let value = tryArguments("required", "--intValue", "3", "fuzzbuzz").value
				let expected = TestOptions(intValue: 3, stringValue: "foobar", optionalFilename: "fuzzbuzz", requiredName: "required", enabled: false, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should override previous optional arguments") {
				let value = tryArguments("required", "--intValue", "3", "--stringValue", "fuzzbuzz", "--intValue", "5", "--stringValue", "bazbuzz").value
				let expected = TestOptions(intValue: 5, stringValue: "bazbuzz", optionalFilename: "filename", requiredName: "required", enabled: false, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should enable a boolean flag") {
				let value = tryArguments("required", "--enabled", "--intValue", "3", "fuzzbuzz").value
				let expected = TestOptions(intValue: 3, stringValue: "foobar", optionalFilename: "fuzzbuzz", requiredName: "required", enabled: true, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should re-disable a boolean flag") {
				let value = tryArguments("required", "--enabled", "--no-enabled", "--intValue", "3", "fuzzbuzz").value
				let expected = TestOptions(intValue: 3, stringValue: "foobar", optionalFilename: "fuzzbuzz", requiredName: "required", enabled: false, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should enable multiple boolean flags") {
				let value = tryArguments("required", "-fg").value
				let expected = TestOptions(intValue: 42, stringValue: "foobar", optionalFilename: "filename", requiredName: "required", enabled: false, force: true, glob: true, arguments: [])
				expect(value).to(equal(expected))
			}

			it("should consume the rest of positional arguments") {
				let value = tryArguments("required", "optional", "value1", "value2").value
				let expected = TestOptions(intValue: 42, stringValue: "foobar", optionalFilename: "optional", requiredName: "required", enabled: false, force: false, glob: false, arguments: [ "value1", "value2" ])
				expect(value).to(equal(expected))
			}

			it("should treat -- as the end of valued options") {
				let value = tryArguments("--", "--intValue").value
				let expected = TestOptions(intValue: 42, stringValue: "foobar", optionalFilename: "filename", requiredName: "--intValue", enabled: false, force: false, glob: false, arguments: [])
				expect(value).to(equal(expected))
			}
		}

		describe("CommandMode.Usage") {
			it("should return an error containing usage information") {
				let error = TestOptions.evaluate(.Usage).error
				expect(error?.description).to(contain("intValue"))
				expect(error?.description).to(contain("stringValue"))
				expect(error?.description).to(contain("name you're required to"))
				expect(error?.description).to(contain("optionally specify"))
			}
		}
	}
}

struct TestOptions: OptionsType, Equatable {
	let intValue: Int
	let stringValue: String
	let optionalFilename: String
	let requiredName: String
	let enabled: Bool
	let force: Bool
	let glob: Bool
	let arguments: [String]

	typealias ClientError = NoError

	static func create(a: Int) -> String -> String -> String -> Bool -> Bool -> Bool -> [String] -> TestOptions {
		return { b in { c in { d in { e in { f in { g in { h in
			return self.init(intValue: a, stringValue: b, optionalFilename: d, requiredName: c, enabled: e, force: f, glob: g, arguments: h)
		} } } } } } }
	}

	static func evaluate(m: CommandMode) -> Result<TestOptions, CommandantError<NoError>> {
		return create
			<*> m <| Option(key: "intValue", defaultValue: 42, usage: "Some integer value")
			<*> m <| Option(key: "stringValue", defaultValue: "foobar", usage: "Some string value")
			<*> m <| Argument(usage: "A name you're required to specify")
			<*> m <| Argument(defaultValue: "filename", usage: "A filename that you can optionally specify")
			<*> m <| Option(key: "enabled", defaultValue: false, usage: "Whether to be enabled")
			<*> m <| Switch(flag: "f", key: "force", usage: "Whether to force")
			<*> m <| Switch(flag: "g", key: "glob", usage: "Whether to glob")
			<*> m <| Argument(defaultValue: [], usage: "An argument list that consumes the rest of positional arguments")
	}
}

func ==(lhs: TestOptions, rhs: TestOptions) -> Bool {
	return lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue && lhs.optionalFilename == rhs.optionalFilename && lhs.requiredName == rhs.requiredName && lhs.enabled == rhs.enabled && lhs.force == rhs.force && lhs.glob == rhs.glob && lhs.arguments == rhs.arguments
}

extension TestOptions: CustomStringConvertible {
	var description: String {
		return "{ intValue: \(intValue), stringValue: \(stringValue), optionalFilename: \(optionalFilename), requiredName: \(requiredName), enabled: \(enabled), force: \(force), glob: \(glob), arguments: \(arguments) }"
	}
}
