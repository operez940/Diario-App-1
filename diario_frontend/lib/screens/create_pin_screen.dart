import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePinScreen extends StatefulWidget {
  final VoidCallback onCreated;
  const CreatePinScreen({super.key, required this.onCreated});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diario_pin', pin);
  }

  void _createPin() async {
    if (_pinController.text.length < 4) {
      setState(() {
        _error = 'El PIN debe tener al menos 4 dígitos';
      });
      return;
    }
    if (_pinController.text != _confirmController.text) {
      setState(() {
        _error = 'Los PIN no coinciden';
      });
      return;
    }
    await _savePin(_pinController.text);
    setState(() {
      _error = null;
    });
    widget.onCreated();
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
                'Crea un PIN para proteger tu diario',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'PIN'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Confirmar PIN'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createPin,
                child: const Text('Guardar PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
