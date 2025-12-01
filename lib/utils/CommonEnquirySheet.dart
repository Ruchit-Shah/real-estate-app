import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonBottomSheet extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final TextEditingController messageController;
  final VoidCallback onSubmit;
  final String submitButtonText;

  const CommonBottomSheet({
    Key? key,
    required this.title,
    required this.formKey,
    required this.messageController,
    required this.onSubmit,
    required this.submitButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: MediaQuery.of(context).viewInsets.top,
        right: 10,
        left: 10,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      size: 30,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              // Custom TextFormField
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Enter Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    onSubmit();
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Please fill all required fields',
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueGrey,
                  ),
                  child: Text(
                    submitButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
