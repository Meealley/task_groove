import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_groove/theme/app_textstyle.dart';

class ProfileThemeCard extends StatelessWidget {
  final Color color;
  final String themeTitle;
  final bool isSelected;
  const ProfileThemeCard({
    super.key,
    required this.color,
    required this.themeTitle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            // color: Colors.red,
            child: Row(
              children: [
                Text(
                  themeTitle,
                  style: AppTextStyles.bodyTextBold.copyWith(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(right: 15),
            leading: Checkbox(
              value: isSelected,
              onChanged: (_) {
                print("Theme tapped");
              },
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
            trailing: isSelected
                ? const FaIcon(
                    FontAwesomeIcons.check,
                    size: 20,
                    color: Colors.black,
                  )
                : null,
          )
        ],
      ),
    );
  }
}
