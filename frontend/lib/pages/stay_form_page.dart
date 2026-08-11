import 'package:flutter/material.dart';
import '../services/stay_service.dart';
import '../models/tutor_contact.dart';

class StayFormPage extends StatefulWidget {
  const StayFormPage({super.key, required this.service});
  final StayService service;

  @override
  State<StayFormPage> createState() => _StayFormPageState();
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year;

  return '$day/$month/$year';
}

class _StayFormPageState extends State<StayFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _tutorNameController = TextEditingController();
  final _tutorPhoneController = TextEditingController();
  final _tutorEmailController = TextEditingController();
  final _breedController = TextEditingController();
  DateTime _entryDate = DateTime.now();
  DateTime? _expectedExitDate;
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String _species = 'dog';
  bool _isSaving = false;

  @override
  void dispose() {
    _tutorNameController.dispose();
    _tutorPhoneController.dispose();
    _tutorEmailController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _selectEntryDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _entryDate = selectedDate;

      if (_expectedExitDate != null &&
          _expectedExitDate!.isBefore(_entryDate)) {
        _expectedExitDate = null;
      }
    });
  }

  Future<void> _selectExpectedExitDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _expectedExitDate ?? _entryDate,
      firstDate: _entryDate,
      lastDate: DateTime(_entryDate.year + 2, _entryDate.month, _entryDate.day),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _expectedExitDate = selectedDate;
    });
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      await widget.service.createStay(
        tutorName: _tutorNameController.text.trim(),
        tutorContact: TutorContact(
          email: _tutorEmailController.text.trim(),
          phone: _tutorPhoneController.text.trim(),
        ),
        species: _species,
        breed: _breedController.text.trim(),
        entryDate: _entryDate,
        expectedExitDate: _expectedExitDate,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível cadastrar a hospedagem.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova hospedagem')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tutorNameController,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Nome do tutor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tutorPhoneController,
              validator: _validateRequired,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone do tutor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tutorEmailController,
              validator: _validateRequired,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email do tutor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _species,
              decoration: const InputDecoration(
                labelText: 'Espécie',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'dog', child: Text('Cachorro')),
                DropdownMenuItem(value: 'cat', child: Text('Gato')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _species = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Raça',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _selectEntryDate,
              icon: const Icon(Icons.calendar_today),
              label: Text('Entrada: ${_formatDate(_entryDate)}'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectExpectedExitDate,
                    icon: const Icon(Icons.event_available),
                    label: Text(
                      _expectedExitDate == null
                          ? 'Selecionar previsão de saída'
                          : 'Saída: ${_formatDate(_expectedExitDate!)}',
                    ),
                  ),
                ),
                if (_expectedExitDate != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _expectedExitDate = null;
                      });
                    },
                    tooltip: 'Remover previsão de saída',
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Salvando...' : 'Salvar hospedagem'),
            ),
          ],
        ),
      ),
    );
  }
}
