// lib/screens/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main_screen.dart';

// ============================================
// 🎨 MINIMAL SPLASH THEME
// ============================================
class SplashTheme {
  static const softGradient = LinearGradient(
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF5F5F5),
      Color(0xFFEFEFEF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// ============================================
// 💫 MINIMAL SPLASH SCREEN
// ============================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _heartbeatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:  Brightness.dark,
      ),
    );

    // Fade Animation
    _fadeController = AnimationController(
      duration:  const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent:  _fadeController, curve: Curves.easeOut),
    );

    // Heartbeat Animation
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heartbeatAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve:  Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween:  Tween<double>(begin:  1.15, end: 0.98)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.98, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_heartbeatController);

    // Start animations
    _fadeController.forward();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _heartbeatController.repeat();
      }
    });

    // Navigate
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController.stop();
        _heartbeatController.stop();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionsBuilder: 
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: const BoxDecoration(
          gradient: SplashTheme.softGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity:  _fadeAnimation,
            child:  AnimatedBuilder(
              animation:  _heartbeatAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartbeatAnimation.value,
                  child: child,
                );
              },
              child: _buildLogo(),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ LOGO dengan AURA Teal → Indigo
  Widget _buildLogo() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          // ✅ Aura Luar (Teal Fresh - lebih besar & terang)
          BoxShadow(
            color: const Color(0xFF43C197).withAlpha(128), // Teal Fresh
            blurRadius: 80,
            spreadRadius: 10,
            offset: const Offset(0, 0),
          ),
          // ✅ Aura Tengah (Teal-Indigo mix)
          BoxShadow(
            color: const Color(0xFF2D8B8A).withAlpha(153), // Teal-Indigo
            blurRadius: 50,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
          // ✅ Aura Dalam (Deep Indigo - lebih kecil & pekat)
          BoxShadow(
            color: const Color(0xFF1C1554).withAlpha(102), // Deep Indigo
            blurRadius:  30,
            spreadRadius: 0,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.cover,
          width: 280,
          height:  280,
        ),
      ),
    );
  }
}