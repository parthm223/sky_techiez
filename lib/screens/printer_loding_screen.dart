import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_techiez/screens/printer_support_screen.dart';

class PrinterLoadingScreen extends StatefulWidget {
  final String printerName;
  const PrinterLoadingScreen({
    super.key,
    required this.printerName,
  });
  @override
  State<PrinterLoadingScreen> createState() => _PrinterLoadingScreenState();
}

class _PrinterLoadingScreenState extends State<PrinterLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _progressController;

  final List<String> steps = [
    'Detecting printer model...',
    'Checking compatibility...',
    'Preparing setup guidance...',
    'Finding available resources...',
  ];

  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();

    Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (currentStep < steps.length - 1) {
        setState(() {
          currentStep++;
        });
      } else {
        timer.cancel();

        // NEXT SCREEN
        Get.off(
          () => PrinterSupportScreen(
            printerName: widget.printerName,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF020617),
              Color(0xFF040B22),
              Color(0xFF020617),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GLOW PRINTER
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        height: 230,
                        width: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82FF).withOpacity(
                                0.4 + (_glowController.value * 0.4),
                              ),
                              blurRadius: 60 + (_glowController.value * 40),
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF3B82FF),
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Horizontal Glow Line
                              Container(
                                height: 3,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF4EA1FF).withOpacity(0.9),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.print_rounded,
                                size: 95,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 70),

                  // TEXTS
                  Column(
                    children: List.generate(
                      steps.length,
                      (index) {
                        final isActive = index == currentStep;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: index <= currentStep ? 1 : 0.3,
                            child: Text(
                              steps[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.white38,
                                fontSize: 24,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 45),

                  // PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white12,
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.75 *
                                  _progressController.value,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4FC3FF),
                                    Color(0xFF3D63FF),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // FLOATING DOTS
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 18,
                    runSpacing: 18,
                    children: List.generate(
                      16,
                      (index) => TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: 0.3,
                          end: 1,
                        ),
                        duration: Duration(
                          milliseconds: 600 + (index * 120),
                        ),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Container(
                              height: 10 + (index % 3) * 4,
                              width: 10 + (index % 3) * 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4EA1FF),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4EA1FF)
                                        .withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
