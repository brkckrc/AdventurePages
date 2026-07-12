import 'package:flutter/material.dart';

import '../data/demo_story_data.dart';
import '../widgets/story_background.dart';

class ChapterEndScreen extends StatelessWidget {
  const ChapterEndScreen({
    super.key,
    required this.onHome,
    required this.onRestart,
  });

  final VoidCallback onHome;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const StoryBackground(backgroundImage: candyCastleShadowImage),
          ColoredBox(color: Colors.black.withValues(alpha: 0.62)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Şeker Kalesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFD166),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Macera Devam Edecek',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Çocuklar Pofuduk ile Şeker Kalesi\'ne doğru ilerliyor. Bay Bayat ile karşılaşmaları bir sonraki bölümde devam edecek.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF4F4EE),
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OutlinedButton.icon(
                            key: const ValueKey('chapter-end-home-button'),
                            onPressed: onHome,
                            icon: const Icon(Icons.home_rounded),
                            label: const Text('Ana Menüye Dön'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                          FilledButton.icon(
                            key: const ValueKey('chapter-end-restart-button'),
                            onPressed: onRestart,
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('Bölümü Yeniden Oyna'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD166),
                              foregroundColor: const Color(0xFF1F2A28),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
