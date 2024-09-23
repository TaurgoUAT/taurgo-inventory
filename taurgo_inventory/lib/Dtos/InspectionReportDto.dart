class PropertyDto {
  String id;
  AddressDto addressDto;
  UserDto userDto;
  InspectionSumamryDto inspectionDto;

  PropertyDto({required this.id, required this.addressDto, required this.userDto, required this.inspectionDto});
}

class AddressDto {
  final String addressLineOne;
  final String addressLineTwo;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      addressLineOne: json['addressLineOne'],
      addressLineTwo: json['addressLineTwo'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
    );
  }

  AddressDto({required this.addressLineOne, required this.addressLineTwo, required this.city, required this.state, required this.country, required this.postalCode});

  Map<String, dynamic> toJson() {
    return {
      'addressLineOne': addressLineOne,
      'addressLineTwo': addressLineTwo,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }
}

class UserDto {
  final String firebaseId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String location;

  UserDto({
    required this.firebaseId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.location,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      firebaseId: json['firebaseId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseId': firebaseId,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'location': location,
    };
  }
}

class InspectionSumamryDto {
  final String inspectionId;
  final String inspectorName;
  final String inspectionType;
  final String date;
  final String time;
  final String keyLocation;
  final String keyReference;
  final String internalNotes;

  InspectionSumamryDto({
    required this.inspectionId,
    required this.inspectorName,
    required this.inspectionType,
    required this.date,
    required this.time,
    required this.keyLocation,
    required this.keyReference,
    required this.internalNotes,
  });

  factory InspectionSumamryDto.fromJson(Map<String, dynamic> json) {
    return InspectionSumamryDto(
      inspectionId: json['inspectionId'],
      inspectorName: json['inspectorName'],
      inspectionType: json['inspectionType'],
      date: json['date'],
      time: json['time'],
      keyLocation: json['keyLocation'],
      keyReference: json['keyReference'],
      internalNotes: json['internalNotes'],
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
    };
  }
}

class PropertySummaryDto {
  String propertyId;
  AddressDto addressDto;
  UserDto userDto;
  InspectionSumamryDto inspectionDto;
  List<String> images; // List of base64 strings
  String comment;
  String signature; // Base64 string

  PropertySummaryDto({
    required this.propertyId,
    required this.addressDto,
    required this.userDto,
    required this.inspectionDto,
    required this.images,
    required this.comment,
    required this.signature,
  });

  factory PropertySummaryDto.fromJson(Map<String, dynamic> json ) {
    return PropertySummaryDto(
      propertyId: json['propertyId'],
      addressDto: AddressDto.fromJson(json['addressDto']),
      userDto: UserDto.fromJson(json['userDto']),
    inspectionDto: InspectionSumamryDto.fromJson(json['inspectionDto']),
      images: List<String>.from(json['images'] ?? []), // Ensure this is a List<String>
      comment: json['comment'],
      signature: json['signature'],
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'addressDto': addressDto.toJson(),
      'userDto': userDto.toJson(),
      'inspectionDto': inspectionDto.toJson(),
      'images': images, // Ensure this field is included
      'comment': comment,
      'signature': signature,
    };
  }
}