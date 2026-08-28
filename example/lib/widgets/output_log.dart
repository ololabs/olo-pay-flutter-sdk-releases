// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutputLogWidget extends StatefulWidget {
  final String logText;
  final VoidCallback clearLog;

  const OutputLogWidget({
    Key? key,
    required this.logText,
    required this.clearLog,
  }) : super(key: key);

  @override
  OutputLogWidgetState createState() => OutputLogWidgetState();
}

class OutputLogWidgetState extends State<OutputLogWidget> {
  bool _isCopied = false;

  void _copyToClipboard() async {
    final text = widget.logText;
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));

      if (mounted) {
        setState(() {
          _isCopied = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isCopied = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;
    Color boxColor = brightness == Brightness.light
        ? const Color.fromRGBO(197, 202, 232, 1)
        : const Color.fromRGBO(69, 72, 94, 1);

    Color borderColor = brightness == Brightness.light
        ? const Color.fromRGBO(197, 202, 232, 1)
        : const Color.fromRGBO(69, 72, 94, 1);

    Color outputLogColor = brightness == Brightness.light
        ? const Color.fromRGBO(36, 39, 52, 1)
        : const Color.fromRGBO(232, 235, 251, 1);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Output Log:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                icon: Icon(_isCopied ? Icons.check : Icons.copy),
                onPressed: _copyToClipboard,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                maxLines: null,
                controller: TextEditingController(text: widget.logText),
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: outputLogColor, fontSize: 14.0),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(45, 150, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: widget.clearLog,
            child: const Text(
              "Clear Log",
              style: TextStyle(color: Color.fromRGBO(232, 235, 251, 1)),
            ),
          ),
        ),
      ],
    );
  }
}
