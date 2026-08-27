// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PaymentCardDetailsFormViewFactory.swift
//  olo_pay_sdk
//
//  Created by Richard Dowdy on 2/27/25.
//

import Foundation
import Flutter

class PaymentCardDetailsFormViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return PaymentCardDetailsFormView(
            withFrame: frame,
            viewId: viewId,
            args: args,
            messenger: messenger
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}
