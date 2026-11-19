import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              color: AppColors.ink,
              padding: const EdgeInsets.all(48),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.fitness_center, color: AppColors.lime),
                    SizedBox(width: 10),
                    Text('GymPro', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  ]),
                  Text(
                    'Zalingizning har bir\nso\'mi va har bir\ntashrifi nazoratda.',
                    style: TextStyle(color: Colors.white, fontSize: 40, height: 1.15, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Xodim sifatida kirish',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 24),
                    const TextField(decoration: InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 14),
                    const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Parol')),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showDialog(context: context, builder: (_) => const _ResetDialog()),
                        child: const Text('Parolni unutdingizmi?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.lime,
                          foregroundColor: AppColors.ink,
                        ),
                        onPressed: () => context.go('/gyms'),
                        child: const Text('Kirish', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// D-02
class _ResetDialog extends StatelessWidget {
  const _ResetDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Parolni tiklash'),
        content: const SizedBox(
          width: 340,
          child: TextField(decoration: InputDecoration(labelText: 'Email')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.lime, foregroundColor: AppColors.ink),
            onPressed: () => Navigator.pop(context),
            child: const Text('Havola yuborish'),
          ),
        ],
      );
}
