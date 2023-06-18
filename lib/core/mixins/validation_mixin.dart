import 'package:intl/intl.dart';

mixin ValidationMixi {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? "Esse campo é obrigatório";
    return null;
  }

  String? isDate(String? value, [String? message]) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    if (value!.isEmpty) {
      return message ?? "Esse campo é obrigatório";
    }
    try {
      //DateTime dayOfBirthDate = format.parseStrict(value);
      format.parseStrict(value);
      return null;
    } catch (_) {
      return "Data inválida";
    }
  }
}
