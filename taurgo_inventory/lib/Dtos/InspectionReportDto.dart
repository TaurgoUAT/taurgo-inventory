import 'dart:convert';

// DTO Classes

class InspectionReportDto {
  final String reportId;
  final String name;
  final List<SubTypeDto> subTypes;
  final String additionalComments;

  InspectionReportDto({
    required this.reportId,
    required this.name,
    required this.subTypes,
    required this.additionalComments,
  });

  factory InspectionReportDto.fromJson(Map<String, dynamic> json) {
    return InspectionReportDto(
      reportId: json['reportId'],
      name: json['name'],
      subTypes: (json['subTypes'] as List).map((i) => SubTypeDto.fromJson(i)).toList(),
      additionalComments: json['additionalComments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'name': name,
      'subTypes': subTypes.map((subType) => subType.toJson()).toList(),
      'additionalComments': additionalComments,
    };
  }
}

class SubTypeDto {
  final String subTypeId;
  final String subTypeName;
  final List<String> images;
  final String comments;
  final String feedback;

  SubTypeDto({
    required this.subTypeId,
    required this.subTypeName,
    required this.images,
    required this.comments,
    required this.feedback,
  });

  factory SubTypeDto.fromJson(Map<String, dynamic> json) {
    return SubTypeDto(
      subTypeId: json['subTypeId'],
      subTypeName: json['subTypeName'],
      images: List<String>.from(json['images']),
      comments: json['comments'],
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTypeId': subTypeId,
      'subTypeName': subTypeName,
      'images': images,
      'comments': comments,
      'feedback': feedback,
    };
  }
}
