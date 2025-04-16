// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPPaymentMethodProtocolExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/8/23.
//

import Foundation
import OloPaySDK

private let InvalidExpiration = -1

extension OPPaymentMethodProtocol {
    public func toDictionary() -> [String : Any] {
        return [
            DataKeys.IDKey: self.id,
            DataKeys.Last4Key: self.last4,
            DataKeys.CardTypeKey: self.cardType.description,
            DataKeys.ExpirationMonthKey: self.expirationMonth ?? InvalidExpiration,
            DataKeys.ExpirationYearKey: self.expirationYear ?? InvalidExpiration,
            DataKeys.PostalCodeKey: self.postalCode,
            DataKeys.CountryCodeKey: self.countryCode,
            DataKeys.IsDigitalWalletKey: self.isApplePay,
            DataKeys.ProductionEnvironmentKey: self.environment == .production,
            DataKeys.EmailKey: self.email,
            DataKeys.DigitalWalletCardDescriptionKey: self.applePayCardDescription,
            DataKeys.BillingAddressKey: self.billingAddress.toDictionary(),
            DataKeys.FullNameKey: self.fullName,
            DataKeys.PhoneNumberKey: self.phoneNumber,
        ]
    }
}
