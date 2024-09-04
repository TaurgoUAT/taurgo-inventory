class AddressDto {
  final String addressLineOne;
  final String addressLineTwo;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  AddressDto({
    required this.addressLineOne,
    required this.addressLineTwo,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

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
