import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreparingLoader extends StatefulWidget {
  final double fontSize;
  final Color color;
  const PreparingLoader({
    super.key,
    this.fontSize = 12,
    required this.color,
  });

  @override
  State<PreparingLoader> createState() => _PreparingLoaderState();
}

class _PreparingLoaderState extends State<PreparingLoader> {
  int dotIndex = 0;
  final List<String> dots = ["", ".", "..", "..."];

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() => dotIndex = (dotIndex + 1) % dots.length);
      return true;
    });
  }

 @override
Widget build(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "Preparing",
        style: GoogleFonts.tinos(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w600,
          color: widget.color,
        ),
      ),
      SizedBox(
        width: widget.fontSize * 2, // width enough for 3 dots
        child: Text(
          dots[dotIndex],
          style: GoogleFonts.tinos(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
            color: widget.color,
          ),
          textAlign: TextAlign.left,
        ),
      )
    ],
  );
}

}
