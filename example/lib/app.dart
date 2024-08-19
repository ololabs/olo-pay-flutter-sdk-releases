// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:olo_pay_sdk_example/pages/card_details_page.dart';
import 'package:olo_pay_sdk_example/pages/cvv_page.dart';
import 'package:olo_pay_sdk_example/pages/digital_wallets_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Olo Pay SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(1, 160, 219, 1)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const NavigationWrapper(),
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  // Step 1: Create the plugin instance
  final _oloPaySdkPlugin = OloPaySdk();
  int currentPageIndex = 0;
  String _error = '';
  bool _sdkInitialized = false;
  bool _digitalWalletsReady = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onDigitalWalletReady(bool isReady) {
    setState(() {
      _digitalWalletsReady = isReady;
    });
  }

  Future<void> initPlatformState() async {
    var sdkInitialized = false;
    try {
      // Step 2: Add a digital wallet listener
      _oloPaySdkPlugin.onDigitalWalletReady = onDigitalWalletReady;

      const OloPaySetupParameters sdkParams = OloPaySetupParameters(
        productionEnvironment: false,
      );

      const GooglePaySetupParameters googlePayParams = GooglePaySetupParameters(
        countryCode: "US",
        merchantName: "Foosburgers",
        productionEnvironment: false,
      );

      const ApplePaySetupParameters applePayParams = ApplePaySetupParameters(
        merchantId: "merchant.com.olopaysdktestharness",
        companyLabel: "SDK Test",
      );

      // Step 3: Initialize the Olo Pay SDK
      await _oloPaySdkPlugin.initializeOloPay(
        oloPayParams: sdkParams,
        googlePayParams: googlePayParams,
        applePayParams: applePayParams,
      );

      // If initializeOloPay() succeeds there is no need for this method call in a production app... just directly set state to true
      //We do this just to test that the isOloPayInitialized() method is working properly.
      sdkInitialized = await _oloPaySdkPlugin.isOloPayInitialized();
    } on PlatformException catch (e) {
      updateError(e.message!);
    }

    setState(() {
      _sdkInitialized = sdkInitialized;
    });
  }

  void updateError(String error) {
    setState(() {
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromRGBO(1, 160, 219, 1),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet),
            label: 'Digital Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments),
            label: 'CVV',
          ),
        ],
      ),
      body: <Widget>[
        CardDetailsPage(
          sdkInitialized: _sdkInitialized,
          digitalWalletReady: _digitalWalletsReady,
        ),
        DigitalWalletsPage(
          sdkInitialized: _sdkInitialized,
          digitalWalletReady: _digitalWalletsReady,
          oloPaySdkPlugin: _oloPaySdkPlugin,
        ),
        CvvPage(
          sdkInitialized: _sdkInitialized,
        ),
      ][currentPageIndex],
    );
  }
}
