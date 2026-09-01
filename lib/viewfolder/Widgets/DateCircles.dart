import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final void Function(DateTime)? onDateSelected; // optional callback

  const DateSelector({super.key, this.onDateSelected});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int selectedIndex = 0;
  final int daysToShow = 14; 
  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysToShow,
        itemBuilder: (context, index) {
          DateTime date = today.add(Duration(days: index));
          bool isSelected = selectedIndex == index;

          String dayName =
              index == 0 ? "Today" : DateFormat('E').format(date);
          String dayNumber = DateFormat('d MMM').format(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              // 🔹 Pass selected date to parent
              widget.onDateSelected?.call(date);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 224, 219, 219)
                    : colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.tinos(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNumber,
                    style: GoogleFonts.tinos(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
