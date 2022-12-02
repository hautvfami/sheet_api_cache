import 'dart:convert';
import 'dart:io';

import 'package:sheet_to_api/convert.dart' as convert;
import 'package:dio/dio.dart';

void main(List<String> arguments) async {
  final env = Platform.environment;

  final context = jsonDecode(env['SECRETS_CONTEXT'] ?? '{}');
  final branch = (await branchName()).trim();
  final envName = '${branch}_VARIABLES';
  final variables = context[envName]?.split(',') ?? [];

  for (String variable in variables) {
    String endpoint = context[variable] ?? '';
    fetchData(variable: variable, endpoint: endpoint);
  }
}

void fetchData({String variable = '', String endpoint = ''}) async {
  final response = await Dio().get(endpoint);
  final data = convert.rowToJson(response.data['values'] as List);

  final filename =
      'data/${variable.replaceAll('_ENDPOINT', '').toLowerCase()}.json';
  await File(filename).writeAsString(jsonEncode(data));
}

Future<String> branchName() async {
  final head = await File('.git/HEAD').readAsString();
  final branch = head.split('/').last;
  return branch.toUpperCase();
}
