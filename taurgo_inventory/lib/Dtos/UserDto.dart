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
