double? convertToDouble(dynamic data) {
  if (data == null) return null;

  if (data is String) return double.tryParse(data);

  if (data is int) return data.toDouble();
  if (data is double) return data;
  return null;
}

double parseDouble(String raw) {
  double? float = double.tryParse(raw);
  if (float != null) return float;

  int? integet = int.tryParse(raw);
  if (integet != null) return integet.toDouble();

  return 0;
}

const String rupee = '₹';
