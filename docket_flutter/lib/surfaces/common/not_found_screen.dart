import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../shared/strings.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(CommonStrings.notFoundTitle, style: text.headlineMedium),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => web.window.location.assign('/'),
                child: const Text(CommonStrings.notFoundAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
