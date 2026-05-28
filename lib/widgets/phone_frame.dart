// 📱 PhoneFrame — iPhone blanc élégant avec barre d'état (pour le web)
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/colors.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    if (!kIsWeb || largeur < 600) {
      return child;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCE7F0), Color(0xFFF5E1EC), Color(0xFFFFF0F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 380,
          height: 790,
          // Cadre blanc/argenté élégant (effet titane clair)
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF0F0F3), Color(0xFFE2E2E8), Color(0xFFF5F5F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(52),
            boxShadow: [
              BoxShadow(
                color: AppColors.rose.withValues(alpha: 0.30),
                blurRadius: 60,
                spreadRadius: 4,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Container(
            // Liseré interne noir fin (entre le cadre clair et l'écran)
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(46),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // 🔋 Barre d'état iPhone
                    _barreEtat(),
                    // L'app
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _barreEtat() {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 28, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Heure
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          // Encoche (Dynamic Island)
          Container(
            width: 95,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // Signal + Wifi + Batterie
          Row(
            children: [
              const Icon(Icons.signal_cellular_alt, size: 16, color: Colors.black),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 16, color: Colors.black),
              const SizedBox(width: 4),
              // Batterie
              Container(
                width: 24,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                      color: Colors.black.withValues(alpha: 0.4), width: 1),
                ),
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.succes,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
