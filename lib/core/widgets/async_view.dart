import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'placeholder_view.dart';

/// FutureBuilder wrapper with consistent loading and error states.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.future,
    required this.builder,
    this.onRetry,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PlaceholderView(
                icon: Icons.wifi_off_rounded,
                title: 'Could not load matches',
                message: 'Check your connection and try again.',
              ),
              if (onRetry != null)
                TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          );
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}
