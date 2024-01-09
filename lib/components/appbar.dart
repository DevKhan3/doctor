// app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onAddDoctorPressed;

  const CustomAppBar({Key? key, this.onLoginPressed, this.onAddDoctorPressed}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logo_s.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('\t HealthWise'),
          ),
        ],
      ),
      actions: [
        if (onLoginPressed != null)
          Container(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              width: 80,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: onLoginPressed!,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (onAddDoctorPressed != null)
          Container(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              width: 100, // Adjust the width according to your needs
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: onAddDoctorPressed!,
                  child: const Text(
                    'Add Doctor',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

