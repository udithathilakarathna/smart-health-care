DateTime? parseSessionDate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  final parts = value.split('/');
  if (parts.length != 3) {
    return null;
  }

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) {
    return null;
  }

  return DateTime(year, month, day);
}

bool isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

DateTime? appointmentDateTime(Map<String, dynamic> data) {
  final sessionDate = parseSessionDate(data['sessionDate'] as String?);
  if (sessionDate == null) {
    return null;
  }

  final sessionTime = data['sessionTime'] as String?;
  if (sessionTime == null || sessionTime.trim().isEmpty) {
    return sessionDate;
  }

  final cleanedTime = sessionTime.trim().toUpperCase();
  final timeParts = cleanedTime.split(' ');
  final clockParts = timeParts.first.split(':');
  if (clockParts.length != 2) {
    return sessionDate;
  }

  final hour = int.tryParse(clockParts[0]);
  final minute = int.tryParse(clockParts[1]);
  if (hour == null || minute == null) {
    return sessionDate;
  }

  var adjustedHour = hour % 12;
  if (cleanedTime.contains('PM')) {
    adjustedHour += 12;
  }
  if (cleanedTime.contains('AM') && hour == 12) {
    adjustedHour = 0;
  }

  return DateTime(
    sessionDate.year,
    sessionDate.month,
    sessionDate.day,
    adjustedHour,
    minute,
  );
}

String formatDateKey(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
