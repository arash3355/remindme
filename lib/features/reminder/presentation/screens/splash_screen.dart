import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.onGetStarted});
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 3),

              Center(
                child: Image.asset(
                  'assets/images/remindme_logo.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'RemindMe',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Never forget your task',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.70),
                  letterSpacing: 0.4,
                ),
              ),

              const Spacer(flex: 4),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'App Version 1.0\n© Abdul Rahman Shalehudin - 22552011002',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.45),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
