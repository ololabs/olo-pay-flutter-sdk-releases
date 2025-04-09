// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ThreadHelpers.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/20/23.
//

import Foundation

func dispatchToMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

func dispatchToMainThread(
    with lock: DispatchSemaphore,
    autoRelease: Bool = true,
    _ codeBlock: @escaping () -> Void
) {
    if Thread.isMainThread {
        controlledExecute(with: lock, autoRelease: autoRelease, codeBlock)
    } else {
        DispatchQueue.main.async {
            controlledExecute(with: lock, autoRelease: autoRelease, codeBlock)
        }
    }
}

// Executes the given code block on a background thread, and if necessary, waits to acquire a lock. If autoRelease is
// true, the lock will release automatically after the code block executes. If false, the caller is responsible for
// releasing the lock at the appropriate time (usually in a completion handler or another method that is guaranteed to
// be called)
func dispatchToBackgroundThread(
    with lock: DispatchSemaphore? = nil,
    autoRelease: Bool = true,
    _ codeBlock: @escaping () -> Void
) {
    dispatchToQos(on: .background, with: lock, autoRelease: autoRelease, codeBlock)
}

// Executes the given code block asynchronously with the given quality of service, and if necessary, waits to acquire a
// lock. If autoRelease is true, the lock will release automatically after the code block executes. If false, the caller
// is responsible for releasing the lock at the appropriate time (usually in a completion handler or another method that
// is guaranteed to be called)
func dispatchToQos(
    on qos: DispatchQoS.QoSClass,
    with lock: DispatchSemaphore? = nil,
    autoRelease: Bool = true,
    _ codeBlock: @escaping () -> Void
) {
    DispatchQueue.global(qos: qos).async {
        if let lock = lock {
            controlledExecute(with: lock, autoRelease: autoRelease, codeBlock)
        } else {
            codeBlock()
        }
    }
}

// Execute the given code block, waiting to acquire a lock, and return the value.
func controlledReturn<T>(with lock: DispatchSemaphore, _ codeBlock: @escaping () -> T) -> T {
    lock.wait()
    let value = codeBlock()
    lock.signal()
    
    return value
}

// Execute the given code block, waiting to acquire a lock. If autoRelease is true, the lock will release
// automatically after the code block executes. If false, the caller is responsible for releaing the lock at the
// appropriate time (usually in a completion handler or another method that is guaranteed to be called)
func controlledExecute(with lock: DispatchSemaphore, autoRelease: Bool = true, _ codeBlock: @escaping () -> Void) {
    lock.wait()
    codeBlock()
    
    if (autoRelease) {
        lock.signal()
    }
}
