import 'dart:convert';
import 'dart:io';

import 'package:sheet_to_api/convert.dart' as convert;
import 'package:dio/dio.dart';

import 'utils/branch_utils.dart';

/// Google Sheet API Key
const apiKey = "API_KEY";

void main(List<String> arguments) async {
  final env = Platform.environment;

  final context = jsonDecode(env['SECRETS_CONTEXT'] ?? '{}');
  final sheetApiKey = context[apiKey];

  final branchName = await BranchUtil.branch;
  final branchConfig = jsonDecode(context[branchName]);

  final spreadsheetsId = branchConfig["spreadsheets_id"];
  final sheets = branchConfig["sheet_name"];

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
  final response = await Dio().get(endpoint);
  final data = convert.rowToJson(response.data['values'] as List);

  final path = 'data/${filename.toLowerCase()}.json';
  await File(path).writeAsString(jsonEncode(data));
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
