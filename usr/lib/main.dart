import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  runApp(const LoveCalculatorApp());
}

class LoveCalculatorApp extends StatelessWidget {
  const LoveCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Holographic Love Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyanAccent,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoveCalculatorScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.purple, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 6.28,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyan.withOpacity(_animation.value),
                            Colors.pink.withOpacity(_animation.value),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'Holographic Love Calculator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.cyanAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Discover Your Love Percentage',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoveCalculatorScreen extends StatefulWidget {
  const LoveCalculatorScreen({super.key});

  @override
  State<LoveCalculatorScreen> createState() => _LoveCalculatorScreenState();
}

class _LoveCalculatorScreenState extends State<LoveCalculatorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  double _lovePercentage = 0.0;
  bool _calculated = false;
  late AnimationController _percentageController;
  late Animation<double> _percentageAnimation;

  @override
  void initState() {
    super.initState();
    _percentageController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _percentageAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(_percentageController);
  }

  @override
  void dispose() {
    _name1Controller.dispose();
    _name2Controller.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  int _calculateLovePercentage(String name1, String name2) {
    String combined = (name1 + name2).toLowerCase();
    int total = 0;
    for (int i = 0; i < combined.length; i++) {
      total += combined.codeUnitAt(i);
    }
    return (total % 100) + 1; // Ensure it's between 1 and 100
  }

  void _calculateLove() {
    if (_name1Controller.text.isEmpty || _name2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both names')),
      );
      return;
    }

    setState(() {
      _calculated = true;
      int percentage = _calculateLovePercentage(
        _name1Controller.text,
        _name2Controller.text,
      );
      _percentageAnimation = Tween<double>(begin: 0.0, end: percentage.toDouble())
          .animate(CurvedAnimation(
        parent: _percentageController,
        curve: Curves.elasticOut,
      ));
      _percentageController.forward(from: 0.0);
      _lovePercentage = percentage.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Love Calculator',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.cyanAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildHolographicTextField(
                  controller: _name1Controller,
                  label: 'Your Name',
                ),
                const SizedBox(height: 20),
                _buildHolographicTextField(
                  controller: _name2Controller,
                  label: 'Partner\'s Name',
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _calculateLove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.cyanAccent,
                    elevation: 10,
                  ),
                  child: const Text(
                    'Calculate Love',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 60),
                if (_calculated) ...[
                  AnimatedBuilder(
                    animation: _percentageAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.pink.withOpacity(0.8),
                                  Colors.red.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pinkAccent.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Colors.cyanAccent,
                                  Colors.pinkAccent,
                                  Colors.purpleAccent,
                                  Colors.cyanAccent,
                                ],
                                stops: [0.0, 0.25, 0.5, 1.0],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${_percentageAnimation.value.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.white,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _getLoveMessage(_lovePercentage.toInt()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHolographicTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.1),
            Colors.purpleAccent.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  String _getLoveMessage(int percentage) {
    if (percentage >= 90) {
      return 'Soulmates! Your love is eternal and unbreakable!';
    } else if (percentage >= 70) {
      return 'Amazing compatibility! You\'re perfect for each other!';
    } else if (percentage >= 50) {
      return 'Good match! Work on your relationship for better results.';
    } else if (percentage >= 30) {
      return 'Fair chance. Communication is key!';
    } else {
      return 'Keep looking. The right one is out there!';
    }
  }
}