import 'package:flutter/material.dart';

import '../global/app_color.dart';

class SubscriptionDialog {
  static void show({
    required BuildContext context,
    required VoidCallback onPurchase,
    required String type, // 'property', 'project', or 'feature'
    Color primaryColor = AppColor.primaryThemeColor,
    Color iconColor = Colors.orange,
  }) {
    // Define messages based on type
    final messages = {
      'property': {
        'title': 'Upgrade Required',
        'limitMessage': 'You have reached your limit of 2 free property posts.',
        'benefitMessage': 'Buy a subscription plan to post more properties and unlock premium features.',
        'actionText': 'Purchase Plan',
      },
      'project': {
        'title': 'Premium Feature',
        'limitMessage': 'Project posting requires a premium plan.',
        'benefitMessage': 'Upgrade to post projects and get better visibility for your listings.',
        'actionText': 'Purchase Plan',
      },
      'feature': {
        'title': 'Unlock Premium',
        'limitMessage': 'Featured properties are a premium feature.',
        'benefitMessage': 'Subscribe to highlight your properties and get 5x more visibility.',
        'actionText': 'Unlock Feature',
      },
      'developer': {
        'title': 'Unlock Premium',
        'limitMessage': 'Mark as Top developer are a premium feature.',
        'benefitMessage': 'Subscribe to highlight your properties and get 5x more visibility.',
        'actionText': 'Unlock Feature',
      },
      'offer': {
        'title': 'Unlock Premium',
        'limitMessage': 'Promote properties are a premium feature.',
        'benefitMessage': 'Subscribe to highlight your properties and get 5x more visibility.',
        'actionText': 'Unlock Feature',
      },
    }[type] ?? {
      'title': 'Upgrade Required',
      'limit': 'This feature requires a premium plan.',
      'benefit': 'Subscribe to unlock this and other premium features.',
      'action': 'Purchase Plan',
    };

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColor.white,
        title: Row(
          children: [
            Icon(Icons.lock, color: iconColor),
            const SizedBox(width: 8),
            Text(
              messages['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messages['limitMessage']??""),
            const SizedBox(height: 12),
            Text(
              messages['benefitMessage']!,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later',style: TextStyle(color: Colors.grey),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPurchase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  messages['actionText']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}