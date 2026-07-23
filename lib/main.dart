import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/forgefit_app.dart';

final _fatalStartupError = ValueNotifier<Object?>(null);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _fatalStartupError.value ??= details.exception;
  };
  PlatformDispatcher.instance.onError = (error, _) {
    _fatalStartupError.value ??= error;
    return true;
  };

  runZonedGuarded(
    () => runApp(const _ForgeFitRoot()),
    (error, _) => _fatalStartupError.value ??= error,
  );
}

class _ForgeFitRoot extends StatelessWidget {
  const _ForgeFitRoot();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Object?>(
      valueListenable: _fatalStartupError,
      builder: (context, error, _) {
        if (error != null) {
          return MaterialApp(
            title: 'ForgeFit',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(useMaterial3: true),
            home: _StartupFailureScreen(
              errorType: error.runtimeType.toString(),
            ),
          );
        }
        return const ProviderScope(child: ForgeFitApp());
      },
    );
  }
}

class _StartupFailureScreen extends StatelessWidget {
  const _StartupFailureScreen({required this.errorType});

  final String errorType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFFF6B78),
                  size: 54,
                ),
                const SizedBox(height: 18),
                Text(
                  'ForgeFit could not finish starting',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Close the app, install the latest build, and try again. '
                  'If this continues, share this reference with support.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text('Reference: $errorType'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
