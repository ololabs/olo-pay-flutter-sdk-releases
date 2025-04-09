// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  FontError.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 2/21/24.
//

import Foundation

enum OloError: Error {
    case AssetNotFoundError
    case FontLoadError
    case FontNameError
    case UnexpectedError
    case UnexpectedTypeError
    case MissingKeyError
    case EmptyValueError
    case NullValueError
}
