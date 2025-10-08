// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentButtonsWidget extends StatefulWidget {
  final Function createPaymentMethod;
  final Function clear;
  final List<Map<String, dynamic>> buttonData;
  final bool? showSingleLineCardDetailsView;

  const PaymentButtonsWidget({
    Key? key,
    required this.createPaymentMethod,
    required this.clear,
    required this.buttonData,
    this.showSingleLineCardDetailsView,
  }) : super(key: key);

  @override
  State<PaymentButtonsWidget> createState() => _PaymentButtonsWidget();
}

class _PaymentButtonsWidget extends State<PaymentButtonsWidget> {
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  bool get isIosForm =>
      widget.showSingleLineCardDetailsView != true && !isAndroid;

  void _showMoreModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (BuildContext context) {
        final filteredButtonData = widget.buttonData.where((button) {
          if (widget.showSingleLineCardDetailsView == false &&
              ["Has Error?", "Errors", "State"].contains(button['label'])) {
            // Filter out buttons for methods not available on either Form view
            return false;
          }
          if (isIosForm &&
              ["Card Type", "Clear Fields"].contains(button['label'])) {
            // Filter out buttons for methods not available on the iOS Form view
            return false;
          }
          return true;
        }).toList();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3,
            shrinkWrap: true,
            children: [
              ...filteredButtonData.map((button) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(45, 150, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: button['onPressed'],
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      button['label'],
                      style: const TextStyle(
                        color: Color.fromRGBO(232, 235, 251, 1),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(45, 150, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => widget.createPaymentMethod(),
              child: const Text(
                "Submit",
                style: TextStyle(color: Color.fromRGBO(232, 235, 251, 1)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(45, 150, 255, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: (widget.showSingleLineCardDetailsView == false &&
                      defaultTargetPlatform == TargetPlatform.iOS)
                  ? null
                  : () => widget.clear(),
              child: const Text(
                "Clear Card",
                style: TextStyle(color: Color.fromRGBO(232, 235, 251, 1)),
              ),
            ),
            TextButton.icon(
              icon: const Text("Show More"),
              label: const Icon(Icons.arrow_forward_ios_rounded, size: 18.0),
              onPressed: () {
                _showMoreModal(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
