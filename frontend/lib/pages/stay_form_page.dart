import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../formatters/phone_formatter.dart';
import '../services/stay_service.dart';
import '../models/tutor_contact.dart';
import '../models/stay.dart';

class StayFormPage extends StatefulWidget {
  const StayFormPage({super.key, required this.service, this.stay});
  final StayService service;
  final Stay? stay;

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
  late final MaskTextInputFormatter _phoneMaskFormatter;
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

  String? _validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return "Numero de telefone invalido";
    }

    phone = _phoneMaskFormatter.getUnmaskedText();
    if (phone.length != 11) {
      return "O numero de telefone deve conter 11 digitos!";
    }

    return null;
  }

  String? _validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'E-mail é obrigatório';
  }

  final email = value.trim();

  if (email.length > 254) {
    return 'E-mail muito longo';
  }

  final regex = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$",
  );

  if (!regex.hasMatch(email)) {
    return 'E-mail inválido';
  }

  return null;
}

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
      final tutorContact = TutorContact(
        email: _tutorEmailController.text.trim(),
        phone: _phoneMaskFormatter.getUnmaskedText(),
      );

      final stay = widget.stay;
      if (stay == null) {
        await widget.service.createStay(
          tutorName: _tutorNameController.text.trim(),
          tutorContact: tutorContact,
          species: _species,
          breed: _breedController.text.trim(),
          entryDate: _entryDate,
          expectedExitDate: _expectedExitDate,
        );
      } else {
        await widget.service.updateStay(
          id: stay.id,
          tutorName: _tutorNameController.text.trim(),
          tutorContact: tutorContact,
          species: _species,
          breed: _breedController.text.trim(),
          entryDate: _entryDate,
          expectedExitDate: _expectedExitDate,
        );
      }
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
        const SnackBar(content: Text('Não foi possível salvar a hospedagem.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final stay = widget.stay;
    _phoneMaskFormatter = PhoneFormatter.create(
      initialText: stay?.tutorContact.phone,
    );

    if (stay == null) {
      return;
    }

    _tutorNameController.text = stay.tutorName;
    _tutorPhoneController.text = _phoneMaskFormatter.getMaskedText();
    _tutorEmailController.text = stay.tutorContact.email;
    _breedController.text = stay.breed;
    _species = stay.species;
    _entryDate = stay.entryDate;
    _expectedExitDate = stay.expectedExitDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stay == null ? 'Nova hospedagem' : 'Editar hospedagem',
        ),
      ),
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
              validator: _validatePhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneMaskFormatter],
              decoration: const InputDecoration(
                labelText: 'Telefone do tutor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tutorEmailController,
              validator: _validateEmail,
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
              label: Text(
                _isSaving
                    ? 'Salvando...'
                    : widget.stay == null
                    ? 'Cadastrar hospedagem'
                    : 'Salvar alterações',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
