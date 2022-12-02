Map<String, dynamic> rowToJson(List? data) {
  if (data == null || data.isEmpty) {
    return {
      'status': 404,
      'message': 'Data not found',
      'data': [],
    };
  }

  final model = data.first as List;
  data.removeAt(0);
  final List listObject = data.map((e) {
    e as List;
    e.length = model.length;
    return Map.fromIterables(model, e);
  }).toList();

  return {
    'status': 200,
    'update_at': DateTime.now().millisecondsSinceEpoch,
    'data': listObject,
  };
}
