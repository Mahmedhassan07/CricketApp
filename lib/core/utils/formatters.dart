/// Small date/number helpers (avoids pulling in the intl package).
class Formatters {
  Formatters._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "Nov 8, 2026"
  static String date(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// "09:00 AM"
  static String time(DateTime d) {
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final h = hour12.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
  }

  /// 12.1234 → "12.12"
  static String decimal(double v) => v.toStringAsFixed(2);
}
