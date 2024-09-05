import 'dart:io';

import 'AddressDto.dart';
import 'UserDto.dart';

class PropertyDto {
  final String id;
  final AddressDto addressDto;
  final UserDto userDto;
  final InspectionDto inspectionDto;

  PropertyDto({
    required this.id,
    required this.addressDto,
    required this.userDto,
    required this.inspectionDto,
  });

  factory PropertyDto.fromJson(Map<String, dynamic> json) {
    return PropertyDto(
      id: json['id'],
      addressDto: AddressDto.fromJson(json['addressDto']),
      userDto: UserDto.fromJson(json['userDto']),
      inspectionDto: InspectionDto.fromJson(json['inspectionDto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addressDto': addressDto.toJson(),
      'userDto': userDto.toJson(),
      'inspectionDto': inspectionDto.toJson(),
    };
  }
}

class InspectionDto {
  final String inspectionId;
  final String inspectorName;
  final String inspectionType;
  final String date;
  final String time;
  final String keyLocation;
  final String keyReference;
  final String internalNotes;
  final List<InspectionReportDto> inspectionReports;

  InspectionDto({
    required this.inspectionId,
    required this.inspectorName,
    required this.inspectionType,
    required this.date,
    required this.time,
    required this.keyLocation,
    required this.keyReference,
    required this.internalNotes,
    required this.inspectionReports,
  });

  factory InspectionDto.fromJson(Map<String, dynamic> json) {
    return InspectionDto(
      inspectionId: json['inspectionId'],
      inspectorName: json['inspectorName'],
      inspectionType: json['inspectionType'],
      date: json['date'],
      time: json['time'],
      keyLocation: json['keyLocation'],
      keyReference: json['keyReference'],
      internalNotes: json['internalNotes'],
      inspectionReports: (json['inspectionReports'] as List)
          .map((i) => InspectionReportDto.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inspectionId': inspectionId,
      'inspectorName': inspectorName,
      'inspectionType': inspectionType,
      'date': date,
      'time': time,
      'keyLocation': keyLocation,
      'keyReference': keyReference,
      'internalNotes': internalNotes,
      'inspectionReports': inspectionReports.map((report) => report.toJson()).toList(),
    };
  }
}

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
      subTypes: (json['subTypes'] as List)
          .map((i) => SubTypeDto.fromJson(i))
          .toList(),
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
  final List<String> images; // URLs or file paths
  List<File> conditionImages; // This holds the image files for upload
  final String comments;
  final String feedback;

  SubTypeDto({
    required this.subTypeId,
    required this.subTypeName,
    required this.images,
    required this.conditionImages,
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
      conditionImages: [], // Initialize as an empty list; file objects are managed separately
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTypeId': subTypeId,
      'subTypeName': subTypeName,
      'images': images,
      'comments': comments,
      'feedback': feedback,
      // Exclude conditionImages from JSON serialization
    };
  }
}
