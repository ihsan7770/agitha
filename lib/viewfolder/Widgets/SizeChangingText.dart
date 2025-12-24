import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText({super.key});

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  final String text =
      "Born in Monte-Carlo, full of contrasts, our brand breaks with rigid, traditional codes "
      "Through its glamorous architectural lines & bold menu, we re-think food and "
      "of contact for customers, ensuring they feel welcomed and attended to. Their role is crucial "
      "in delivering exceptional customer service and creating a positive first impression.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "Read Less" : "Read More",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red, // 🔴 red color text
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
