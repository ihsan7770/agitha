import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/Screens/OnboardScreen.dart';

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
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _showImage = true;
    });

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 2));

    _checkRoleAndNavigate();
  }

  void _checkRoleAndNavigate() {
    final provider = context.read<AuthenticationController>();

    provider.getUserRoleStream().first.then((role) {

      if (!mounted) return;

      if (role == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnBoardScreen()),
        );
        return;
      }

      switch (role.toLowerCase()) {
        case 'delivery':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DeliveryBoyMainPage()),
          );
          break;

        case 'company':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CompanyMainPage()),
          );
          break;

        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserMainPage()),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: AnimatedSlide(
          offset: _showImage ? Offset.zero : const Offset(0, 0.4),
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _showImage ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: Image.asset(
              'assets/agithaicon.png',
              width: 200,
              height: 200,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}