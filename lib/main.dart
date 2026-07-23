import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/forgefit_app.dart';

final ValueNotifier<_FatalAppError?> _fatalError =
    ValueNotifier<_FatalAppError?>(null);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _fatalError.value = _FatalAppError(
      details.exceptionAsString(),
      details.stack?.toString() ?? '',
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _fatalError.value = _FatalAppError(error.toString(), stack.toString());
    return true;
  };

  ErrorWidget.builder = (details) {
    return _DiagnosticErrorView(
      title: 'ForgeFit screen error',
      message: details.exceptionAsString(),
      stack: details.stack?.toString() ?? '',
    );
  };

  runZonedGuarded(
    () => runApp(const _DiagnosticRoot()),
    (error, stack) {
      _fatalError.value = _FatalAppError(error.toString(), stack.toString());
    },
  );
}

class _DiagnosticRoot extends StatelessWidget {
  const _DiagnosticRoot();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_FatalAppError?>(
      valueListenable: _fatalError,
      builder: (context, error, child) {
        if (error != null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              body: _DiagnosticErrorView(
                title: 'ForgeFit startup error',
                message: error.message,
                stack: error.stack,
              ),
            ),
          );
        }
        return const ProviderScope(child: ForgeFitApp());
      },
    );
  }
}

class _FatalAppError {
  const _FatalAppError(this.message, this.stack);

  final String message;
  final String stack;
}

class _DiagnosticErrorView extends StatelessWidget {
  const _DiagnosticErrorView({
    required this.title,
    required this.message,
    required this.stack,
  });

  final String title;
  final String message;
  final String stack;

  @override
  Widget build(BuildContext context) {
    final stackLines = stack
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .take(18)
        .join('\n');

    return ColoredBox(
      color: const Color(0xFF090B0E),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF6B78),
                size: 56,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Take a screenshot of this page and send it in the chat.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFA7B0BB), height: 1.4),
              ),
              const SizedBox(height: 22),
              SelectableText(
                message,
                style: const TextStyle(
                  color: Color(0xFFFFC4CA),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              if (stackLines.isNotEmpty) ...[
                const SizedBox(height: 18),
                SelectableText(
                  stackLines,
                  style: const TextStyle(
                    color: Color(0xFF9CA6B2),
                    fontFamily: 'monospace',
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
