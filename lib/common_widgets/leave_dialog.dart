import 'dart:ui';

import 'package:flutter/material.dart';

class LeaveDialog extends StatefulWidget {
  final String title;
  final String yesText;
  final String noText;
  final Function onYesAction;

  LeaveDialog(
      {required this.title,
      required this.yesText,
      required this.noText,
      required this.onYesAction});

  @override
  _LeaveDialogState createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<LeaveDialog> {
  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: _getDialogLayout(context),
          ),
        ),
      );

  _getDialogLayout(BuildContext context) => SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            //color: Colors.red,
                            onPressed: () {
                              dismissAlertDialog(context);

                              if (widget.onYesAction != null) {
                                widget.onYesAction();
                              }
                            },
                            child: Text(
                              widget.yesText,
                              // style: TextStyle(color: Colors.blue),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          //color: Colors.grey,
                          onPressed: () {
                            dismissAlertDialog(context);
                          },
                          child: Text(widget.noText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

void dismissAlertDialog(BuildContext context) {
  Navigator.pop(context);
}

Future<dynamic> showCallLeaveDialog(BuildContext context, String title,
    String yesText, String noText, Function onYesAction) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return LeaveDialog(
        title: title,
        yesText: yesText,
        noText: noText,
        onYesAction: onYesAction,
      );
    },
  );
}
