import 'package:flutter/material.dart';
import '../services/entry_service.dart';

class EntryFormScreen extends StatefulWidget {
  final EntryService entryService;
  final Function()? onSaved;
  const EntryFormScreen({super.key, required this.entryService, this.onSaved});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  final List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Trabajo',
    'Personal',
    'Contraseñas',
  ]; // Simulado, deberías obtenerlo del backend
  final _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Entrada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título (opcional)',
                ),
                onSaved: (value) =>
                    _title = value?.isNotEmpty == true ? value! : 'Sin título',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty
                    ? 'El contenido es obligatorio'
                    : null,
                onSaved: (value) => _content = value ?? '',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: _availableTags.map((tag) {
                  final selected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: 'Nueva etiqueta',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final newTag = _tagController.text.trim();
                      if (newTag.isNotEmpty &&
                          !_availableTags.contains(newTag)) {
                        setState(() {
                          _availableTags.add(newTag);
                          _selectedTags.add(newTag);
                          _tagController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await widget.entryService.createEntry({
                      'title': _title,
                      'content': _content,
                      'tags': _selectedTags,
                      'userId': 1, // ID de usuario fijo para pruebas
                    });
                    if (widget.onSaved != null) widget.onSaved!();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
