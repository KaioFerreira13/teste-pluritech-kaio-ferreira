import 'package:flutter/material.dart';
import 'package:pluritech_frontend/formatters/phone_formatter.dart';
import 'stay_form_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final formatter = PhoneFormatter.create();
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

  Future<void> _confirmDelete(Stay stay) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir hospedagem?'),
          content: Text(
            'O registro ${stay.code} será excluído permanentemente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await widget.service.deleteStay(stay.id);

      if (!mounted) {
        return;
      }

      setState(_loadStays);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hospedagem excluída com sucesso.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível excluir a hospedagem, tente novamente mais tarde.',
          ),
        ),
      );
    }
  }

  Future<void> _openEditForm(Stay stay) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return StayFormPage(service: widget.service, stay: stay);
        },
      ),
    );

    if (updated == true && mounted) {
      setState(_loadStays);
    }
  }

  _formatPhone(String phone){
    final formatterPhone = PhoneFormatter.create(initialText: phone);

    return formatterPhone.getMaskedText();
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
                      Text('Telefone: ${_formatPhone(stay.tutorContact.phone)}'),
                      Text('Email: ${stay.tutorContact.email}'),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _openEditForm(stay);
                        },
                        tooltip: 'Editar hospedagem',
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          _confirmDelete(stay);
                        },
                        tooltip: 'Excluir hospedagem',
                        icon: const Icon(Icons.delete_outline),
                      ),
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
