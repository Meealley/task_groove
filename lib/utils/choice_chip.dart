import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PriorityChips extends StatefulWidget {
  final Function(int) onSelected;

  const PriorityChips({super.key, required this.onSelected});

  @override
  _PriorityChipsState createState() => _PriorityChipsState();
}

class _PriorityChipsState extends State<PriorityChips> {
  // This will hold the currently selected priority
  int _selectedPriority = 3;

  void _updatePriority(int priority) {
    setState(() {
      _selectedPriority = priority;
    });
    widget.onSelected(priority);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center, // Align chips horizontally
      children: [
        // High Priority Chip
        ChoiceChip(
            showCheckmark: false,
            avatar: const FaIcon(
              FontAwesomeIcons.bity,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.sp)),
            label: Text(
              'High',
              style: GoogleFonts.manrope(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
                color: _selectedPriority == 1 ? Colors.white : Colors.black,
              ),
            ),
            selected: _selectedPriority == 1,
            selectedColor: Colors.red, // Color when chip is selected
            onSelected: (_) => _updatePriority(1)),
        const SizedBox(width: 10), // Add space between chips

        // Medium Priority Chip
        ChoiceChip(
            showCheckmark: false,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.sp)),
            label: Text(
              'Medium',
              style: GoogleFonts.manrope(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
                color: _selectedPriority == 2 ? Colors.white : Colors.black,
              ),
            ),
            selected: _selectedPriority == 2,
            selectedColor: Colors.orange,
            onSelected: (_) => _updatePriority(2)),
        const SizedBox(width: 10),

        // Low Priority Chip
        ChoiceChip(
            showCheckmark: false,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.sp)),
            label: Text(
              'Low',
              style: GoogleFonts.manrope(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
                color: _selectedPriority == 3 ? Colors.white : Colors.black,
              ),
            ),
            selected: _selectedPriority == 3,
            selectedColor: Colors.green,
            onSelected: (_) => _updatePriority(3)),
      ],
    );
  }
}
