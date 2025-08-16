// Sample branch environment: MAIN
import 'dart:convert';

import 'utils/branch_utils.dart';

const secretEnv = {
  "spreadsheets_id": "1QzJSkjPUj78dXj32Bkok_oWx8hZNiQXmLHTk4pz1alU",
  "sheet_name": ["list_pack", "1", "2", "3"],
};
void main(List<String> args) async {
  final branchName = await BranchUtil.branch;
  print("$branchName: ${jsonEncode(secretEnv)}");
}
