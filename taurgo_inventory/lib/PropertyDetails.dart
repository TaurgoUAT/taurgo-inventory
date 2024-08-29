import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a model to hold the property details
class PropertyDetails {
  final String status;
  final String lineOneAddress;
  final String lineTwoAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String reference;
  final String client;
  final String type;
  final String furnishing;
  final String noOfBeds;
  final String noOfBaths;
  final String garage;
  final String parking;
  final String notes;
  final String selectedType;
  final String date;
  final String time;
  final String keyLocation;
  final String referenceForKey;
  final String internalNotes;

  PropertyDetails({
    required this.status,
    required this.lineOneAddress,
    required this.lineTwoAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.reference,
    required this.client,
    required this.type,
    required this.furnishing,
    required this.noOfBeds,
    required this.noOfBaths,
    required this.garage,
    required this.parking,
    required this.notes,
    required this.selectedType,
    required this.date,
    required this.time,
    required this.keyLocation,
    required this.referenceForKey,
    required this.internalNotes,
  });

  // Add copyWith method for updating properties
  PropertyDetails copyWith({
    String? status,
    String? lineOneAddress,
    String? lineTwoAddress,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? reference,
    String? client,
    String? type,
    String? furnishing,
    String? noOfBeds,
    String? noOfBaths,
    String? garage,
    String? parking,
    String? notes,
    String? selectedType,
    String? date,
    String? time,
    String? keyLocation,
    String? referenceForKey,
    String? internalNotes,
  }) {
    return PropertyDetails(
      status: status ?? this.status,
      lineOneAddress: lineOneAddress ?? this.lineOneAddress,
      lineTwoAddress: lineTwoAddress ?? this.lineTwoAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      reference: reference ?? this.reference,
      client: client ?? this.client,
      type: type ?? this.type,
      furnishing: furnishing ?? this.furnishing,
      noOfBeds: noOfBeds ?? this.noOfBeds,
      noOfBaths: noOfBaths ?? this.noOfBaths,
      garage: garage ?? this.garage,
      parking: parking ?? this.parking,
      notes: notes ?? this.notes,
      selectedType: selectedType ?? this.selectedType,
      date: date ?? this.date,
      time: time ?? this.time,
      keyLocation: keyLocation ?? this.keyLocation,
      referenceForKey: referenceForKey ?? this.referenceForKey,
      internalNotes: internalNotes ?? this.internalNotes,
    );
  }
}

// Define a provider for the property details
final propertyDetailsProvider = StateProvider<PropertyDetails>((ref) {
  return PropertyDetails(
    status: 'Available',
    lineOneAddress: '',
    lineTwoAddress: '',
    city: '',
    state: '',
    country: '',
    postalCode: '',
    reference: '',
    client: '',
    type: '',
    furnishing: '',
    noOfBeds: '',
    noOfBaths: '',
    garage: '',
    parking: '',
    notes: '',
    selectedType: '',
    date: '',
    time: '',
    keyLocation: '',
    referenceForKey: '',
    internalNotes: '',
  );
});
