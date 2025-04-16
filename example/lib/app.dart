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
        scaffoldBackgroundColor: const Color.fromRGBO(232, 234, 251, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(232, 234, 251, 1),
          brightness: Brightness.light,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(45, 150, 255, 1),
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(69, 72, 94, 1),
            );
          }),
          backgroundColor: const Color.fromRGBO(197, 202, 232, 1),
          indicatorColor: const Color.fromRGBO(197, 202, 232, 1),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(36, 39, 52, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(36, 39, 52, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(232, 234, 251, 1),
          brightness: Brightness.dark,
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(45, 150, 255, 1),
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(232, 234, 251, 1),
            );
          }),
          backgroundColor: const Color.fromARGB(255, 14, 12, 12),
          indicatorColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(69, 72, 94, 1),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(232, 234, 251, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
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

      // Step 3: Initialize the Olo Pay SDK
      await _oloPaySdkPlugin.initializeOloPay(
        productionEnvironment: false,
        digitalWalletConfig: const DigitalWalletConfiguration(
          companyLabel: "SDK Test",
          applePayConfig: ApplePayConfiguration(
            merchantId: "merchant.com.olopaysdktestharness2",
          ),
          googlePayConfig: GooglePayConfiguration(productionEnvironment: false),
        ),
      );

      // We do this just to test that the isOloPayInitialized() method is working
      // properly. If initializeOloPay() succeeds there is no need for this
      // method call in a production app... just directly set state to true
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
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 65,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          _buildNavItem(Icons.credit_card, 'Credit Card', 0),
          _buildNavItem(Icons.wallet, 'Digital Wallet', 1),
          _buildNavItem(Icons.payments, 'CVV', 2),
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
          digitalWalletReady: _digitalWalletsReady,
        ),
      ][currentPageIndex],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;

    Color iconColor = currentPageIndex == index
        ? const Color.fromRGBO(45, 150, 255, 1)
        : brightness == Brightness.dark
            ? const Color.fromRGBO(232, 234, 251, 1)
            : const Color.fromRGBO(69, 72, 94, 1);

    return NavigationDestination(
      icon: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: currentPageIndex == index
                    ? const Color.fromRGBO(45, 150, 255, 1)
                    : Colors.transparent,
              ),
            ),
            Icon(icon, color: iconColor),
          ],
        ),
      ),
      label: label,
    );
  }
}
