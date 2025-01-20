import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:task_groove/theme/app_textstyle.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RateUsScreen extends StatefulWidget {
  const RateUsScreen({super.key});

  @override
  State<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  late final WebViewController controller;

  final String googleFormUrl = dotenv.env['GOOGLE_FORM_URL'] ?? "";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(googleFormUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate Us',
          style: AppTextStyles.headingBold.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          color: Colors.white,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
