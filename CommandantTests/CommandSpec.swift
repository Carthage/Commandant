//
//  CommandSpec.swift
//  Commandant
//
//  Created by Syo Ikeda on 1/5/16.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Commandant
import Nimble
import Quick
import Result

class CommandWrapperSpec: QuickSpec {
	override func spec() {
		describe("CommandWrapper.usage") {
			it("should not crash for a command with NoOptions") {
				let command = NoOptionsCommand()

				let registry = CommandRegistry<CommandantError<()>>()
				registry.register(command)

				let wrapper = registry[command.verb]
				expect(wrapper).notTo(beNil())
				expect(wrapper?.usage()).to(beNil())
			}
		}
	}
}

struct NoOptionsCommand: CommandType {
	var verb: String { return "verb" }
	var function: String { return "function" }

	func run(options: NoOptions<CommandantError<()>>) -> Result<(), CommandantError<()>> {
		return .Success()
	}
}
