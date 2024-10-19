import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:task_groove/theme/app_textstyle.dart'; // For date formatting

class CalendarWithDateIcon extends StatelessWidget {
  const CalendarWithDateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Get today's day number
    String todayDate = DateFormat('d').format(DateTime.now());

    return Stack(
      alignment: Alignment.center,
      children: [
        const FaIcon(
          FontAwesomeIcons.calendar,
          size: 24,
          color: Colors.green,
        ),
        Positioned(
          bottom: 0,
          child: Text(
            todayDate,
            style: GoogleFonts.manrope(
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
