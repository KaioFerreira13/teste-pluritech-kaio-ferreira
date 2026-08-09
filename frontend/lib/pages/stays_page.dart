import 'package:flutter/material.dart';
import 'stay_form_page.dart';
import '../models/stay.dart';
import '../services/stay_service.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key, required this.service});

  final StayService service;

  @override
  State<StaysPage> createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  late Future<List<Stay>> _staysFuture;

  @override
  void initState() {
    super.initState();
    _loadStays();
  }

  void _loadStays() {
    _staysFuture = widget.service.getStays();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  Future<void> _openCreateForm() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return StayFormPage(service: widget.service);
        },
      ),
    );

    if (created == true && mounted) {
      setState(_loadStays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel para Pets')),
      body: FutureBuilder<List<Stay>>(
        future: _staysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Não foi possível carregar as hospedagens.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      setState(_loadStays);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final stays = snapshot.data ?? [];

          if (stays.isEmpty) {
            return const Center(child: Text('Nenhuma hospedagem cadastrada.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stays.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              final stay = stays[index];
              final speciesLabel = stay.species == 'dog' ? 'Cachorro' : 'Gato';
              final expectedExitDate = stay.expectedExitDate;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text('${stay.code} - $speciesLabel'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tutor: ${stay.tutorName}'),
                      Text('Contato: ${stay.tutorContact}'),
                      Text('Entrada: ${_formatDate(stay.entryDate)}'),
                      Text('Raça: ${stay.breed}'),
                      Text('Diárias até o momento: ${stay.currentDays}'),
                      Text(
                        expectedExitDate == null
                            ? 'Saída prevista: Não informada'
                            : 'Saída prevista: ${_formatDate(expectedExitDate)}',
                      ),
                      if (expectedExitDate != null)
                        Text('Diárias previstas: ${stay.expectedTotalDays}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('Nova hospedagem'),
      ),
    );
  }
}
