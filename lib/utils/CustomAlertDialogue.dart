import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String yesText;
  final String noText;
  final VoidCallback onYesPressed; // Callback function for Yes button

  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.yesText,
    required this.noText,
    required this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[50],
      title: Text(
        title,
        style: TextStyle(color: Colors.black87),
      ),
      content: Wrap(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  content,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: ElevatedButton(
                        onPressed: onYesPressed, // Call the callback function
                        child: Text(
                          yesText,
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false); // Return 'false' when 'No' is pressed
                        },
                        child: Text(
                          noText,
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          minimumSize: const Size(70, 30),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
