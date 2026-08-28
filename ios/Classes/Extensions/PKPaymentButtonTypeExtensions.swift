// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PKPaymentButtonTypeExtensions.swift
//  Pods
//
//  Created by Justin Anderson on 3/21/25.
//

import PassKit

extension PKPaymentButtonType {
    static func convert(from str: String) -> PKPaymentButtonType {
        switch str {
        case DataKeys.ApplePayButtonTypePlain:
            return .plain
        case DataKeys.ApplePayButtonTypeBuy:
            return .buy
        case DataKeys.ApplePayButtonTypeAddMoney:
            if #available(iOS 14.0, *) {
                return .addMoney
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeBook:
            return .book
        case DataKeys.ApplePayButtonTypeCheckout:
            return .checkout
        case DataKeys.ApplePayButtonTypeContinue:
            if #available(iOS 15.0, *) {
                return .continue
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeContribute:
            if #available(iOS 14.0, *) {
                return .contribute
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeDonate:
            return .donate
        case DataKeys.ApplePayButtonTypeInStore:
            return .inStore
        case DataKeys.ApplePayButtonTypeOrder:
            if #available(iOS 14.0, *) {
                return .order
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeReload:
            if #available(iOS 14.0, *) {
                return .reload
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeRent:
            if #available(iOS 14.0, *) {
                return .rent
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeSetUp:
            return .setUp
        case DataKeys.ApplePayButtonTypeSubscribe:
            return .subscribe
        case DataKeys.ApplePayButtonTypeSupport:
            if #available(iOS 14.0, *) {
                return .support
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeTip:
            if #available(iOS 14.0, *) {
                return .tip
            } else {
                return .checkout
            }
        case DataKeys.ApplePayButtonTypeTopUp:
            if #available(iOS 14.0, *) {
                return .topUp
            } else {
                return .checkout
            }
        default:
            return .checkout
        }
    }
}
