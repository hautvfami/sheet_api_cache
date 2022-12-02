import 'dart:io';

class BranchUtil {
  static get branch async {
    final head = await File('.git/HEAD').readAsString();
    final branch = head.split('/').last;
    return branch.toUpperCase().trim();
  }
}
