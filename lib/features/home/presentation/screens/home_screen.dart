import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ymusic/core/providers/youtube_service_provider.dart';
import 'package:ymusic/features/auth/presentation/notifiers/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> foo(WidgetRef ref) async {
    final youtubeService = ref.read(youTubeServiceProvider);
    final urls = await youtubeService.extractAudioUrl("Ay0AoN03QyA");

    debugPrint("Urls = $urls");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Home"),
              ElevatedButton(
                onPressed: () async => await foo(ref),
                child: const Text("Get video"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
