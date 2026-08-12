import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract final class PhoneFormatter {
  static MaskTextInputFormatter create() {
    return MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {'#': RegExp(r'[0-9]')},
    );
  }
}
