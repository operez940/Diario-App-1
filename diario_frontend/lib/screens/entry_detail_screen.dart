import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';
import 'entry_edit_screen.dart';

class EntryDetailScreen extends StatelessWidget {
  final Entry entry;
  final EntryService entryService;
  const EntryDetailScreen({super.key, required this.entry, required this.entryService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha: \\${entry.createdAt}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(entry.content),
            const SizedBox(height: 16),
            Text('Etiquetas: \\${entry.tags.join(', ')}'),
            const SizedBox(height: 16),
            Text('Autor: \\${entry.user ?? "Desconocido"}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryEditScreen(
                      entryService: entryService,
                      entry: entry,
                      onSaved: () {},
                    ),
                  ),
                );
                if (result == true) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Editar entrada'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Eliminar entrada?'),
                    content: const Text(
                      '¿Estás seguro de que deseas eliminar esta entrada?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await entryService.deleteEntry(entry.id);
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Eliminar entrada'),
            ),
          ],
        ),
      ),
    );
  }
}
