import 'package:intl/intl.dart';

/// Helpers de formatação de datas em pt-BR.
class DateFormatX {
  DateFormatX._();

  /// "Hoje, 14h32" / "Ontem, 10h15" / "23/04, 09h00" / "12/03/2025, 14h00"
  /// (esse último para datas em outro ano).
  static String relative(DateTime when, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final today = DateTime(ref.year, ref.month, ref.day);
    final that = DateTime(when.year, when.month, when.day);
    final diffDays = today.difference(that).inDays;

    final time = DateFormat("HH'h'mm").format(when);

    if (diffDays == 0) return 'Hoje, $time';
    if (diffDays == 1) return 'Ontem, $time';
    if (when.year == ref.year) {
      return '${DateFormat('dd/MM').format(when)}, $time';
    }
    return '${DateFormat('dd/MM/yyyy').format(when)}, $time';
  }

  /// "28 ABR" — usado nos cards de evento do calendário.
  static (String day, String month) dayMonth(DateTime when) {
    return (
      DateFormat('dd').format(when),
      DateFormat('MMM').format(when).toUpperCase(),
    );
  }

  /// "Abril 2026" — usado no header do calendário mensal.
  static String monthYear(DateTime when) {
    final raw = DateFormat('MMMM yyyy', 'pt_BR').format(when);
    return raw[0].toUpperCase() + raw.substring(1);
  }

  /// "19h00" / "19h00 - 20h30"
  static String timeRange(DateTime start, DateTime? end) {
    final s = DateFormat("HH'h'mm").format(start);
    if (end == null) return s;
    return '$s - ${DateFormat("HH'h'mm").format(end)}';
  }
}
