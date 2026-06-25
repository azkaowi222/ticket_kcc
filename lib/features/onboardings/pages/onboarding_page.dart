import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: deviceHeight * 0.6,
          child: PageView(
            controller: _pageController,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bocil.png',
                    width: 500,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  // SizedBox(height: 20),
                  Text(
                    'Berenang bebas',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rutrum, mi vel placerat tempor, erat metus imperdiet augue.',
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bocil.png',
                    width: 500,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  // SizedBox(height: 20),
                  Text(
                    'Berenang bebas',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque rutrum, mi vel placerat tempor, erat metus imperdiet augue.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          onDotClicked: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
