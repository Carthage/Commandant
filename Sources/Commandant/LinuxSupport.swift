//
//  LinuxSupport.swift
//  Commandant
//
//  Created by Norio Nomura on 3/26/16.
//  Copyright © 2016 Carthage. All rights reserved.
//

import Foundation

#if os(Linux)
#if swift(>=3.1)
#else
	// `Foundation.Process` is mistakenly defined as `Task` in
	// swift-corelibs-foundation on Swift 3.0.
	internal typealias Process = Task
#endif
#endif
