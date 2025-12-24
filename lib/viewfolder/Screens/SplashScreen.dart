import 'package:agitha/viewfolder/Screens/OnboardScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showImage = true;
      });
    });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoardScreen()));
    });


  }





  @override
  Widget build(BuildContext context) {
    //colorscheme
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
   
      body:Center(
        child: AnimatedSlide(
          offset:_showImage ? Offset.zero:
          const Offset(0, 0.3), 
          duration:const Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _showImage ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: Image.asset('assets/agithaicon.png',width: 200,height: 200,color:  colorScheme.primary,),
          ),
        
        
      
      )
    ));
  }
}