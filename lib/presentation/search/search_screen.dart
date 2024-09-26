// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Search Page",
          style: AppTextStyles.bodyText,
        ),
      ),
    );
  }
}
