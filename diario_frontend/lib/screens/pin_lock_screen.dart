import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const PinLockScreen({super.key, required this.onUnlocked});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final _pinController = TextEditingController();
  String? _error;

  Future<String?> _getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('diario_pin');
  }

  void _checkPin() async {
    final savedPin = await _getSavedPin();
    if (_pinController.text == savedPin) {
      widget.onUnlocked();
    } else {
      setState(() {
        _error = 'PIN incorrecto';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingresa tu PIN para acceder al diario',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  errorText: _error,
                ),
                onSubmitted: (_) => _checkPin(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPin,
                child: const Text('Desbloquear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
