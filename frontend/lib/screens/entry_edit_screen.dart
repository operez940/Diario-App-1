import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';

class EntryEditScreen extends StatefulWidget {
  final EntryService entryService;
  final Entry entry;
  final Function()? onSaved;
  const EntryEditScreen({
    super.key,
    required this.entryService,
    required this.entry,
    this.onSaved,
  });

  @override
  State<EntryEditScreen> createState() => _EntryEditScreenState();
}

class _EntryEditScreenState extends State<EntryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  List<String> _selectedTags = [];
  List<String> _availableTags = [
    'Trabajo',
    'Personal',
    'Contraseñas',
  ]; // Simulado, deberías obtenerlo del backend
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = widget.entry.title;
    _content = widget.entry.content;
    _selectedTags = List<String>.from(widget.entry.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Entrada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Título (opcional)',
                ),
                onSaved: (value) =>
                    _title = value?.isNotEmpty == true ? value! : 'Sin título',
              ),
              TextFormField(
                initialValue: _content,
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
                    await widget.entryService.updateEntry(widget.entry.id, {
                      'title': _title,
                      'content': _content,
                      'tags': _selectedTags,
                    });
                    if (widget.onSaved != null) widget.onSaved!();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
