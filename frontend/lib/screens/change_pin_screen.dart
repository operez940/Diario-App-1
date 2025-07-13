import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _error;

  Future<String?> _getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('diario_pin');
  }

  Future<void> _saveNewPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diario_pin', pin);
  }

  void _changePin() async {
    final savedPin = await _getSavedPin();
    if (_oldPinController.text != savedPin) {
      setState(() {
        _error = 'PIN actual incorrecto';
      });
      return;
    }
    if (_newPinController.text.length < 4) {
      setState(() {
        _error = 'El PIN debe tener al menos 4 dígitos';
      });
      return;
    }
    if (_newPinController.text != _confirmPinController.text) {
      setState(() {
        _error = 'Los PIN no coinciden';
      });
      return;
    }
    await _saveNewPin(_newPinController.text);
    setState(() {
      _error = null;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('PIN cambiado correctamente')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar PIN')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'PIN actual'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nuevo PIN'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Confirmar nuevo PIN',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _changePin,
              child: const Text('Guardar PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
