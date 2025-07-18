import 'package:flutter/material.dart';
import 'screens/entry_list_screen.dart';
import 'services/entry_service.dart';
import 'screens/pin_lock_screen.dart';
import 'screens/create_pin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getBaseUrl() {
  // Cambia aquí según el entorno:
  // Emulador Android: 'http://10.0.2.2:3000'
  // Web: 'http://localhost:3000'
  // DevTunnel: 'https://x06cxvm2-3000.use2.devtunnels.ms'
  return 'http://10.0.2.2:3000';
}

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diario Personal',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: FutureBuilder<String?>(
        future: getPin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar PIN: ${snapshot.error}'),
            );
          }
          final pin = snapshot.data;
          if (pin == null || pin.isEmpty) {
            // No hay PIN, mostrar pantalla de creación
            return CreatePinScreen(
              onCreated: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryListScreen(
                      entryService: EntryService(baseUrl: getBaseUrl()),
                    ),
                  ),
                );
              },
            );
          } else {
            // Hay PIN, mostrar pantalla de bloqueo
            return PinLockScreen(
              onUnlocked: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryListScreen(
                      entryService: EntryService(baseUrl: getBaseUrl()),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<String?> getPin() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('diario_pin');
}
