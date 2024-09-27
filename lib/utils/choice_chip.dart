import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PriorityChips extends StatefulWidget {
  const PriorityChips({super.key});

  @override
  _PriorityChipsState createState() => _PriorityChipsState();
}

class _PriorityChipsState extends State<PriorityChips> {
  // This will hold the currently selected priority
  String _selectedPriority = 'Low';

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center, // Align chips horizontally
      children: [
        // High Priority Chip
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.sp)),
          label: Text(
            'High',
            style: GoogleFonts.manrope(
              color: _selectedPriority == 'High' ? Colors.white : Colors.black,
            ),
          ),
          selected: _selectedPriority == 'High',
          selectedColor: Colors.red, // Color when chip is selected
          onSelected: (bool selected) {
            setState(() {
              _selectedPriority = 'High';
            });
          },
        ),
        const SizedBox(width: 10), // Add space between chips

        // Medium Priority Chip
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.sp)),
          label: Text(
            'Medium',
            style: GoogleFonts.manrope(
              color:
                  _selectedPriority == 'Medium' ? Colors.white : Colors.black,
            ),
          ),
          selected: _selectedPriority == 'Medium',
          selectedColor: Colors.orange,
          onSelected: (bool selected) {
            setState(() {
              _selectedPriority = 'Medium';
            });
          },
        ),
        const SizedBox(width: 10),

        // Low Priority Chip
        ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.sp)),
          label: Text(
            'Low',
            style: GoogleFonts.manrope(
              color: _selectedPriority == 'Low' ? Colors.white : Colors.black,
            ),
          ),
          selected: _selectedPriority == 'Low',
          selectedColor: Colors.green,
          onSelected: (bool selected) {
            setState(() {
              _selectedPriority = 'Low';
            });
          },
        ),
      ],
    );
  }
}
