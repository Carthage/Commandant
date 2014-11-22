//
//  Errors.swift
//  Commandant
//
//  Created by Justin Spahr-Summers on 2014-10-24.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation

/// The domain for all errors originating within Commandant.
public let CommandantErrorDomain: NSString = "org.carthage.Commandant"

/// Possible error codes within `CommandantErrorDomain`.
public enum CommandantError: Int {
	/// One or more arguments was invalid.
	case InvalidArgument
}
