// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ThreadHelpers.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/20/23.
//

import Foundation

func dispatchToMainThreadIfNecessary(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
