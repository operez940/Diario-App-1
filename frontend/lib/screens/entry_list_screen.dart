import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';
import 'entry_detail_screen.dart';
import 'entry_form_screen.dart';
import 'change_pin_screen.dart';

class EntryListScreen extends StatefulWidget {
  final EntryService entryService;
  const EntryListScreen({super.key, required this.entryService});

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  late Future<List<Entry>> _entriesFuture;
  String _searchQuery = '';
  String? _selectedTag;
  List<String> _availableTags = [];
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _fetchTags();
    _entriesFuture = widget.entryService.fetchEntries();
  }

  void _fetchTags() async {
    // Aquí deberías usar TagService para obtener las etiquetas desde el backend
    // Por simplicidad, se deja como ejemplo estático
    setState(() {
      _availableTags = ['Trabajo', 'Personal', 'Contraseñas'];
    });
  }

  void _refreshEntries() {
    setState(() {
      _entriesFuture = widget.entryService.fetchEntries();
    });
  }

  List<Entry> _filterEntries(List<Entry> entries) {
    return entries.where((entry) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          entry.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTag =
          _selectedTag == null || entry.tags.contains(_selectedTag);
      final matchesDate =
          _selectedDate == null ||
          entry.createdAt.year == _selectedDate!.year &&
              entry.createdAt.month == _selectedDate!.month &&
              entry.createdAt.day == _selectedDate!.day;
      final matchesRange =
          _selectedRange == null ||
          (entry.createdAt.isAfter(_selectedRange!.start) &&
              entry.createdAt.isBefore(_selectedRange!.end));
      return matchesSearch && matchesTag && matchesDate && matchesRange;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entradas del Diario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            tooltip: 'Cambiar PIN',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePinScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por título o contenido',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          if (_availableTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                hint: const Text('Filtrar por etiqueta'),
                value: _selectedTag,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Todas'),
                  ),
                  ..._availableTags.map(
                    (tag) =>
                        DropdownMenuItem<String>(value: tag, child: Text(tag)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedTag = value;
                  });
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.date_range),
                label: const Text('Filtrar por fecha'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _selectedRange = null;
                    });
                  }
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_view_week),
                label: const Text('Filtrar por rango'),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedRange = picked;
                      _selectedDate = null;
                    });
                  }
                },
              ),
              if (_selectedDate != null || _selectedRange != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      _selectedRange = null;
                    });
                  },
                ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Entry>>(
              future: _entriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: \\${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay entradas'));
                }
                final entries = _filterEntries(snapshot.data!);
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ListTile(
                      title: Text(entry.title),
                      subtitle: Text(entry.createdAt.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EntryDetailScreen(entry: entry),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryFormScreen(
                entryService: widget.entryService,
                onSaved: _refreshEntries,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
