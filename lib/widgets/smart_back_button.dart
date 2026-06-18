import 'package:flutter/material.dart';

class SmartBackButton extends StatelessWidget {
  const SmartBackButton({super.key, required this.fallbackPageBuilder});

  final WidgetBuilder fallbackPageBuilder;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        final navigator = Navigator.of(context);

        if (navigator.canPop()) {
          navigator.pop();
          return;
        }

        navigator.pushReplacement(
          MaterialPageRoute(builder: fallbackPageBuilder),
        );
      },
    );
  }
}
