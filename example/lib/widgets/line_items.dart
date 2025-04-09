// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

class LineItems extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double tip;
  final double total;

  const LineItems({
    super.key,
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.tip = 0.0,
    this.total = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Line Items",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                {
                  "Subtotal": subtotal,
                  "Tax": tax,
                  "Tip": tip,
                  "Total": total,
                }.entries.map((entry) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        "\$${entry.value}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
