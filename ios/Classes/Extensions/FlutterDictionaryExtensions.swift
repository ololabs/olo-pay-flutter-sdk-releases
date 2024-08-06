//
//  FlutterDictionaryExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 4/25/24.
//

import Foundation
import Flutter

// MARK: Non-Null Extension Methods
extension Dictionary where Key == String {
    func getOrErrorResult<T>(
        for key: String,
        withDefault defaultValue: T,
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> T {
        do {
            return try self.getOrThrow(key, defaultValue: defaultValue)
        } catch let error {
            result(FlutterError(
                code: ErrorCodes.UnexpectedParameterType,
                message: "\(baseError): Value for '\(key)' is not of type \(String(describing: T.self))",
                details: nil
            ))
                        
            throw error
        }
    }
    
    func getOrErrorResult<T>(
        for key: String,
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> T {
        var errorMessage: String = ""
        var errorCode: String = ""
        var oloError: OloError? = nil
        
        do {
            return try self.getOrThrow(key)
        } catch let error as OloError where error == .MissingKeyError {
            errorMessage = "\(baseError): Missing parameter '\(key)'"
            errorCode = ErrorCodes.MissingParameter
            oloError = error
        } catch let error as OloError where error == .NullValueError {
            errorMessage = "\(baseError): Missing parameter '\(key)'"
            errorCode = ErrorCodes.MissingParameter
            oloError = error
        } catch { // OloError.UnexpectedTypeError
            errorMessage = "\(baseError): Value for '\(key)' is not of type \(String(describing: T.self))"
            errorCode = ErrorCodes.UnexpectedParameterType
            oloError = OloError.UnexpectedTypeError
        }
        
        result(FlutterError(
            code: errorCode,
            message: errorMessage,
            details: nil
        ))
        
        throw oloError!
    }
    
    func getStringOrErrorResult(
        for key: String,
        withDefault defaultValue: String,
        baseError: String,
        acceptEmptyValue: Bool,
        result: @escaping FlutterResult
    ) throws -> String {
        do {
            var value: String = try self.getOrThrow(key, defaultValue: defaultValue)
            value = value.trim()
            
            if !acceptEmptyValue && value.isEmpty {
                value = defaultValue
            }
            
            return value
        } catch let error {
            result(FlutterError(
                code: ErrorCodes.UnexpectedParameterType,
                message: "\(baseError): Value for '\(key)' is not of type String",
                details: nil
            ))
            
            throw error
        }
    }
    
    func getStringOrErrorResult(
        for key: String,
        baseError: String,
        acceptEmptyValue: Bool,
        result: @escaping FlutterResult
    ) throws -> String {
        var value: String = try self.getOrErrorResult(
            for: key,
            baseError: baseError,
            result: result
        )
        
        value = value.trim()
        
        if !acceptEmptyValue && value.isEmpty {
            result(FlutterError(
                code: ErrorCodes.InvalidParameter,
                message: "\(baseError): Value for '\(key)' cannot be empty",
                details: nil
            ))
            throw OloError.EmptyValueError
        }
        
        return value
    }
}

// MARK: Nullable Dictionary Extension Methods
extension Optional where Wrapped == Dictionary<String, Any> {
    func getOrErrorResult<T>(
        for key: String,
        withDefault defaultValue: T,
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> T {
        guard let args = self else {
            result(FlutterError(
                   code: ErrorCodes.MissingParameter,
                   message: "\(baseError): Arguments dictionary is nil",
                   details: nil
            ))
            
            throw OloError.NullValueError
        }
        
        return try args.getOrErrorResult(
            for: key,
            withDefault: defaultValue,
            baseError: baseError,
            result: result
        )
    }
    
    func getOrErrorResult<T>(
        for key: String,
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> T {
        guard let args = self else {
            result(FlutterError(
                   code: ErrorCodes.MissingParameter,
                   message: "\(baseError): Arguments dictionary is nil",
                   details: nil
            ))
            
            throw OloError.NullValueError
        }
        
        return try args.getOrErrorResult(
            for: key,
            baseError: baseError,
            result: result
        )
    }
    
    func getStringOrErrorResult(
        for key: String,
        withDefault defaultValue: String,
        baseError: String,
        acceptEmptyValue: Bool,
        result: @escaping FlutterResult
    ) throws -> String {
        guard let args = self else {
            result(FlutterError(
                   code: ErrorCodes.MissingParameter,
                   message: "\(baseError): Arguments dictionary is nil",
                   details: nil
            ))
            
            throw OloError.NullValueError
        }
        
        return try args.getStringOrErrorResult(
            for: key,
            withDefault: defaultValue,
            baseError: baseError,
            acceptEmptyValue: acceptEmptyValue,
            result: result
        )
    }
    
    func getStringOrErrorResult(
        for key: String,
        baseError: String,
        acceptEmptyValue: Bool,
        result: @escaping FlutterResult
    ) throws -> String {
        guard let args = self else {
            result(FlutterError(
                   code: ErrorCodes.MissingParameter,
                   message: "\(baseError): Arguments dictionary is nil",
                   details: nil
            ))
            
            throw OloError.NullValueError
        }
        
        return try args.getStringOrErrorResult(
            for: key,
            baseError: baseError,
            acceptEmptyValue: acceptEmptyValue,
            result: result
        )
    }
}
