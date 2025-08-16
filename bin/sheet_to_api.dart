import 'dart:convert';
import 'dart:io';

import 'package:sheet_to_api/convert.dart' as convert;
import 'package:dio/dio.dart';

import 'utils/branch_utils.dart';

/// Google Sheet API Key
const apiKey = "API_KEY";

final config = {
  "spreadsheets_id": "1QzJSkjPUj78dXj32Bkok_oWx8hZNiQXmLHTk4pz1alU",
  "sheet_name": ["CCY", "VCB"],
};

void main(List<String> arguments) async {
  final env = Platform.environment;

  final context = jsonDecode(env['SECRETS_CONTEXT'] ?? '{}');
  final sheetApiKey = context[apiKey];

  final branchName = await BranchUtil.branch;
  final branchConfig = jsonDecode(context[branchName]);

  final spreadsheetsId = config["spreadsheets_id"];
  final sheets = config["sheet_name"];

  for (String sheet in sheets) {
    String endpoint = _createEndPoint(
      spreadsheetsId: spreadsheetsId,
      sheetName: sheet,
      apiKey: sheetApiKey,
    );
    fetchData(filename: sheet, endpoint: endpoint);
  }
}

void fetchData({String filename = '', String endpoint = ''}) async {
  final path = 'data/${filename.toLowerCase()}.json';
  try {
    final response = await Dio().get(endpoint);
    final data = convert.rowToJson(response.data['values'] as List);
    await File(path).writeAsString(jsonEncode(data));
  } catch (e) {
    final error = jsonEncode({
      "status": 500,
      "message": e.toString(),
      "data": [],
    });
    await File(path).writeAsString(error);
  }
}

String _createEndPoint({
  String spreadsheetsId = '',
  String sheetName = '',
  String apiKey = '',
  String valueRenderOption = 'UNFORMATTED_VALUE',
}) {
  String url = "https://sheets.googleapis.com/v4/spreadsheets/";
  url += "$spreadsheetsId/values/$sheetName";
  url += "?key=$apiKey&valueRenderOption=$valueRenderOption";
  return url;
}
