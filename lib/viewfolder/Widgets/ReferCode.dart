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

    // Hide after 1.5 seconds
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Your Code: REF12345",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          // Wrap Stack with Clip.none to allow overflow
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: _copyCode,
                icon: const Icon(Icons.copy, color: Colors.teal),
              ),
              if (_showCopied)
                Positioned(
                  top: -30, // show above icon
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Copied!",
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
