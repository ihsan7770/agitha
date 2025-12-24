
import 'dart:ui';

import 'package:flutter/material.dart';

class Customshape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, height-50);


    path.quadraticBezierTo(width/4, height-100, width/2, height-50);
    path.quadraticBezierTo(3 * width /4, height, width, height-70);



    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}