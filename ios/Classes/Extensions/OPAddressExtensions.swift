// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import Foundation
import OloPaySDK

extension OPAddressProtocol {
    // Empty string values are placeholders used by Google Pay but not by Apple Pay.
    // These placeholders are included to ensure consistency in the data format across both platforms 
    // when the data is passed through the Flutter bridge.
    public func toDictionary() -> [String: String] {
        return [
            DataKeys.Address1Key: self.street,
            DataKeys.Address2Key: "",
            DataKeys.Address3Key: "",
            DataKeys.LocalityKey: self.city,
            DataKeys.AdministrativeAreaKey: self.state,
            DataKeys.PostalCodeKey: self.postalCode,
            DataKeys.CountryCodeKey: self.countryCode,
            DataKeys.SortingCodeKey: ""
        ]
    }
}
