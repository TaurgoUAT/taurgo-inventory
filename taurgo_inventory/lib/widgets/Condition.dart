import 'dart:io';

class Condition {
  String? conditionName;
  String? conditionStatus;
  List<File> images;

  Condition({
    this.conditionName,
    this.conditionStatus,
    required this.images,
  });
}
