import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: AppTextStyles.bodyText,
        ),
      ),
      body: Center(
        child: Text(
          "Inbox Page",
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}
