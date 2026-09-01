import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferCodeWidget extends StatefulWidget {
  const ReferCodeWidget({super.key});

  @override
  State<ReferCodeWidget> createState() => _ReferCodeWidgetState();
}

class _ReferCodeWidgetState extends State<ReferCodeWidget> {
  bool _showCopied = false;

  void _copyCode() {
    Clipboard.setData(const ClipboardData(text: "REF12345"));

    setState(() {
      _showCopied = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(size.width * 0.025),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your Code: REF12345",
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Copy Icon + Tooltip
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: _copyCode,
                icon: Icon(
                  Icons.copy,
                  color: Colors.teal,
                  size: size.width * 0.06,
                ),
              ),

              if (_showCopied)
                Positioned(
                  top: -size.height * 0.04,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius:
                            BorderRadius.circular(size.width * 0.015),
                      ),
                      child: Text(
                        "Copied!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
