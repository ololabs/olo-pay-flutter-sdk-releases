// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  DictionaryExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/6/23.
//

import Foundation
import OloPaySDK

extension Dictionary where Key == String {
    func getOrThrow<T>(_ key: String, defaultValue: T) throws -> T {
        do {
            return try getOrThrow(key)
        } catch OloError.MissingKeyError {
            return defaultValue
        } catch OloError.NullValueError {
            return defaultValue
        }
    }

    func getOrThrow<T>(_ key: String) throws -> T {
        if (!keyExists(key)) {
            throw OloError.MissingKeyError
        }
        
        let valueIsNil = (self[key]) is NSNull
        if valueIsNil {
            throw OloError.NullValueError
        }
        
        if let value: T = get(key) {
            return value
        }
        
        throw OloError.UnexpectedTypeError
    }
    
    func get<T>(_ key: String) -> T? {
        guard let value = self[key] as? T else {
            return nil
        }
        
        return value
    }
    
    func keyExists(_ key: String) -> Bool {
        return self[key] != nil
    }
    
    func getDictionary(_ key: String) -> Dictionary<String, Any>? {
        guard let value = self[key] as? Dictionary<String, Any> else {
            return nil
        }
        
        return value
    }
    
    func getArray(_ key: String) -> [Any]? {
        guard let value = self[key] as? [Any] else {
            return nil
        }
        
        return value
    }
}

extension Dictionary<OPCardField, OPCardFieldStateProtocol> {
    public func toDictionary() -> [String: Any] {
        return [
            OPCardField.number.flutterBridgeValue(): self[OPCardField.number]!.toDictionary(),
            OPCardField.expiration.flutterBridgeValue(): self[OPCardField.expiration]!.toDictionary(),
            OPCardField.cvv.flutterBridgeValue(): self[OPCardField.cvv]!.toDictionary(),
            OPCardField.postalCode.flutterBridgeValue(): self[OPCardField.postalCode]!.toDictionary()
        ]
    }
}

