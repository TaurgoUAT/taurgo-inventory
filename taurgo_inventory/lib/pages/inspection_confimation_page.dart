import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/home_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
import 'package:taurgo_inventory/pages/reportPages/ev_charger.dart';
import '../../constants/AppColors.dart';
import 'package:digital_signature_flutter/digital_signature_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taurgo_inventory/constants/UrlConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Dtos/AddressDto.dart';
import '../Dtos/PropertyDto.dart';
import '../Dtos/UserDto.dart';

class InspectionConfimationPage extends StatefulWidget {
  final String propertyId;
  final String propertyType;
  final String imageType;

  const InspectionConfimationPage({
    Key? key,
    required this.propertyId,
    required this.propertyType,
    required this.imageType,
  }) : super(key: key);

  @override
  State<InspectionConfimationPage> createState() =>
      _InspectionConfimationPageState();
}

class _InspectionConfimationPageState extends State<InspectionConfimationPage> {
  SignatureController? controller;
  Uint8List? signature;
  List<Map<String, dynamic>> completedProperties = [];
  List<Map<String, dynamic>> pendingProperties = [];
  bool isLoading = true;
  String filterOption = 'All'; // Initial filter option
  List<Map<String, dynamic>> filteredProperties = [];
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> userDetails = [];
  User? user;
  String? selectedType;
  final Set<String> visitedPages = {}; // Track visited pages
  List<String> imageUrls = [];

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    String propertyId = widget.propertyId;

    try {
      final response = await http
          .get(Uri.parse('$baseURL/property/$propertyId'))
          .timeout(Duration(seconds: 60)); // Set the timeout duration

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          properties =
              data.map((item) => item as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        // Handle server errors
        setState(() {
          properties = []; // Ensure properties is set to an empty list
          isLoading = false;
        });
        // Display error message
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        properties = []; // Ensure properties is set to an empty list
        isLoading = false;
      });
      // Display error message
    }
  }

  //SOC
  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
  String? kitchen;
  String? oven;
  String? mattress;
  String? upholstrey;
  String? wall;
  String? window;
  String? woodwork;
  List<String> overviewImages = [];
  List<String> accessoryCleanlinessImages = [];
  List<String> windowSillImages = [];
  List<String> carpetsImages = [];
  List<String> ceilingsImages = [];
  List<String> curtainsImages = [];
  List<String> hardFlooringImages = [];
  List<String> kitchenAreaImages = [];
  List<String> kitchenImages = [];
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];

  //EV Charger

  //Keys Handed Over
  String? yale;
  String? mortice;
  String? other;
  List<String> keysHandOverYaleImages = [];
  List<String> keysHandOverMorticeImages = [];
  List<String> keysHandOverOtherImages = [];
  List<String> evChargerImages = [];
  String? evChargerDescription;

  //Meter Readings
  String? GasMeterReading;
  String? electricMeterReading;
  String? waterMeterReading;
  String? oilMeterReading;
  String? otherMeterReading;
  List<String> gasMeterImages = [];
  List<String> electricMeterImages = [];
  List<String> waterMeterImages = [];
  List<String> oilMeterImages = [];
  List<String> otherMeterImages = [];

  String? yaleLocation;
  String? morticeLocation;
  String? windowLockLocation;
  String? gasMeterLocation;
  String? carPassLocation;
  String? carPassReading;
  String? remoteLocation;
  String? remoteReading;
  String? otherLocation;
  String? otherReading;
  List<String> yaleImages = [];
  List<String> morticeImages = [];
  List<String> windowLockImages = [];
  List<String> keygasMeterImages = [];
  List<String> carPassImages = [];
  List<String> remoteImages = [];
  List<String> otherImages = [];

//Sensor
  String? smokeAlarmCondition;
  String? smokeAlarmDescription;
  String? heatSensorCondition;
  String? heatSensorDescription;
  String? carbonMonoxideCondition;
  String? carbonMonoxideDescription;
  String? smokeAlarmImagePath;
  String? heatSensorImagePath;
  String? carbonMonxideImagePath;
  List<String> smokeAlarmImages = [];
  List<String> heatSensorImages = [];
  List<String> carbonMonxideImages = [];

  //bathroom
  String? bathroomdoorCondition;
  String? bathroomdoorDescription;
  String? bathroomdoorFrameCondition;
  String? bathroomdoorFrameDescription;
  String? bathroomceilingCondition;
  String? bathroomceilingDescription;
  String? bathroomextractorFanCondition;
  String? bathroomextractorFanDescription;
  String? bathroomlightingCondition;
  String? bathroomlightingDescription;
  String? bathroomwallsCondition;
  String? bathroomwallsDescription;
  String? bathroomskirtingCondition;
  String? bathroomskirtingDescription;
  String? bathroomwindowSillCondition;
  String? bathroomwindowSillDescription;
  String? bathroomcurtainsCondition;
  String? bathroomcurtainsDescription;
  String? bathroomblindsCondition;
  String? bathroomblindsDescription;
  String? bathroomtoiletCondition;
  String? bathroomtoiletDescription;
  String? bathroombasinCondition;
  String? bathroombasinDescription;
  String? bathroomshowerCubicleCondition;
  String? bathroomshowerCubicleDescription;
  String? bathroombathCondition;
  String? bathroombathDescription;
  String? bathroomswitchBoardCondition;
  String? bathroomswitchBoardDescription;
  String? bathroomsocketCondition;
  String? bathroomsocketDescription;
  String? bathroomheatingCondition;
  String? bathroomheatingDescription;
  String? bathroomaccessoriesCondition;
  String? bathroomaccessoriesDescription;
  String? bathroomflooringCondition;
  String? bathroomflooringDescription;
  String? bathroomadditionItemsCondition;
  String? bathroomadditionItemsDescription;
  String? doorImagePath;
  String? doorFrameImagePath;
  String? ceilingImagePath;
  String? extractorFanImagePath;
  String? lightingImagePath;
  String? wallsImagePath;
  String? skirtingImagePath;
  String? windowSillImagePath;
  String? curtainsImagePath;
  String? blindsImagePath;
  String? toiletImagePath;
  String? basinImagePath;
  String? showerCubicleImagePath;
  String? bathImagePath;
  String? switchBoardImagePath;
  String? socketImagePath;
  String? heatingImagePath;
  String? accessoriesImagePath;
  String? flooringImagePath;
  String? additionItemsImagePath;
  List<String> bathroomdoorImages = [];
  List<String> bathroomdoorFrameImages = [];
  List<String> bathroomceilingImages = [];
  List<String> bathroomextractorFanImages = [];
  List<String> bathroomlightingImages = [];
  List<String> bathroomwallsImages = [];
  List<String> bathroomskirtingImages = [];
  List<String> bathroomwindowSillImages = [];
  List<String> bathroomcurtainsImages = [];
  List<String> bathroomblindsImages = [];
  List<String> bathroomtoiletImages = [];
  List<String> bathroombasinImages = [];
  List<String> bathroomshowerCubicleImages = [];
  List<String> bathroombathImages = [];
  List<String> bathroomswitchBoardImages = [];
  List<String> bathroomsocketImages = [];
  List<String> bathroom = [];
  List<String> bathroomheatingImages = [];
  List<String> bathroomaccessoriesImages = [];
  List<String> bathroomflooringImages = [];
  List<String> bathroomadditionItemsImages = [];

  //Front Garden
  String? gardenDescription;
  String? driveWayCondition;
  String? driveWayDescription;
  String? outsideLightingCondition;
  String? outsideLightingDescription;
  String? additionalItemsCondition;
  String? additionalItemsDescription;
  List<String> gardenImages = [];
  List<String> driveWayImages = [];
  List<String> outsideLightingImages = [];
  List<String> additionalItemsImages = [];

//garage
  String? newdoor;
  String? garageDoorCondition;
  String? garageDoorDescription;
  String? garageDoorFrameCondition;
  String? garageDoorFrameDescription;
  String? garageceilingCondition;
  String? garageceilingDescription;
  String? garagelightingCondition;
  String? garagelightingDescription;
  String? garagewallsCondition;
  String? garagewallsDescription;
  String? garageskirtingCondition;
  String? garageskirtingDescription;
  String? garagewindowSillCondition;
  String? garagewindowSillDescription;
  String? garagecurtainsCondition;
  String? garagecurtainsDescription;
  String? garageblindsCondition;
  String? garageblindsDescription;
  String? garagelightSwitchesCondition;
  String? garagelightSwitchesDescription;
  String? garagesocketsCondition;
  String? garagesocketsDescription;
  String? garageflooringCondition;
  String? garageflooringDescription;
  String? garageadditionalItemsCondition;
  String? garageadditionalItemsDescription;
  String? garagedoorImagePath;
  String? garagedoorFrameImagePath;
  String? garageceilingImagePath;
  String? garagelightingImagePath;
  String? garagewallsImagePath;
  String? garageskirtingImagePath;
  String? garagewindowSillImagePath;
  String? garagecurtainsImagePath;
  String? garageblindsImagePath;
  String? garagelightSwitchesImagePath;
  String? garagesocketsImagePath;
  String? garageflooringImagePath;
  String? garageadditionalItemsImagePath;
  List<String> garagedoorImages = [];
  List<String> garagedoorFrameImages = [];
  List<String> garageceilingImages = [];
  List<String> garagelightingImages = [];
  List<String> garagewallsImages = [];
  List<String> garageskirtingImages = [];
  List<String> garagewindowSillImages = [];
  List<String> garagecurtainsImages = [];
  List<String> garageblindsImages = [];
  List<String> garagelightSwitchesImages = [];
  List<String> garagesocketsImages = [];
  List<String> garageflooringImages = [];
  List<String> garageadditionalItemsImages = [];

//exterior
  String? exteriorFrontDoorCondition;
  String? exteriorFrontDoorDescription;
  String? exteriorFrontDoorFrameCondition;
  String? exteriorFrontDoorFrameDescription;
  String? exteriorFrontPorchCondition;
  String? exteriorFrontPorchDescription;
  String? exteriorFrontAdditionalItemsCondition;
  String? exteriorFrontAdditionalItemsDescription;
  List<String> exteriorFrontDoorImages = [];
  List<String> exteriorFrontDoorFrameImages = [];
  List<String> exteriorFrontPorchImages = [];
  List<String> exteriorFrontAdditionalItemsImages = [];

  //Entrance
  String? entranceDoorCondition;
  String? entranceDoorLocation;
  String? entranceDoorFrameCondition;
  String? entranceDoorFrameLocation;
  String? entranceDoorBellCondition;
  String? entranceCeilingCondition;
  String? entranceCeilingLocation;
  String? entranceLightingCondition;
  String? entranceLightingLocation;
  String? entranceWallsCondition;
  String? entranceWallsLocation;
  String? entranceSkirtingCondition;
  String? entranceSkirtingLocation;
  String? entranceWindowSillCondition;
  String? entranceWindowSillLocation;
  String? entranceCurtainsCondition;
  String? entranceCurtainsLocation;
  String? entranceBlindsCondition;
  String? entranceBlindsLocation;
  String? entranceLightSwitchesCondition;
  String? entranceLightSwitchesLocation;
  String? entranceSwitchCondition;
  String? entranceSocketsCondition;
  String? entranceSocketsLocation;
  String? entranceFlooringCondition;
  String? entranceFlooringLocation;
  String? entranceHeatingCondition;
  String? entranceAdditionalItemsCondition;
  String? entranceAdditionalItemsLocation;

  List<String> entranceDoorImages = [];
  List<String> entranceDoorFrameImages = [];
  List<String> entranceDoorBellImages = [];
  List<String> entranceCeilingImages = [];
  List<String> entranceLightingImages = [];
  List<String> entranceWallsImages = [];
  List<String> entranceSkirtingImages = [];
  List<String> entranceWindowSillImages = [];
  List<String> entranceCurtainsImages = [];
  List<String> entranceBlindsImages = [];
  List<String> entranceLightSwitchesImages = [];
  List<String> entranceSocketsImages = [];
  List<String> entranceHeatingImages = [];
  List<String> entranceFlooringImages = [];
  List<String> entranceAdditionalItemsImages = [];

//toilet
  String? toiletDoorCondition;
  String? toiletDoorDescription;
  String? toiletDoorFrameCondition;
  String? toiletDoorFrameDescription;
  String? toiletCeilingCondition;
  String? toiletCeilingDescription;
  String? toiletExtractorFanCondition;
  String? toiletExtractorFanDescription;
  String? toiletLightingCondition;
  String? toiletLightingDescription;
  String? toiletWallsCondition;
  String? toiletWallsDescription;
  String? toiletSkirtingCondition;
  String? toiletSkirtingDescription;
  String? toiletWindowSillCondition;
  String? toiletwWindowSillDescription;
  String? toiletCurtainsCondition;
  String? toiletCurtainsDescription;
  String? toiletBlindsCondition;
  String? toiletBlindsDescription;
  String? toiletToiletCondition;
  String? toiletToiletDescription;
  String? toiletBasinCondition;
  String? toiletBasinDescription;
  String? toiletShowerCubicleCondition;
  String? toiletShowerCubicleDescription;
  String? toiletBathCondition;
  String? toiletBathDescription;
  String? toiletSwitchBoardCondition;
  String? toiletSwitchBoardDescription;
  String? toiletSocketCondition;
  String? toiletSocketDescription;
  String? toiletHeatingCondition;
  String? toiletHeatingDescription;
  String? toiletAccessoriesCondition;
  String? toiletAccessoriesDescription;
  String? toiletFlooringCondition;
  String? toiletFlooringDescription;
  String? toiletAdditionalItemsCondition;
  String? toiletAdditionalItemsDescription;

  List<String> toiletDoorImages = [];
  List<String> toiletDoorFrameImages = [];
  List<String> toiletCeilingImages = [];
  List<String> toiletExtractorFanImages = [];
  List<String> toiletlLightingImages = [];
  List<String> toiletWallsImages = [];
  List<String> toiletSkirtingImages = [];
  List<String> toiletWindowSillImages = [];
  List<String> toiletCurtainsImages = [];
  List<String> toiletBlindsImages = [];
  List<String> toiletToiletImages = [];
  List<String> toiletBasinImages = [];
  List<String> toiletShowerCubicleImages = [];
  List<String> toiletBathImages = [];
  List<String> toiletSwitchBoardImages = [];
  List<String> toiletSocketImages = [];
  List<String> toiletHeatingImages = [];
  List<String> toiletAccessoriesImages = [];
  List<String> toiletFlooringImages = [];
  List<String> toiletAdditionalItemsImages = [];

  //rear garden
  String? reargardenDescription;
  String? rearGardenOutsideLighting;
  String? rearGardensummerHouse;
  String? rearGardenshed;
  String? rearGardenadditionalInformation;
  List<String> reargardenDescriptionImages = [];
  List<String> rearGardenOutsideLightingImages = [];
  List<String> rearGardensummerHouseImages = [];
  List<String> rearGardenshedImages = [];
  List<String> rearGardenadditionalInformationImages = [];

  //Stairs
  String? stairsdoorCondition;
  String? stairsdoorDescription;
  String? stairsdoorFrameCondition;
  String? stairsdoorFrameDescription;
  String? stairsceilingCondition;
  String? stairsceilingDescription;
  String? stairslightingCondition;
  String? stairslightingDescription;
  String? stairswallsCondition;
  String? stairswallsDescription;
  String? stairsskirtingCondition;
  String? stairsskirtingDescription;
  String? stairswindowSillCondition;
  String? stairswindowSillDescription;
  String? stairscurtainsCondition;
  String? stairscurtainsDescription;
  String? stairsblindsCondition;
  String? stairsblindsDescription;
  String? stairslightSwitchesCondition;
  String? stairslightSwitchesDescription;
  String? stairssocketsCondition;
  String? stairssocketsDescription;
  String? stairsflooringCondition;
  String? stairsflooringDescription;
  String? stairsadditionalItemsCondition;
  String? stairsadditionalItemsDescription;
  List<String> stairsdoorImages = [];
  List<String> stairsdoorFrameImages = [];
  List<String> stairsceilingImages = [];
  List<String> stairslightingImages = [];
  List<String> stairswallsImages = [];
  List<String> stairsskirtingImages = [];
  List<String> stairswindowSillImages = [];
  List<String> stairscurtainsImages = [];
  List<String> stairsblindsImages = [];
  List<String> stairslightSwitchesImages = [];
  List<String> stairssocketsImages = [];
  List<String> stairsflooringImages = [];
  List<String> stairsadditionalItemsImages = [];

  //Utility Area
  String? utilityNewdoor;
  String? utilityDoorCondition;
  String? utilityDoorDescription;
  String? utilityDoorFrameCondition;
  String? utilityDoorFrameDescription;
  String? utilityCeilingCondition;
  String? utilityCeilingDescription;
  String? utilityLightingCondition;
  String? utilitylightingDescription;
  String? utilitywallsCondition;
  String? utilitywallsDescription;
  String? utilityskirtingCondition;
  String? utilityskirtingDescription;
  String? utilitywindowSillCondition;
  String? utilitywindowSillDescription;
  String? utilitycurtainsCondition;
  String? utilitycurtainsDescription;
  String? utilityblindsCondition;
  String? utilityblindsDescription;
  String? utilitylightSwitchesCondition;
  String? utilitylightSwitchesDescription;
  String? utilitysocketsCondition;
  String? utilitysocketsDescription;
  String? utilityflooringCondition;
  String? utilityflooringDescription;
  String? utilityadditionalItemsCondition;
  String? utilityadditionalItemsDescription;
  List<String> utilitydoorImages = [];
  List<String> utilitydoorFrameImages = [];
  List<String> utilityceilingImages = [];
  List<String> utilitylightingImages = [];
  List<String> utilitywallsImages = [];
  List<String> utilityskirtingImages = [];
  List<String> utilitywindowSillImages = [];
  List<String> utilitycurtainsImages = [];
  List<String> utilityblindsImages = [];
  List<String> utilitylightSwitchesImages = [];
  List<String> utilitysocketsImages = [];
  List<String> utilityflooringImages = [];
  List<String> utilityadditionalItemsImages = [];

//bedroom
  String? bedRoomDoorLocation;
  String? bedRoomDoorCondition;
  String? bedRoomDoorFrameLocation;
  String? bedRoomDoorFrameCondition;
  String? bedRoomCeilingLocation;
  String? bedRoomCeilingCondition;
  String? bedRoomLightingLocation;
  String? bedRoomLightingCondition;
  String? bedRoomWallsLocation;
  String? bedRoomWallsCondition;
  String? bedRoomSkirtingLocation;
  String? bedRoomsSkirtingCondition;
  String? bedRoomWindowSillLocation;
  String? bedRoomWindowSillCondition;
  String? bedRoomCurtainsLocation;
  String? bedRoomCurtainsCondition;
  String? bedRoomBlindsLocation;
  String? bedRoomBlindsCondition;
  String? bedRoomLightSwitchesLocation;
  String? bedRoomLightSwitchesCondition;
  String? bedRoomSocketsLocation;
  String? bedRoomSocketsCondition;
  String? bedRoomFlooringLocation;
  String? bedRoomFlooringCondition;
  String? bedRoomAdditionalItemsLocation;
  String? bedRoomAdditionalItemsCondition;

  List<String> bedRoomDoorImages = [];
  List<String> bedRoomDoorFrameImages = [];
  List<String> bedRoomCeilingImages = [];
  List<String> bedRoomlLightingImages = [];
  List<String> bedRoomwWallsImages = [];
  List<String> bedRoomSkirtingImages = [];
  List<String> bedRoomWindowSillImages = [];
  List<String> bedRoomCurtainsImages = [];
  List<String> bedRoomBlindsImages = [];
  List<String> bedRoomLightSwitchesImages = [];
  List<String> bedRoomSocketsImages = [];
  List<String> bedRoomFlooringImages = [];
  List<String> bedRoomAdditionalItemsImages = [];
  late List<File> capturedImages;

  String? kitchenNewDoor;
  String? kitchenDoorCondition;
  String? kitchenDoorDescription;
  String? kitchenDoorFrameCondition;
  String? kitchenDoorFrameDescription;
  String? kitchenCeilingCondition;
  String? kitchenCeilingDescription;
  String? kitchenExtractorFanCondition;
  String? kitchenExtractorFanDescription;
  String? kitchenLightingCondition;
  String? kitchenLightingDescription;
  String? kitchenLightSwitchesCondition;
  String? kitchenLightSwitchesDescription;
  String? kitchenWallsCondition;
  String? kitchenWallsDescription;
  String? kitchenSkirtingCondition;
  String? kitchenSkirtingDescription;
  String? kitchenWindowSillCondition;
  String? kitchenWindowSillDescription;
  String? kitchenCurtainsCondition;
  String? kitchenCurtainsDescription;
  String? kitchenCuboardsCondition;
  String? kitchenCuboardsDescription;
  String? kitchenHobCondition;
  String? kitchenHobDescription;
  String? kitchenTapCondition;
  String? kitchenTapDescription;
  String? kitchenBlindsCondition;
  String? kitchenBlindsDescription;
  String? kitchenSwitchBoardCondition;
  String? kitchenSwitchBoardDescription;
  String? kitchenSocketCondition;
  String? kitchenSocketDescription;
  String? kitchenHeatingCondition;
  String? kitchenHeatingDescription;
  String? kitchenAccessoriesCondition;
  String? kitchenAccessoriesDescription;
  String? kitchenFlooringCondition;
  String? kitchenFlooringDescription;
  String? kichenKitchenUnitsCondition;
  String? kitchenKitchenUnitsDescription;
  String? kitchenExtractorHoodCondition;
  String? kitchenExtractorHoodDescription;
  String? kitchenCookerCondition;
  String? kitchenCookerDescription;
  String? kitchenFridgeFreezerCondition;
  String? kitchenFridgeFreezerDescription;
  String? kitchenWashingMachineCondition;
  String? kitchenWashingMachineDescription;
  String? kitchenDishwasherCondition;
  String? kitchenDishwasherDescription;
  String? kitchenTumbleDryerCondition;
  String? kitchenTumbleDryerDescription;
  String? kitchenMicrowaveCondition;
  String? kitchenMicrowaveDescription;
  String? kitchenUnitCondition;
  String? kitchenUnitDescription;
  String? kitchenToasterCondition;
  String? kitchenToasterDescription;
  String? kitchenVacuumCleanerCondition;
  String? kitchenVacuumCleanerDescription;
  String? kitchenBroomCondition;
  String? kitchenBroomDescription;
  String? kitchenMopBucketCondition;
  String? kitchenMopBucketDescription;
  String? kitchenSinkCondition;
  String? kitchenSinkDescription;
  String? kitchenWorktopCondition;
  String? kitchenWorktopDescription;
  String? kitchenOvenCondition;
  String? kitchenOvenDescription;
  String? kitchenAdditionItemsCondition;
  String? kitchenAdditionItemsDescription;
  List<String> kitchenDoorImages = [];
  List<String> kitchenDoorFrameImages = [];
  List<String> kitchenCeilingImages = [];
  List<String> kitchenExtractorFanImages = [];
  List<String> kitchenLightingImages = [];
  List<String> kitchenLightSwitchesImages = [];
  List<String> kitchenWallsImages = [];
  List<String> kitchenSkirtingImages = [];
  List<String> kitchenWindowSillImages = [];
  List<String> ktichenCurtainsImages = [];
  List<String> kitchenCuboardsImages = [];
  List<String> kitchenHobImages = [];
  List<String> kitchenTapImages = [];
  List<String> kitchenBlindsImages = [];
  List<String> kitchenBathImages = [];
  List<String> kitchenSwitchBoardImages = [];
  List<String> kitchenSocketImages = [];
  List<String> kitchenHeatingImages = [];
  List<String> kitchenAccessoriesImages = [];
  List<String> kitchenFlooringImages = [];
  List<String> kitchenKitchenUnitsImages = [];
  List<String> kitchenExtractorHoodImages = [];
  List<String> kitchenCookerImages = [];
  List<String> kitchenFridgeFreezerImages = [];
  List<String> kitchenWashingMachineImages = [];
  List<String> kitchenDishwasherImages = [];
  List<String> kitchenMicrowaveImages = [];
  List<String> kitchenUnitImages = [];
  List<String> kitchenToasterImages = [];
  List<String> kitchenVacuumCleanerImages = [];
  List<String> kitchenBroomImages = [];
  List<String> kitchenMopBucketImages = [];
  List<String> kitchenSinkImages = [];
  List<String> kitchenWorktopImages = [];
  List<String> kitchenOvenImages = [];
  List<String> kitchenAdditionItemsImages = [];

  String? lougeDoorCondition;
  String? loungedoorDescription;
  String? loungedoorFrameCondition;
  String? loungedoorFrameDescription;
  String? loungeceilingCondition;
  String? loungeceilingDescription;
  String? loungelightingCondition;
  String? loungelightingDescription;
  String? loungewallsCondition;
  String? loungewallsDescription;
  String? loungeskirtingCondition;
  String? loungeskirtingDescription;
  String? loungewindowSillCondition;
  String? loungewindowSillDescription;
  String? loungecurtainsCondition;
  String? loungecurtainsDescription;
  String? loungeblindsCondition;
  String? loungeblindsDescription;
  String? loungelightSwitchesCondition;
  String? loungelightSwitchesDescription;
  String? loungesocketsCondition;
  String? loungesocketsDescription;
  String? loungeflooringCondition;
  String? loungeflooringDescription;
  String? loungeadditionalItemsCondition;
  String? loungeadditionalItemsDescription;
  List<String> loungedoorImages = [];
  List<String> loungedoorFrameImages = [];
  List<String> loungeceilingImages = [];
  List<String> loungelightingImages = [];
  List<String> loungewallsImages = [];
  List<String> loungeskirtingImages = [];
  List<String> loungewindowSillImages = [];
  List<String> loungecurtainsImages = [];
  List<String> loungeblindsImages = [];
  List<String> loungelightSwitchesImages = [];
  List<String> loungesocketsImages = [];
  List<String> loungeflooringImages = [];
  List<String> loungeadditionalItemsImages = [];
  late List<File> loungecapturedImages;

  String? houseApplinceManual;
  String? houseApplinceManualDescription;
  String? kitchenApplinceManual;
  String? kitchenApplinceManualDescription;
  String? heatingManual;
  String? heatingManualDescription;
  String? landlordGasSafetyCertificate;
  String? landlordGasSafetyCertificateDescription;
  String? legionellaRiskAssessment;
  String? legionellaRiskAssessmentDescription;
  String? electricalSafetyCertificate;
  String? electricalSafetyCertificateDescription;
  String? energyPerformanceCertificate;
  String? energyPerformanceCertificateDescription;
  String? moveInChecklist;
  String? moveInChecklistDescription;
  List<String> houseApplinceManualImages = [];
  List<String> kitchenApplinceManualImages = [];
  List<String> heatingManualImages = [];
  List<String> landlordGasSafetyCertificateImages = [];
  List<String> legionellaRiskAssessmentImages = [];
  List<String> electricalSafetyCertificateImages = [];
  List<String> energyPerformanceCertificateImages = [];
  List<String> moveInChecklistImages = [];

  String? landingnewdoor;
  String? landingdoorCondition;
  String? landingdoorDescription;
  String? landingdoorFrameCondition;
  String? landingdoorFrameDescription;
  String? landingceilingCondition;
  String? landingceilingDescription;
  String? landinglightingCondition;
  String? landinglightingDescription;
  String? landingwallsCondition;
  String? landingwallsDescription;
  String? landingskirtingCondition;
  String? landingskirtingDescription;
  String? landingwindowSillCondition;
  String? landingwindowSillDescription;
  String? landingcurtainsCondition;
  String? landingcurtainsDescription;
  String? landingblindsCondition;
  String? landingblindsDescription;
  String? landinglightSwitchesCondition;
  String? landinglightSwitchesDescription;
  String? landingsocketsCondition;
  String? landingsocketsDescription;
  String? landingflooringCondition;
  String? landingflooringDescription;
  String? landingadditionalItemsCondition;
  String? landingadditionalItemsDescription;
  List<String> landingdoorImages = [];
  List<String> landingdoorFrameImages = [];
  List<String> landingceilingImages = [];
  List<String> landinglightingImages = [];
  List<String> ladingwallsImages = [];
  List<String> landingskirtingImages = [];
  List<String> landingwindowSillImages = [];
  List<String> landingcurtainsImages = [];
  List<String> landingblindsImages = [];
  List<String> landinglightSwitchesImages = [];
  List<String> landingsocketsImages = [];
  List<String> landingflooringImages = [];
  List<String> landingadditionalItemsImages = [];

//dinning room
  String? diningGasMeterCondition;
  String? diningGasMeterLocation;
  String? diningElectricMeterCondition;
  String? diningElectricMeterLocation;
  String? diningWaterMeterCondition;
  String? diningWaterMeterLocation;
  String? diningOilMeterCondition;
  String? diningOilMeterLocation;
  List<String> diningGasMeterImages = [];
  List<String> diningElectricMeterImages = [];
  List<String> diningWaterMeterImages = [];
  List<String> diningOilMeterImages = [];

  //ensuit
  String? ensuitdoorCondition;
  String? ensuitdoorLocation;
  String? ensuitdoorFrameCondition;
  String? ensuitedoorFrameLocation;
  String? ensuiteceilingCondition;
  String? ensuitceilingLocation;
  String? ensuitlightingCondition;
  String? ensuitelightingLocation;
  String? ensuitewallsCondition;
  String? ensuitewallsLocation;
  String? ensuiteskirtingCondition;
  String? ensuiteskirtingLocation;
  String? ensuitewindowSillCondition;
  String? ensuitewindowSillLocation;
  String? ensuitecurtainsCondition;
  String? ensuitecurtainsLocation;
  String? ensuiteblindsCondition;
  String? ensuiteblindsLocation;
  String? ensuitelightSwitchesCondition;
  String? ensuitelightSwitchesLocation;
  String? ensuiteToiletCondition;
  String? ensuiteToiletLocation;
  String? ensuiteBasinCondition;
  String? ensuiteBasinLocation;
  String? ensuiteShowerCubicleCondition;
  String? ensuiteShowerCubicleLocation;
  String? ensuiteSwitchCondition;
  String? ensuiteSwitchLocation;
  String? ensuiteSocketCondition;
  String? ensuiteSocketLocation;
  String? ensuiteHeatingCondition;
  String? ensuiteHeatingLocation;
  String? ensuiteAccessoriesCondition;
  String? ensuiteAccessoriesLocation;
  String? ensuiteFlooringCondition;
  String? ensuiteFlooringLocation;
  String? ensuiteAdditionItemsCondition;
  String? ensuiteAdditionItemsLocation;
  String? ensuiteShowerCondition;
  String? ensuiteShowerLocation;
  List<String> ensuitedoorImages = [];
  List<String> ensuitedoorFrameImages = [];
  List<String> ensuiteceilingImages = [];
  List<String> ensuitelightingImages = [];
  List<String> ensuitewallsImages = [];
  List<String> ensuiteskirtingImages = [];
  List<String> ensuitewindowSillImages = [];
  List<String> ensuitecurtainsImages = [];
  List<String> ensuiteToiletImages = [];
  List<String> ensuiteBasinImages = [];
  List<String> ensuiteShowerCubicleImages = [];
  List<String> ensuiteShowerImages = [];
  List<String> ensuiteSwitchImages = [];
  List<String> ensuiteSocketImages = [];
  List<String> ensuiteHeatingImages = [];
  List<String> ensuiteAccessoriesImages = [];
  List<String> ensuiteblindsImages = [];
  List<String> ensuitelightSwitchesImages = [];
  List<String> ensuiteflooringImages = [];
  List<String> ensuiteadditionalItemsImages = [];

  @override
  void initState() {
    super.initState();
    fetchProperties();
    getFirebaseUserId();
    // fetchProperties();
    controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
    getSharedPreferencesData();
    // print(overview);
    _loadPreferences(widget.propertyId);
    fetchProperties();
    fetchImages();
  }

  Future<void> fetchImages() async {
    keysHandOverYaleImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys_handover', 'yaleImages');
    keysHandOverMorticeImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys_handover', 'morticeImages');
    keysHandOverOtherImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys_handover', 'otherImages');
    evChargerImages = await fetchDataFromFirestore(
        widget.propertyId, 'EvCharger', 'EvCharger');
    gasMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'meter_reading', 'gasMeterImages');
    electricMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'meter_reading', 'electricMeterImages');
    waterMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'meter_reading', 'waterMeterImages');
    oilMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'meter_reading', 'oilMeterImages');
    otherMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'meter_reading', 'otherMeterImages');
    overviewImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'overviewImages');
    accessoryCleanlinessImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'accessoryCleanlinessImages');
    windowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'windowSillImages');
    carpetsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'carpetsImages');
    ceilingsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'ceilingsImages');
    curtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'curtainsImages');
    hardFlooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'hardFlooringImages');
    kitchenAreaImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'kitchenAreaImages');
    kitchenImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'kitchenImages');
    ovenImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'ovenImages');
    mattressImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'mattressImages');
    upholstreyImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'upholstreyImages');
    wallImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'wallImages');
    windowImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'windowImages');
    woodworkImages = await fetchDataFromFirestore(
        widget.propertyId, 'ScheduleOfCondition', 'woodworkImages');
    yaleImages =
    await fetchDataFromFirestore(widget.propertyId, 'keys', 'yaleImages');
    morticeImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys', 'morticeImages');
    windowLockImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys', 'windowLockImages');
    keygasMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys', 'keygasMeterImages');
    carPassImages = await fetchDataFromFirestore(
        widget.propertyId, 'keys', 'carPassImages');
    remoteImages =
    await fetchDataFromFirestore(widget.propertyId, 'keys', 'remoteImages');
    otherImages =
    await fetchDataFromFirestore(widget.propertyId, 'keys', 'otherImages');
    heatSensorImages = await fetchDataFromFirestore(
        widget.propertyId, 'healthAndSafety', 'heatSensorImages');
    smokeAlarmImages = await fetchDataFromFirestore(
        widget.propertyId, 'healthAndSafety', 'smokeAlarmImages');
    carbonMonxideImages = await fetchDataFromFirestore(
        widget.propertyId, 'healthAndSafety', 'carbonMonxideImages');
    gardenImages = await fetchDataFromFirestore(
        widget.propertyId, 'front_garden', 'gardenImages');
    driveWayImages = await fetchDataFromFirestore(
        widget.propertyId, 'front_garden', 'driveWayImages');
    outsideLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'front_garden', 'outsideLightingImages');
    additionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'front_garden', 'additionalItemsImages');
    garagedoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagedoorImages');
    garagedoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagedoorFrameImages');
    garageceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garageceilingImages');
    garagelightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagelightingImages');
    garagewallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagewallsImages');
    garageskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garageskirtingImages');
    garagewindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagewindowSillImages');
    garagecurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagecurtainsImages');
    garageblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garageblindsImages');
    garagelightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagelightSwitchesImages');
    garagesocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garagesocketsImages');
    garageflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garageflooringImages');
    garageadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'garage', 'garageadditionalItemsImages');
    exteriorFrontDoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'exterior_front', 'exteriorFrontDoorImages');
    exteriorFrontDoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'exterior_front', 'exteriorFrontDoorFrameImages');
    exteriorFrontPorchImages = await fetchDataFromFirestore(
        widget.propertyId, 'exterior_front', 'exteriorFrontPorchImages');
    exteriorFrontAdditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId,
        'exterior_front',
        'exteriorFrontAdditionalItemsImages');
    entranceDoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceDoorImages');
    entranceDoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceDoorFrameImages');
    entranceDoorBellImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceDoorBellImages');
    entranceCeilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceCeilingImages');
    entranceLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceLightingImages');
    entranceWallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceWallsImages');
    entranceSkirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceSkirtingImages');
    entranceWindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceWindowSillImages');
    entranceCurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceCurtainsImages');
    entranceBlindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceBlindsImages');
    entranceLightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceLightSwitchesImages');
    entranceSocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceSocketsImages');
    entranceHeatingImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceHeatingImages');
    entranceFlooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceFlooringImages');
    entranceAdditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'entranceHallway', 'entranceAdditionalItemsImages');

    toiletDoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletDoorImages');
    toiletDoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletDoorFrameImages');
    toiletCeilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletCeilingImages');
    toiletExtractorFanImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletExtractorFanImages');
    toiletlLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletlLightingImages');
    toiletWallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletWallsImages');
    toiletSkirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletSkirtingImages');
    toiletWindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletWindowSillImages');
    toiletCurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletCurtainsImages');
    toiletBlindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletBlindsImages');
    toiletToiletImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletToiletImages');
    toiletBasinImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletBasinImages');
    toiletShowerCubicleImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletShowerCubicleImages');
    toiletBathImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletBathImages');
    toiletSwitchBoardImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletSwitchBoardImages');
    toiletSocketImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletSocketImages');
    toiletHeatingImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletHeatingImages');
    toiletAccessoriesImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletAccessoriesImages');
    toiletFlooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletFlooringImages');
    toiletAdditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'toilet', 'toiletAdditionalItemsImages');
    reargardenDescriptionImages = await fetchDataFromFirestore(
        widget.propertyId, 'rearGarden', 'reargardenDescriptionImages');
    rearGardenOutsideLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'rearGarden', 'rearGardenOutsideLightingImages');
    rearGardensummerHouseImages = await fetchDataFromFirestore(
        widget.propertyId, 'rearGarden', 'rearGardensummerHouseImages');
    rearGardenshedImages = await fetchDataFromFirestore(
        widget.propertyId, 'rearGarden', 'rearGardenshedImages');
    rearGardenadditionalInformationImages = await fetchDataFromFirestore(
        widget.propertyId,
        'rearGarden',
        'rearGardenadditionalInformationImages');
    stairsdoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsdoorImages');
    stairsdoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsdoorFrameImages');
    stairsceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsceilingImages');
    stairslightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairslightingImages');
    stairswallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairswallsImages');
    stairsskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsskirtingImages');
    stairswindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairswindowSillImages');
    stairscurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairscurtainsImages');
    stairsblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsblindsImages');
    stairslightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairslightSwitchesImages');
    stairssocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairssocketsImages');
    stairsflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsflooringImages');
    stairsadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'stairs', 'stairsadditionalItemsImages');

    utilitydoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitydoorImages');
    utilitydoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitydoorFrameImages');
    utilityceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilityceilingImages');
    utilitylightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitylightingImages');
    utilitywallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitywallsImages');
    utilityskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilityskirtingImages');
    utilitywindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitywindowSillImages');
    utilitycurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitycurtainsImages');
    utilityblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilityblindsImages');
    utilitylightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitylightSwitchesImages');
    utilitysocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilitysocketsImages');
    utilityflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilityflooringImages');
    utilityadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'utility_room', 'utilityadditionalItemsImages');

    bedRoomDoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomDoorImages');
    bedRoomDoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomDoorFrameImages');
    bedRoomCeilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomCeilingImages');
    bedRoomlLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomlLightingImages');
    bedRoomwWallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomwWallsImages');
    bedRoomSkirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomSkirtingImages');
    bedRoomWindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomWindowSillImages');
    bedRoomCurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomCurtainsImages');
    bedRoomBlindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomBlindsImages');
    bedRoomLightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomLightSwitchesImages');
    bedRoomSocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomSocketsImages');
    bedRoomFlooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomFlooringImages');
    bedRoomAdditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bedroom', 'bedRoomAdditionalItemsImages');

    kitchenDoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenDoorImages');
    kitchenDoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenDoorFrameImages');
    kitchenCeilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenCeilingImages');
    kitchenExtractorFanImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenExtractorFanImages');
    kitchenLightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenLightingImages');
    kitchenWallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenWallsImages');
    kitchenSkirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenSkirtingImages');
    kitchenWindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenWindowSillImages');
    ktichenCurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'ktichenCurtainsImages');
    kitchenBlindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenBlindsImages');

    kitchenBathImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenBathImages');
    kitchenSwitchBoardImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenSwitchBoardImages');
    kitchenSocketImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenSocketImages');
    kitchenHeatingImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenHeatingImages');
    kitchenAccessoriesImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenAccessoriesImages');
    kitchenFlooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenFlooringImages');
    kitchenAdditionItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'kitchen', 'kitchenAdditionItemsImages');

    loungedoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungedoorImages');
    loungedoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungedoorFrameImages');
    loungeceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungeceilingImages');
    loungelightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungelightingImages');
    loungewallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungewallsImages');
    loungeskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungeskirtingImages');
    loungewindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungewindowSillImages');
    loungecurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungecurtainsImages');
    loungeblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungeblindsImages');
    loungelightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungelightSwitchesImages');
    loungesocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungesocketsImages');
    loungeflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungeflooringImages');
    loungeadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'lounge', 'loungeadditionalItemsImages');

    houseApplinceManualImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'houseApplinceManualImages');
    kitchenApplinceManualImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'kitchenApplinceManualImages');
    heatingManualImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'heatingManualImages');
    landlordGasSafetyCertificateImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'landlordGasSafetyCertificateImages');
    legionellaRiskAssessmentImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'legionellaRiskAssessmentImages');
    electricalSafetyCertificateImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'electricalSafetyCertificateImages');
    energyPerformanceCertificateImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'energyPerformanceCertificateImages');
    moveInChecklistImages = await fetchDataFromFirestore(
        widget.propertyId, 'manuals', 'moveInChecklistImages');

    landingdoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingdoorImages');
    landingdoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingdoorFrameImages');
    landingceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingceilingImages');
    landinglightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landinglightingImages');
    ladingwallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'ladingwallsImages');
    landingskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingskirtingImages');
    landingwindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingwindowSillImages');
    landingcurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingcurtainsImages');
    landingblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingblindsImages');
    landinglightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landinglightSwitchesImages');
    landingsocketsImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingsocketsImages');
    landingflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingflooringImages');
    landingadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'landing', 'landingadditionalItemsImages');

    diningGasMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'dining_room', 'diningGasMeterImages');
    diningElectricMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'dining_room', 'diningElectricMeterImages');
    diningWaterMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'dining_room', 'diningWaterMeterImages');
    diningOilMeterImages = await fetchDataFromFirestore(
        widget.propertyId, 'dining_room', 'diningOilMeterImages');

    ensuitedoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitedoorImages');
    ensuitedoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitedoorFrameImages');
    ensuiteceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteceilingImages');
    ensuitelightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitelightingImages');
    ensuitewallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitewallsImages');
    ensuiteskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteskirtingImages');
    ensuitewindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitewindowSillImages');
    ensuitecurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitecurtainsImages');
    ensuiteblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteblindsImages');
    ensuitelightSwitchesImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuitelightSwitchesImages');
    ensuiteToiletImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteToiletImages');
    ensuiteBasinImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteBasinImages');
    ensuiteShowerCubicleImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteShowerCubicleImages');
    ensuiteShowerImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteShowerImages');
    ensuiteSwitchImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteSwitchImages');
    ensuiteSocketImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteSocketImages');
    ensuiteHeatingImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteHeatingImages');
    ensuiteAccessoriesImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteAccessoriesImages');
    ensuiteflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteflooringImages');
    ensuiteadditionalItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'ensuite', 'ensuiteadditionalItemsImages');
    bathroomdoorImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomdoorImages');
    bathroomdoorFrameImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomdoorFrameImages');
    bathroomceilingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomceilingImages');
    bathroomextractorFanImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomextractorFanImages');
    bathroomlightingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomlightingImages');
    bathroomwallsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomWallsImages');
    bathroomskirtingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomskirtingImages');
    bathroomwindowSillImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomwindowSillImages');
    bathroomcurtainsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomcurtainsImages');
    bathroomblindsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomblindsImages');
    bathroomtoiletImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomtoiletImages');
    bathroombasinImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroombasinImages');
    bathroomshowerCubicleImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomshowerCubicleImages');
    bathroombathImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroombathImages');
    bathroomswitchBoardImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomswitchBoardImages');
    bathroomsocketImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomsocketImages');
    bathroomheatingImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomheatingImages');
    bathroomaccessoriesImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomaccessoriesImages');
    bathroomflooringImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomflooringImages');
    bathroomadditionItemsImages = await fetchDataFromFirestore(
        widget.propertyId, 'bathroom', 'bathroomadditionItemsImages');


    setState(() {});
  }

  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //SOC
      overview = prefs.getString('overview_${propertyId}' ?? "N/A");

      accessoryCleanliness =
          prefs.getString('accessoryCleanliness_${propertyId}');
      windowSill = prefs.getString('windowSill_${propertyId}' ?? "N/A");
      carpets = prefs.getString('carpets_${propertyId}');
      ceilings = prefs.getString('ceilings_${propertyId}');
      curtains = prefs.getString('curtains_${propertyId}');
      hardFlooring = prefs.getString('hardFlooring_${propertyId}');
      kitchenArea = prefs.getString('kitchenArea_${propertyId}');
      kitchen = prefs.getString('kitchen_${propertyId}');
      oven = prefs.getString('oven_${propertyId}');
      mattress = prefs.getString('mattress_${propertyId}');
      upholstrey = prefs.getString('upholstrey_${propertyId}');
      wall = prefs.getString('wall_${propertyId}');
      window = prefs.getString('window_${propertyId}');
      woodwork = prefs.getString('woodwork_${propertyId}');

      overviewImages =
          prefs.getStringList('overviewImages_${propertyId}') ?? [];
      accessoryCleanlinessImages =
          prefs.getStringList('accessoryCleanlinessImages_${propertyId}') ?? [];
      windowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      carpetsImages = prefs.getStringList('carpetsImages_${propertyId}') ?? [];
      ceilingsImages =
          prefs.getStringList('ceilingsImages_${propertyId}') ?? [];
      curtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      hardFlooringImages =
          prefs.getStringList('hardFlooringImages_${propertyId}') ?? [];
      kitchenAreaImages =
          prefs.getStringList('kitchenAreaImages_${propertyId}') ?? [];
      ovenImages = prefs.getStringList('ovenImages_${propertyId}') ?? [];
      mattressImages =
          prefs.getStringList('mattressImages_${propertyId}') ?? [];
      upholstreyImages =
          prefs.getStringList('upholstreyImages_${propertyId}') ?? [];
      wallImages = prefs.getStringList('wallImages_${propertyId}') ?? [];
      windowImages = prefs.getStringList('windowImages_${propertyId}') ?? [];
      woodworkImages =
          prefs.getStringList('woodworkImages_${propertyId}') ?? [];
      print(overview);

      //Keys Hand Over
      yale = prefs.getString('yale_${propertyId}');
      mortice = prefs.getString('mortice_${propertyId}');
      other = prefs.getString('other_${propertyId}');

      keysHandOverYaleImages =
          prefs.getStringList('yaleImages_${propertyId}') ?? [];
      keysHandOverMorticeImages =
          prefs.getStringList('morticeImages_${propertyId}') ?? [];
      keysHandOverOtherImages =
          prefs.getStringList('otherImages_${propertyId}') ?? [];

      evChargerDescription =
          prefs.getString('evChargerDescription_${propertyId}');

      evChargerImages =
          prefs.getStringList('evChargerImages_${propertyId}') ?? [];

      //Meter Readings
      GasMeterReading = prefs.getString('GasMeterReading_${propertyId}');
      electricMeterReading =
          prefs.getString('electricMeterReading_${propertyId}');
      waterMeterReading = prefs.getString('waterMeterReading_${propertyId}');
      oilMeterReading = prefs.getString('oilMeterReading_${propertyId}');
      otherMeterReading = prefs.getString('otherMeterReading_${propertyId}');

      waterMeterImages =
          prefs.getStringList('waterMeterImages_${propertyId}') ?? [];
      electricMeterImages =
          prefs.getStringList('electricMeterImages_${propertyId}') ?? [];
      waterMeterImages =
          prefs.getStringList('waterMeterImages_${propertyId}') ?? [];
      oilMeterImages =
          prefs.getStringList('oilMeterImages_${propertyId}') ?? [];
      otherMeterImages =
          prefs.getStringList('otherMeterImages_${propertyId}') ?? [];

      yaleLocation = prefs.getString('yaleLocation_${propertyId}');
      morticeLocation = prefs.getString('morticeLocation_${propertyId}');
      windowLockLocation = prefs.getString('windowLockLocation_${propertyId}');
      gasMeterLocation = prefs.getString('gasMeterLocation_${propertyId}');
      // keygasMeterImages = prefs.getString('gasMeterImages_${propertyId}');
      carPassLocation = prefs.getString('carPassLocation_${propertyId}');
      carPassReading = prefs.getString('carPassReading_${propertyId}');
      remoteLocation = prefs.getString('remoteLocation_${propertyId}');
      remoteReading = prefs.getString('remoteReading_${propertyId}');
      otherLocation = prefs.getString('otherLocation_${propertyId}');
      otherReading = prefs.getString('otherReading_${propertyId}');

      yaleImages = prefs.getStringList('yaleImages_${propertyId}') ?? [];
      morticeImages = prefs.getStringList('morticeImages_${propertyId}') ?? [];
      windowLockImages =
          prefs.getStringList('windowLockImages_${propertyId}') ?? [];
      keygasMeterImages =
          prefs.getStringList('keygasMeterImages_${propertyId}') ?? [];
      carPassImages = prefs.getStringList('carPassImages_${propertyId}') ?? [];
      remoteImages = prefs.getStringList('remoteImages_${propertyId}') ?? [];
      otherImages = prefs.getStringList('otherImages_${propertyId}') ?? [];

      //heltha and safety
      heatSensorCondition =
          prefs.getString('heatSensorCondition_${propertyId}');
      heatSensorDescription =
          prefs.getString('heatSensorDescription_${propertyId}');
      smokeAlarmCondition =
          prefs.getString('smokeAlarmCondition_${propertyId}');
      smokeAlarmDescription =
          prefs.getString('smokeAlarmDescription_${propertyId}');
      carbonMonoxideCondition =
          prefs.getString('carbonMonoxideCondition_${propertyId}');
      carbonMonoxideDescription =
          prefs.getString('carbonMonoxideDescription_${propertyId}');
      smokeAlarmImages =
          prefs.getStringList('smokeAlarmImages_${propertyId}') ?? [];
      heatSensorImages =
          prefs.getStringList('heatSensorImages_${propertyId}') ?? [];
      carbonMonxideImages =
          prefs.getStringList('carbonMonxideImages_${propertyId}') ?? [];

      bathroomdoorCondition =
          prefs.getString('bathroomdoorCondition_${propertyId}');
      bathroomdoorDescription =
          prefs.getString('bathroomdoorDescription_${propertyId}');
      bathroomdoorFrameCondition =
          prefs.getString('bathroomdoorFrameCondition_${propertyId}');
      bathroomdoorFrameDescription =
          prefs.getString('bathroomdoorFrameDescription_${propertyId}');
      bathroomceilingCondition =
          prefs.getString('bathroomceilingCondition_${propertyId}');
      bathroomceilingDescription =
          prefs.getString('bathroomceilingDescription_${propertyId}');
      bathroomextractorFanCondition =
          prefs.getString('bathroomextractorFanCondition_${propertyId}');
      bathroomextractorFanDescription =
          prefs.getString('bathroomextractorFanDescription_${propertyId}');
      bathroomlightingCondition =
          prefs.getString('bathroomlightingCondition_${propertyId}');
      bathroomlightingDescription =
          prefs.getString('bathroomlightingDescription_${propertyId}');
      bathroomwallsCondition =
          prefs.getString('bathroomwallsCondition_${propertyId}');
      bathroomwallsDescription =
          prefs.getString('bathroomwallsDescription_${propertyId}');
      bathroomskirtingCondition =
          prefs.getString('bathroomskirtingCondition_${propertyId}');
      bathroomskirtingDescription =
          prefs.getString('bathroomskirtingDescription_${propertyId}');
      bathroomwindowSillCondition =
          prefs.getString('bathroomwindowSillCondition_${propertyId}');
      bathroomwindowSillDescription =
          prefs.getString('bathroomwindowSillDescription_${propertyId}');
      bathroomcurtainsCondition =
          prefs.getString('bathroomcurtainsCondition_${propertyId}');
      bathroomcurtainsDescription =
          prefs.getString('bathroomcurtainsDescription_${propertyId}');
      bathroomblindsCondition =
          prefs.getString('bathroomblindsCondition_${propertyId}');
      bathroomblindsDescription =
          prefs.getString('bathroomblindsDescription_${propertyId}');
      bathroomtoiletCondition =
          prefs.getString('bathroomtoiletCondition_${propertyId}');
      bathroomtoiletDescription =
          prefs.getString('bathroomtoiletDescription_${propertyId}');
      bathroombasinCondition =
          prefs.getString('bathroombasinCondition_${propertyId}');
      bathroombasinDescription =
          prefs.getString('bathroombasinDescription_${propertyId}');
      bathroomshowerCubicleCondition =
          prefs.getString('bathroomshowerCubicleCondition_${propertyId}');
      bathroomshowerCubicleDescription =
          prefs.getString('bathroomshowerCubicleDescription_${propertyId}');
      bathroombathCondition =
          prefs.getString('bathroombathCondition_${propertyId}');
      bathroombathDescription =
          prefs.getString('bathroombathDescription_${propertyId}');
      bathroomswitchBoardCondition =
          prefs.getString('bathroomswitchBoardCondition_${propertyId}');
      bathroomswitchBoardDescription =
          prefs.getString('bathroomswitchBoardDescription_${propertyId}');
      bathroomsocketCondition =
          prefs.getString('bathroomsocketCondition_${propertyId}');
      bathroomsocketDescription =
          prefs.getString('bathroomsocketDescription_${propertyId}');
      bathroomheatingCondition =
          prefs.getString('bathroomheatingCondition_${propertyId}');
      bathroomheatingDescription =
          prefs.getString('bathroomheatingDescription_${propertyId}');
      bathroomaccessoriesCondition =
          prefs.getString('bathroomaccessoriesCondition_${propertyId}');
      bathroomaccessoriesDescription =
          prefs.getString('bathroomaccessoriesDescription_${propertyId}');
      bathroomflooringCondition =
          prefs.getString('bathroomflooringCondition_${propertyId}');
      bathroomflooringDescription =
          prefs.getString('bathroomflooringDescription_${propertyId}');
      bathroomadditionItemsCondition =
          prefs.getString('bathroomadditionItemsCondition_${propertyId}');
      bathroomadditionItemsDescription =
          prefs.getString('bathroomadditionItemsDescription_${propertyId}');

      bathroomdoorImages = prefs.getStringList('bathroomdoorImages') ?? [];
      bathroomdoorFrameImages =
          prefs.getStringList('bathroomdoorFrameImages') ?? [];
      bathroomceilingImages =
          prefs.getStringList('bathroomceilingImages') ?? [];
      bathroomextractorFanImages =
          prefs.getStringList('bathroomextractorFanImages') ?? [];
      bathroomlightingImages =
          prefs.getStringList('bathroomlightingImages') ?? [];
      bathroomwallsImages = prefs.getStringList('bathroomwallsImages') ?? [];
      bathroomskirtingImages =
          prefs.getStringList('bathroomskirtingImages') ?? [];
      bathroomwindowSillImages =
          prefs.getStringList('bathroomwindowSillImages') ?? [];
      bathroomheatingImages =
          prefs.getStringList('bathroomheatingImages') ?? [];
      bathroomcurtainsImages =
          prefs.getStringList('bathroomcurtainsImages') ?? [];
      bathroomblindsImages = prefs.getStringList('bathroomblindsImages') ?? [];
      bathroomtoiletImages = prefs.getStringList('bathroomtoiletImages') ?? [];
      bathroombasinImages = prefs.getStringList('bathroombasinImages') ?? [];
      bathroomshowerCubicleImages =
          prefs.getStringList('bathroomshowerCubicleImages') ?? [];
      bathroombathImages = prefs.getStringList('bathroombathImages') ?? [];
      bathroomswitchBoardImages =
          prefs.getStringList('bathroomswitchBoardImages') ?? [];
      bathroomsocketImages = prefs.getStringList('bathroomsocketImages') ?? [];
      bathroom = prefs.getStringList('bathroom') ?? [];
      bathroomaccessoriesImages =
          prefs.getStringList('bathroomaccessoriesImages') ?? [];
      bathroomflooringImages =
          prefs.getStringList('bathroomflooringImages') ?? [];
      bathroomadditionItemsImages =
          prefs.getStringList('bathroomadditionItemsImages') ?? [];

      //Front Garden
      gardenDescription = prefs.getString('gardenDescription_${propertyId}');
      driveWayCondition = prefs.getString('driveWayCondition_${propertyId}');
      driveWayDescription =
          prefs.getString('driveWayDescription_${propertyId}');
      outsideLightingCondition =
          prefs.getString('outsideLightingCondition_${propertyId}');
      outsideLightingDescription =
          prefs.getString('outsideLightingDescription_${propertyId}');
      additionalItemsCondition =
          prefs.getString('additionalItemsCondition_${propertyId}');
      additionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');
      gardenImages = prefs.getStringList('gardenImages_${propertyId}') ?? [];
      driveWayImages =
          prefs.getStringList('driveWayImages_${propertyId}') ?? [];
      outsideLightingImages =
          prefs.getStringList('outsideLightingImages_${propertyId}') ?? [];
      additionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      newdoor = prefs.getString('newdoor_${propertyId}');
      garageDoorCondition =
          prefs.getString('garageDoorCondition_${propertyId}');
      garageDoorDescription = prefs.getString('doorDescription_${propertyId}');
      garageDoorFrameCondition =
          prefs.getString('garageDoorFrameCondition_${propertyId}');
      garageDoorFrameDescription =
          prefs.getString('doorFrameDescription_${propertyId}');
      garageceilingCondition =
          prefs.getString('garageceilingCondition_${propertyId}');
      garageceilingDescription =
          prefs.getString('ceilingDescription_${propertyId}');
      garagelightingCondition =
          prefs.getString('garagelightingCondition_${propertyId}');
      garagelightingDescription =
          prefs.getString('lightingDescription_${propertyId}');
      garagewallsCondition =
          prefs.getString('garagewallsCondition_${propertyId}');
      garagewallsDescription =
          prefs.getString('wallsDescription_${propertyId}');
      garageskirtingCondition =
          prefs.getString('garageskirtingCondition_${propertyId}');
      garageskirtingDescription =
          prefs.getString('skirtingDescription_${propertyId}');
      garagewindowSillCondition =
          prefs.getString('garagewindowSillCondition_${propertyId}');
      garagewindowSillDescription =
          prefs.getString('windowSillDescription_${propertyId}');
      garagecurtainsCondition =
          prefs.getString('garagecurtainsCondition_${propertyId}');
      garagecurtainsDescription =
          prefs.getString('curtainsDescription_${propertyId}');
      garageblindsCondition =
          prefs.getString('garageblindsCondition_${propertyId}');
      garageblindsDescription =
          prefs.getString('blindsDescription_${propertyId}');
      garagelightSwitchesCondition =
          prefs.getString('garagelightSwitchesCondition_${propertyId}');
      garagelightSwitchesDescription =
          prefs.getString('lightSwitchesDescription_${propertyId}');
      garagesocketsCondition =
          prefs.getString('garagesocketsCondition_${propertyId}');
      garagesocketsDescription =
          prefs.getString('socketsDescription_${propertyId}');
      garageflooringCondition =
          prefs.getString('garageflooringCondition_${propertyId}');
      garageflooringDescription =
          prefs.getString('flooringDescription_${propertyId}');
      garageadditionalItemsCondition =
          prefs.getString('garageadditionalItemsCondition_${propertyId}');
      garageadditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');

      garagedoorFrameImages =
          prefs.getStringList('garagedoorFrameImages_${propertyId}') ?? [];
      garageceilingImages =
          prefs.getStringList('garageceilingImages_${propertyId}') ?? [];
      garagelightingImages =
          prefs.getStringList('garagelightingImages_${propertyId}') ?? [];
      garagewallsImages =
          prefs.getStringList('garagewallsImages_${propertyId}') ?? [];
      garageskirtingImages =
          prefs.getStringList('garageskirtingImages_${propertyId}') ?? [];
      garagewindowSillImages =
          prefs.getStringList('garagewindowSillImages_${propertyId}') ?? [];
      garagecurtainsImages =
          prefs.getStringList('garagecurtainsImages_${propertyId}') ?? [];
      garageblindsImages =
          prefs.getStringList('garageblindsImages_${propertyId}') ?? [];
      garagelightSwitchesImages =
          prefs.getStringList('garagelightSwitchesImages_${propertyId}') ?? [];
      garagesocketsImages =
          prefs.getStringList('garagesocketsImages_${propertyId}') ?? [];
      garageflooringImages =
          prefs.getStringList('garageflooringImages_${propertyId}') ?? [];
      garageadditionalItemsImages =
          prefs.getStringList('garageadditionalItemsImages_${propertyId}') ??
              [];

      exteriorFrontDoorCondition =
          prefs.getString('exteriorFrontDoorCondition_${propertyId}');
      exteriorFrontDoorDescription =
          prefs.getString('exteriorFrontDoorFrameCondition_${propertyId}');
      exteriorFrontDoorFrameCondition =
          prefs.getString('exteriorFrontDoorFrameCondition_${propertyId}');
      exteriorFrontDoorFrameDescription =
          prefs.getString('exteriorFrontDoorFrameCondition_${propertyId}');
      exteriorFrontPorchCondition =
          prefs.getString('exteriorFrontPorchCondition_${propertyId}');
      exteriorFrontPorchDescription =
          prefs.getString('porchDescription_${propertyId}');
      exteriorFrontAdditionalItemsCondition = prefs
          .getString('exteriorFrontAdditionalItemsCondition_${propertyId}');
      exteriorFrontAdditionalItemsDescription = prefs
          .getString('exteriorFrontAdditionalItemsDescription_${propertyId}');

      exteriorFrontDoorImages =
          prefs.getStringList('doorImages_${propertyId}') ?? [];
      exteriorFrontDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      exteriorFrontPorchImages =
          prefs.getStringList('porchImages_${propertyId}') ?? [];
      exteriorFrontAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      //Entrance
      entranceDoorCondition =
          prefs.getString('entranceDoorCondition_${propertyId}');
      entranceDoorLocation =
          prefs.getString('entranceDoorLocation_${propertyId}');
      entranceDoorFrameCondition =
          prefs.getString('entranceDoorFrameCondition_${propertyId}');
      entranceDoorFrameLocation =
          prefs.getString('doorFrameLocation_${propertyId}');
      entranceCeilingCondition =
          prefs.getString('entranceCeilingCondition_${propertyId}');
      entranceCeilingLocation =
          prefs.getString('ceilingLocation_${propertyId}');
      entranceLightingCondition =
          prefs.getString('entranceLightingCondition_${propertyId}');
      entranceLightingLocation =
          prefs.getString('lightingLocation_${propertyId}');
      entranceWallsCondition =
          prefs.getString('entranceWallsCondition_${propertyId}');
      entranceWallsLocation = prefs.getString('wallsLocation_${propertyId}');
      entranceSkirtingCondition =
          prefs.getString('entranceSkirtingCondition_${propertyId}');
      entranceSkirtingLocation =
          prefs.getString('skirtingLocation_${propertyId}');
      entranceWindowSillCondition =
          prefs.getString('entranceWindowSillCondition_${propertyId}');
      entranceWindowSillLocation =
          prefs.getString('windowSillLocation_${propertyId}');
      entranceCurtainsCondition =
          prefs.getString('entranceCurtainsCondition_${propertyId}');
      entranceCurtainsLocation =
          prefs.getString('curtainsLocation_${propertyId}');
      entranceBlindsCondition =
          prefs.getString('entranceBlindsCondition_${propertyId}');
      entranceDoorBellCondition =
          prefs.getString('entranceDoorBellCondition_${propertyId}');
      entranceBlindsLocation = prefs.getString('blindsLocation_${propertyId}');
      entranceLightSwitchesCondition =
          prefs.getString('entranceLightSwitchesCondition_${propertyId}');
      entranceLightSwitchesLocation =
          prefs.getString('lightSwitchesLocation_${propertyId}');
      entranceSocketsCondition =
          prefs.getString('entranceSocketsCondition_${propertyId}');
      entranceSocketsLocation =
          prefs.getString('socketsLocation_${propertyId}');
      entranceFlooringCondition =
          prefs.getString('entranceFlooringCondition_${propertyId}');
      entranceFlooringLocation =
          prefs.getString('flooringLocation_${propertyId}');
      entranceAdditionalItemsCondition =
          prefs.getString('entranceAdditionalItemsCondition_${propertyId}');
      entranceAdditionalItemsLocation =
          prefs.getString('additionalItemsLocation_${propertyId}');
      entranceHeatingCondition =
          prefs.getString('entranceHeatingCondition_${propertyId}');
      entranceDoorImages =
          prefs.getStringList('doorImages_${propertyId}') ?? [];
      entranceDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      entranceCeilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      entranceLightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      entranceWallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      entranceSkirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      entranceWindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      entranceCurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      entranceBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      entranceLightSwitchesImages =
          prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      entranceSocketsImages =
          prefs.getStringList('socketsImages_${propertyId}') ?? [];
      entranceFlooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      entranceAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      toiletDoorCondition =
          prefs.getString('toiletDoorCondition_${propertyId}');
      toiletDoorDescription =
          prefs.getString('toiletDoorDescription_${propertyId}');
      toiletDoorFrameCondition =
          prefs.getString('toiletDoorFrameCondition_${propertyId}');
      toiletDoorFrameDescription =
          prefs.getString('doorFrameDescription_${propertyId}');
      toiletCeilingCondition =
          prefs.getString('toiletCeilingCondition_${propertyId}');
      toiletCeilingDescription =
          prefs.getString('ceilingDescription_${propertyId}');
      toiletExtractorFanCondition =
          prefs.getString('toiletExtractorFanCondition_${propertyId}');
      toiletExtractorFanDescription =
          prefs.getString('extractorFanDescription_${propertyId}');
      toiletLightingCondition =
          prefs.getString('toiletLightingCondition_${propertyId}');
      toiletLightingDescription =
          prefs.getString('lightingDescriptionv_${propertyId}');
      toiletWallsCondition =
          prefs.getString('toiletWallsCondition_${propertyId}');
      toiletWallsDescription =
          prefs.getString('wallsDescription_${propertyId}');
      toiletSkirtingCondition =
          prefs.getString('toiletSkirtingCondition_${propertyId}');
      toiletSkirtingDescription =
          prefs.getString('skirtingDescription_${propertyId}');
      toiletWindowSillCondition =
          prefs.getString('toiletWindowSillCondition_${propertyId}');
      toiletwWindowSillDescription =
          prefs.getString('windowSillDescription_${propertyId}');
      toiletCurtainsCondition =
          prefs.getString('toiletCurtainsCondition_${propertyId}');
      toiletCurtainsDescription =
          prefs.getString('curtainsDescription_${propertyId}');
      toiletBlindsCondition =
          prefs.getString('toiletBlindsCondition_${propertyId}');
      toiletBlindsDescription =
          prefs.getString('blindsDescription_${propertyId}');
      toiletToiletCondition =
          prefs.getString('toiletToiletCondition_${propertyId}');
      toiletToiletDescription =
          prefs.getString('toiletDescription_${propertyId}');
      toiletBasinCondition =
          prefs.getString('toiletBasinCondition_${propertyId}');
      toiletBasinDescription =
          prefs.getString('basinDescription_${propertyId}');
      toiletShowerCubicleCondition =
          prefs.getString(' toiletShowerCubicleCondition_${propertyId}');
      toiletShowerCubicleDescription =
          prefs.getString('showerCubicleDescription_${propertyId}');
      toiletBathCondition =
          prefs.getString('toiletBathCondition_${propertyId}');
      toiletBathDescription = prefs.getString('bathDescription_${propertyId}');
      toiletSwitchBoardCondition =
          prefs.getString('toiletSwitchBoardCondition_${propertyId}');
      toiletSwitchBoardDescription =
          prefs.getString('switchBoardDescription_${propertyId}');
      toiletSocketCondition =
          prefs.getString('toiletSocketCondition_${propertyId}');
      toiletSocketDescription =
          prefs.getString('socketDescription_${propertyId}');
      toiletHeatingCondition =
          prefs.getString('toiletHeatingCondition_${propertyId}');
      toiletHeatingDescription =
          prefs.getString('heatingDescription_${propertyId}');
      toiletAccessoriesCondition =
          prefs.getString('toiletAccessoriesCondition_${propertyId}');
      toiletAccessoriesDescription =
          prefs.getString('accessoriesDescription_${propertyId}');
      toiletFlooringCondition =
          prefs.getString('toiletFlooringCondition_${propertyId}');
      toiletFlooringDescription =
          prefs.getString('flooringDescription_${propertyId}');
      toiletAdditionalItemsCondition =
          prefs.getString('toiletAdditionalItemsCondition_${propertyId}');
      toiletAdditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');
      toiletDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      toiletDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      toiletCeilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      toiletExtractorFanImages =
          prefs.getStringList('extractorFanImages_${propertyId}') ?? [];
      toiletlLightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      toiletWallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      toiletSkirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      toiletWindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      toiletCurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      toiletBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      toiletToiletImages =
          prefs.getStringList('toiletImages_${propertyId}') ?? [];
      toiletBasinImages =
          prefs.getStringList('basinImages_${propertyId}') ?? [];
      toiletShowerCubicleImages =
          prefs.getStringList('showerCubicleImages_${propertyId}') ?? [];
      toiletBathImages = prefs.getStringList('bathImages_${propertyId}') ?? [];
      toiletSwitchBoardImages =
          prefs.getStringList('switchBoardImages_${propertyId}') ?? [];
      toiletSocketImages =
          prefs.getStringList('socketImages_${propertyId}') ?? [];
      toiletHeatingImages =
          prefs.getStringList('heatingImages_${propertyId}') ?? [];
      toiletAccessoriesImages =
          prefs.getStringList('accessoriesImages_${propertyId}') ?? [];
      toiletFlooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      toiletAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      reargardenDescription =
          prefs.getString('reargardenDescription_${propertyId}');
      rearGardenOutsideLighting =
          prefs.getString('rearGardenOutsideLighting_${propertyId}');
      rearGardensummerHouse =
          prefs.getString('rearGardensummerHouse_${propertyId}');
      rearGardenshed = prefs.getString('rearGardenshed_${propertyId}');
      rearGardenadditionalInformation =
          prefs.getString('rearGardenadditionalInformation_${propertyId}');

      reargardenDescriptionImages =
          prefs.getStringList('reargardenDescriptionImages_${propertyId}') ??
              [];
      rearGardenOutsideLightingImages = prefs
          .getStringList('rearGardenOutsideLightingImages_${propertyId}') ??
          [];
      rearGardensummerHouseImages =
          prefs.getStringList('rearGardensummerHouseImages_${propertyId}') ??
              [];
      rearGardenshedImages =
          prefs.getStringList('rearGardenshedImages_${propertyId}') ?? [];
      rearGardenadditionalInformationImages = prefs.getStringList(
          'rearGardenadditionalInformationImages_${propertyId}') ??
          [];

      stairsdoorCondition =
          prefs.getString('stairsdoorCondition_${propertyId}');
      stairsdoorDescription =
          prefs.getString('stairsdoorDescription_${propertyId}');
      stairsdoorFrameCondition =
          prefs.getString('stairsdoorFrameCondition_${propertyId}');
      stairsdoorFrameDescription =
          prefs.getString('stairsdoorFrameCondition_${propertyId}');
      stairsceilingCondition =
          prefs.getString('stairsceilingCondition_${propertyId}');
      stairsceilingDescription =
          prefs.getString('stairsceilingDescription_${propertyId}');
      stairslightingCondition =
          prefs.getString('stairslightingCondition_${propertyId}');
      stairslightingDescription =
          prefs.getString('stairslightingDescription_${propertyId}');
      stairswallsCondition =
          prefs.getString('stairswallsCondition_${propertyId}');
      stairswallsDescription =
          prefs.getString('stairswallsDescription_${propertyId}');
      stairsskirtingCondition =
          prefs.getString('stairsskirtingCondition_${propertyId}');
      stairsskirtingDescription =
          prefs.getString('stairsskirtingDescription_${propertyId}');
      stairswindowSillCondition =
          prefs.getString('stairswindowSillCondition_${propertyId}');
      stairswindowSillDescription =
          prefs.getString('stairswindowSillDescription_${propertyId}');
      stairscurtainsCondition =
          prefs.getString('stairscurtainsCondition_${propertyId}');
      stairscurtainsDescription =
          prefs.getString('stairscurtainsDescription_${propertyId}');
      stairsblindsCondition =
          prefs.getString('stairsblindsCondition_${propertyId}');
      stairsblindsDescription =
          prefs.getString('stairsblindsDescription_${propertyId}');
      stairslightSwitchesCondition =
          prefs.getString('stairslightSwitchesCondition_${propertyId}');
      stairslightSwitchesDescription =
          prefs.getString('stairslightSwitchesDescription_${propertyId}');
      stairssocketsCondition =
          prefs.getString('stairssocketsCondition_${propertyId}');
      stairssocketsDescription =
          prefs.getString('stairssocketsDescription_${propertyId}');
      stairsflooringCondition =
          prefs.getString('stairsflooringCondition_${propertyId}');
      stairsflooringDescription =
          prefs.getString('stairsflooringDescription_${propertyId}');
      stairsadditionalItemsCondition =
          prefs.getString('stairsadditionalItemsCondition_${propertyId}');
      stairsadditionalItemsDescription =
          prefs.getString('stairsadditionalItemsDescription_${propertyId}');

      stairsdoorImages =
          prefs.getStringList('stairsdoorImages_${propertyId}') ?? [];
      stairsdoorFrameImages =
          prefs.getStringList('stairsdoorFrameImages_${propertyId}') ?? [];
      stairsceilingImages =
          prefs.getStringList('stairsceilingImages_${propertyId}') ?? [];
      stairslightingImages =
          prefs.getStringList('stairslightingImages_${propertyId}') ?? [];
      stairswallsImages =
          prefs.getStringList('stairswallsImages_${propertyId}') ?? [];
      stairsskirtingImages =
          prefs.getStringList('stairsskirtingImages_${propertyId}') ?? [];
      stairswindowSillImages =
          prefs.getStringList('stairswindowSillImages_${propertyId}') ?? [];
      stairscurtainsImages =
          prefs.getStringList('stairscurtainsImages_${propertyId}') ?? [];
      stairsblindsImages =
          prefs.getStringList('stairsblindsImages_${propertyId}') ?? [];
      stairslightSwitchesImages =
          prefs.getStringList('stairslightSwitchesImages_${propertyId}') ?? [];
      stairssocketsImages =
          prefs.getStringList('stairssocketsImages_${propertyId}') ?? [];
      stairsflooringImages =
          prefs.getStringList('stairslooringImages_${propertyId}') ?? [];
      stairsadditionalItemsImages =
          prefs.getStringList('stairsadditionalItemsImages_${propertyId}') ??
              [];

      houseApplinceManual =
          prefs.getString('houseApplinceManual_${propertyId}');
      houseApplinceManualDescription =
          prefs.getString('houseApplinceManualDescription_${propertyId}');
      kitchenApplinceManual =
          prefs.getString('kitchenApplinceManual_${propertyId}');
      kitchenApplinceManualDescription =
          prefs.getString('kitchenApplinceManualDescription_${propertyId}');
      heatingManual = prefs.getString('heatingManual_${propertyId}');
      heatingManualDescription =
          prefs.getString('heatingManualDescription_${propertyId}');
      landlordGasSafetyCertificate =
          prefs.getString('landlordGasSafetyCertificate_${propertyId}');
      landlordGasSafetyCertificateDescription = prefs
          .getString('landlordGasSafetyCertificateDescription_${propertyId}');
      legionellaRiskAssessment =
          prefs.getString('legionellaRiskAssessment_${propertyId}');
      legionellaRiskAssessmentDescription =
          prefs.getString('legionellaRiskAssessmentDescription_${propertyId}');
      electricalSafetyCertificate =
          prefs.getString('electricalSafetyCertificate_${propertyId}');
      electricalSafetyCertificateDescription = prefs
          .getString('electricalSafetyCertificateDescription_${propertyId}');
      energyPerformanceCertificate =
          prefs.getString('energyPerformanceCertificate_${propertyId}');
      energyPerformanceCertificateDescription = prefs
          .getString('energyPerformanceCertificateDescription_${propertyId}');
      moveInChecklist = prefs.getString('moveInChecklist_${propertyId}');
      moveInChecklistDescription =
          prefs.getString('moveInChecklistDescription_${propertyId}');

      houseApplinceManualImages =
          prefs.getStringList('houseApplinceManualImages_${propertyId}') ?? [];
      kitchenApplinceManualImages =
          prefs.getStringList('kitchenApplinceManualImages_${propertyId}') ??
              [];
      heatingManualImages =
          prefs.getStringList('heatingManualImages_${propertyId}') ?? [];
      landlordGasSafetyCertificateImages = prefs.getStringList(
          'landlordGasSafetyCertificateImages_${propertyId}') ??
          [];
      legionellaRiskAssessmentImages =
          prefs.getStringList('legionellaRiskAssessmentImages_${propertyId}') ??
              [];
      electricalSafetyCertificateImages = prefs.getStringList(
          'electricalSafetyCertificateImages_${propertyId}') ??
          [];
      energyPerformanceCertificateImages = prefs.getStringList(
          'energyPerformanceCertificateImages_${propertyId}') ??
          [];
      moveInChecklistImages =
          prefs.getStringList('moveInChecklistImages_${propertyId}') ?? [];

      landingnewdoor = prefs.getString('landingnewdoor_${propertyId}');
      landingdoorCondition =
          prefs.getString('landingdoorCondition_${propertyId}');
      landingdoorDescription =
          prefs.getString('landingdoorDescription_${propertyId}');
      landingdoorFrameCondition =
          prefs.getString('landingdoorFrameCondition_${propertyId}');
      landingdoorFrameDescription =
          prefs.getString('landingdoorFrameDescription_${propertyId}');
      landingceilingCondition =
          prefs.getString('landingceilingCondition_${propertyId}');
      landingceilingDescription =
          prefs.getString('landingceilingDescription_${propertyId}');
      landinglightingCondition =
          prefs.getString('landinglightingCondition_${propertyId}');
      landinglightingDescription =
          prefs.getString('landinglightingDescription_${propertyId}');
      landingwallsCondition =
          prefs.getString('landingwallsCondition_${propertyId}');
      landingwallsDescription =
          prefs.getString('landingwallsDescription_${propertyId}');
      landingskirtingCondition =
          prefs.getString('landingskirtingCondition_${propertyId}');
      landingskirtingDescription =
          prefs.getString('landingskirtingDescription_${propertyId}');
      landingwindowSillCondition =
          prefs.getString('landingwindowSillCondition_${propertyId}');
      landingwindowSillDescription =
          prefs.getString('landingwindowSillDescription_${propertyId}');
      landingcurtainsCondition =
          prefs.getString('landingcurtainsCondition_${propertyId}');
      landingcurtainsDescription =
          prefs.getString('landingcurtainsDescription_${propertyId}');
      landingblindsCondition =
          prefs.getString('landingblindsCondition_${propertyId}');
      landingblindsDescription =
          prefs.getString('landingblindsDescription_${propertyId}');
      landinglightSwitchesCondition =
          prefs.getString('landinglightSwitchesCondition_${propertyId}');
      landinglightSwitchesDescription =
          prefs.getString('landinglightSwitchesDescription_${propertyId}');
      landingsocketsCondition =
          prefs.getString('landingsocketsCondition_${propertyId}');
      landingsocketsDescription =
          prefs.getString('landingsocketsDescription_${propertyId}');
      landingflooringCondition =
          prefs.getString('landingflooringCondition_${propertyId}');
      landingflooringDescription =
          prefs.getString('landingflooringDescription_${propertyId}');
      landingadditionalItemsCondition =
          prefs.getString('landingadditionalItemsCondition_${propertyId}');
      landingadditionalItemsDescription =
          prefs.getString('landingadditionalItemsDescription_${propertyId}');
      landingdoorImages =
          prefs.getStringList('landingdoorImages_${propertyId}') ?? [];
      landingdoorFrameImages =
          prefs.getStringList('landingdoorFrameImages_${propertyId}') ?? [];
      landingceilingImages =
          prefs.getStringList('landingceilingImages_${propertyId}') ?? [];
      landinglightingImages =
          prefs.getStringList('landinglightingImages_${propertyId}') ?? [];
      ladingwallsImages =
          prefs.getStringList('ladingwallsImages_${propertyId}') ?? [];
      landingskirtingImages =
          prefs.getStringList('landingskirtingImages_${propertyId}') ?? [];
      landingwindowSillImages =
          prefs.getStringList('landingwindowSillImages_${propertyId}') ?? [];
      landingcurtainsImages =
          prefs.getStringList('landingcurtainsImages_${propertyId}') ?? [];
      landingblindsImages =
          prefs.getStringList('landingblindsImages_${propertyId}') ?? [];
      landinglightSwitchesImages =
          prefs.getStringList('landinglightSwitchesImages_${propertyId}') ?? [];
      landingsocketsImages =
          prefs.getStringList('landingsocketsImages_${propertyId}') ?? [];
      landingflooringImages =
          prefs.getStringList('landingflooringImages_${propertyId}') ?? [];
      landingadditionalItemsImages =
          prefs.getStringList('landingadditionalItemsImages_${propertyId}') ??
              [];

      diningGasMeterCondition =
          prefs.getString('diningGasMeterCondition_${propertyId}');
      diningGasMeterLocation =
          prefs.getString('diningGasMeterLocation_${propertyId}');
      diningElectricMeterCondition =
          prefs.getString('diningElectricMeterCondition_${propertyId}');
      diningElectricMeterLocation =
          prefs.getString('diningElectricMeterLocation_${propertyId}');
      diningWaterMeterCondition =
          prefs.getString('diningWaterMeterCondition_${propertyId}');
      diningWaterMeterLocation =
          prefs.getString('diningWaterMeterLocation_${propertyId}');
      diningOilMeterCondition =
          prefs.getString('diningOilMeterCondition_${propertyId}');
      diningOilMeterLocation =
          prefs.getString('diningOilMeterLocation_${propertyId}');
      diningGasMeterImages =
          prefs.getStringList('diningGasMeterImages_${propertyId}') ?? [];
      diningElectricMeterImages =
          prefs.getStringList('diningElectricMeterImages_${propertyId}') ?? [];
      diningWaterMeterImages =
          prefs.getStringList('diningWaterMeterImages_${propertyId}') ?? [];
      diningOilMeterImages =
          prefs.getStringList('diningOilMeterImages_${propertyId}') ?? [];

      kitchenDoorCondition =
          prefs.getString('kitchenDoorCondition_${propertyId}');
      kitchenDoorDescription =
          prefs.getString('kitchenDoorDescription_${propertyId}');
      kitchenDoorFrameCondition =
          prefs.getString('kitchenDoorFrameCondition_${propertyId}');
      kitchenDoorFrameDescription =
          prefs.getString('kitchenDoorFrameDescription_${propertyId}');
      kitchenCeilingCondition =
          prefs.getString('kitchenCeilingCondition_${propertyId}');
      kitchenCeilingDescription =
          prefs.getString('kitchenCeilingDescription_${propertyId}');
      kitchenLightingCondition =
          prefs.getString('kitchenLightingCondition_${propertyId}');
      kitchenLightingDescription =
          prefs.getString('kitchenLightingDescription_${propertyId}');
      kitchenWallsCondition =
          prefs.getString('kitchenWallsCondition_${propertyId}');
      kitchenWallsDescription =
          prefs.getString('kitchenWallsDescription_${propertyId}');
      kitchenSkirtingCondition =
          prefs.getString('kitchenSkirtingCondition_${propertyId}');
      kitchenSkirtingDescription =
          prefs.getString('kitchenSkirtingDescription_${propertyId}');
      kitchenWindowSillCondition =
          prefs.getString('kitchenWindowSillCondition_${propertyId}');
      kitchenWindowSillDescription =
          prefs.getString('kitchenWindowSillDescription_${propertyId}');
      kitchenCurtainsCondition =
          prefs.getString('kitchenCurtainsCondition_${propertyId}');
      kitchenCurtainsDescription =
          prefs.getString('kitchenCurtainsDescription_${propertyId}');
      kitchenBlindsCondition =
          prefs.getString('kitchenBlindsCondition_${propertyId}');
      kitchenBlindsDescription =
          prefs.getString('kitchenBlindsDescription_${propertyId}');
      kitchenLightSwitchesCondition =
          prefs.getString('kitchenLightSwitchesCondition_${propertyId}');
      kitchenLightSwitchesDescription =
          prefs.getString('kitchenLightSwitchesDescription_${propertyId}');
      kitchenSocketCondition =
          prefs.getString('kitchenSocketsCondition_${propertyId}');
      kitchenSocketDescription =
          prefs.getString('kitchenSocketsDescription_${propertyId}');
      kitchenFlooringCondition =
          prefs.getString('kitchenFlooringCondition_${propertyId}');
      kitchenFlooringDescription =
          prefs.getString('kitchenFlooringDescription_${propertyId}');
      kitchenAdditionItemsCondition =
          prefs.getString('kitchenAdditionalItemsCondition_${propertyId}');
      kitchenAdditionItemsDescription =
          prefs.getString('kitchenAdditionalItemsDescription_${propertyId}');
      kitchenDoorImages =
          prefs.getStringList('kitchenDoorImages_${propertyId}') ?? [];
      kitchenDoorFrameImages =
          prefs.getStringList('kitchenDoorFrameImages_${propertyId}') ?? [];
      kitchenCeilingImages =
          prefs.getStringList('kitchenCeilingImages_${propertyId}') ?? [];
      kitchenLightingImages =
          prefs.getStringList('kitchenLightingImages_${propertyId}') ?? [];
      kitchenWallsImages =
          prefs.getStringList('kitchenWallsImages_${propertyId}') ?? [];
      kitchenSkirtingImages =
          prefs.getStringList('kitchenSkirtingImages_${propertyId}') ?? [];
      kitchenWindowSillImages =
          prefs.getStringList('kitchenWindowSillImages_${propertyId}') ?? [];
      ktichenCurtainsImages =
          prefs.getStringList('kitchenCurtainsImages_${propertyId}') ?? [];
      kitchenBlindsImages =
          prefs.getStringList('kitchenBlindsImages_${propertyId}') ?? [];
      kitchenLightSwitchesImages =
          prefs.getStringList('kitchenLightSwitchesImages_${propertyId}') ?? [];
      kitchenSocketImages =
          prefs.getStringList('kitchenSocketsImages_${propertyId}') ?? [];
      kitchenFlooringImages =
          prefs.getStringList('kitchenFlooringImages_${propertyId}') ?? [];
      kitchenAdditionItemsImages =
          prefs.getStringList('kitchenAdditionalItemsImages_${propertyId}') ??
              [];

      lougeDoorCondition = prefs.getString('lougeDoorCondition_${propertyId}');
      loungedoorDescription =
          prefs.getString('loungedoorDescription_${propertyId}');
      loungedoorFrameCondition =
          prefs.getString('loungedoorFrameCondition_${propertyId}');
      loungedoorFrameDescription =
          prefs.getString('loungedoorFrameDescription_${propertyId}');
      loungeceilingCondition =
          prefs.getString('loungeceilingCondition_${propertyId}');
      loungeceilingDescription =
          prefs.getString('loungeceilingDescription_${propertyId}');
      loungelightingCondition =
          prefs.getString('loungelightingCondition_${propertyId}');
      loungelightingDescription =
          prefs.getString('loungelightingDescription_${propertyId}');
      loungewallsCondition =
          prefs.getString('loungewallsCondition_${propertyId}');
      loungewallsDescription =
          prefs.getString('loungewallsDescription_${propertyId}');
      loungeskirtingCondition =
          prefs.getString('loungeskirtingCondition_${propertyId}');
      loungeskirtingDescription =
          prefs.getString('loungeskirtingDescription_${propertyId}');

      loungewindowSillCondition =
          prefs.getString('loungewindowSillCondition_${propertyId}');
      loungewindowSillDescription =
          prefs.getString('loungewindowSillDescription_${propertyId}');
      loungecurtainsCondition =
          prefs.getString('loungecurtainsCondition_${propertyId}');
      loungecurtainsDescription =
          prefs.getString('loungecurtainsDescription_${propertyId}');
      loungeblindsCondition =
          prefs.getString('loungeblindsCondition_${propertyId}');
      loungeblindsDescription =
          prefs.getString('loungeblindsDescription_${propertyId}');
      loungelightSwitchesCondition =
          prefs.getString('loungelightSwitchesCondition_${propertyId}');
      loungelightSwitchesDescription =
          prefs.getString('loungelightSwitchesDescription_${propertyId}');
      loungesocketsCondition =
          prefs.getString('loungesocketsCondition_${propertyId}');
      loungesocketsDescription =
          prefs.getString('loungesocketsDescription_${propertyId}');
      loungeflooringCondition =
          prefs.getString('loungeflooringCondition_${propertyId}');
      loungeflooringDescription =
          prefs.getString('loungeflooringDescription_${propertyId}');
      loungeadditionalItemsCondition =
          prefs.getString('loungeadditionalItemsCondition_${propertyId}');
      loungeadditionalItemsDescription =
          prefs.getString('loungeadditionalItemsDescription_${propertyId}');

      utilityDoorCondition =
          prefs.getString('utilityDoorCondition_${propertyId}');
      utilityDoorDescription =
          prefs.getString('utilityDoorDescription_${propertyId}');
      utilityDoorFrameCondition =
          prefs.getString('utilityDoorFrameCondition_${propertyId}');
      utilityDoorFrameDescription =
          prefs.getString('utilityDoorFrameDescription_${propertyId}');
      utilityCeilingCondition =
          prefs.getString('utilityCeilingCondition_${propertyId}');
      utilityCeilingDescription =
          prefs.getString('utilityCeilingDescription_${propertyId}');
      utilityLightingCondition =
          prefs.getString('utilityLightingCondition_${propertyId}');
      utilitylightingDescription =
          prefs.getString('utilitylightingDescription_${propertyId}');
      utilitywallsCondition =
          prefs.getString('utilitywallsCondition_${propertyId}');
      utilitywallsDescription =
          prefs.getString('utilitywallsDescription_${propertyId}');
      utilityskirtingCondition =
          prefs.getString('utilityskirtingCondition_${propertyId}');
      utilityskirtingDescription =
          prefs.getString('utilitySkirtingDescription_${propertyId}');
      utilitywindowSillCondition =
          prefs.getString('utilitywindowSillCondition_${propertyId}');
      utilitywindowSillDescription =
          prefs.getString('utilitywindowSillDescription_${propertyId}');
      utilitycurtainsCondition =
          prefs.getString('utilitycurtainsCondition_${propertyId}');
      utilitycurtainsDescription =
          prefs.getString('utilitycurtainsDescription_${propertyId}');
      utilityblindsCondition =
          prefs.getString('utilityblindsCondition_${propertyId}');
      utilityblindsDescription =
          prefs.getString('utilityblindsDescription_${propertyId}');
      utilitylightSwitchesCondition =
          prefs.getString('utilitylightSwitchesCondition_${propertyId}');
      utilitylightSwitchesDescription =
          prefs.getString('utilitylightSwitchesDescription_${propertyId}');
      utilitysocketsCondition =
          prefs.getString('utilitysocketsCondition_${propertyId}');
      utilitysocketsDescription =
          prefs.getString('utilitysocketsDescription_${propertyId}');
      utilityflooringCondition =
          prefs.getString('utilityflooringCondition_${propertyId}');
      utilityflooringDescription =
          prefs.getString('utilityflooringDescription_${propertyId}');
      utilityadditionalItemsCondition =
          prefs.getString('utilityadditionalItemsCondition_${propertyId}');
      utilityadditionalItemsDescription =
          prefs.getString('utilityadditionalItemsDescription_${propertyId}');

      bedRoomDoorLocation =
          prefs.getString('bedRoomDoorLocation_${propertyId}');
      bedRoomDoorCondition =
          prefs.getString('bedRoomDoorCondition_${propertyId}');
      bedRoomDoorFrameLocation =
          prefs.getString('bedRoomDoorFrameLocation_${propertyId}');
      bedRoomDoorFrameCondition =
          prefs.getString('bedRoomDoorFrameCondition_${propertyId}');
      bedRoomCeilingLocation =
          prefs.getString('bedRoomCeilingLocation_${propertyId}');
      bedRoomCeilingCondition =
          prefs.getString('bedRoomCeilingCondition_${propertyId}');
      bedRoomLightingLocation =
          prefs.getString('bedRoomLightingLocation_${propertyId}');
      bedRoomLightingCondition =
          prefs.getString('bedRoomLightingCondition_${propertyId}');
      bedRoomWallsLocation =
          prefs.getString('bedRoomWallsLocation_${propertyId}');
      bedRoomWallsCondition =
          prefs.getString('bedRoomWallsCondition_${propertyId}');
      bedRoomSkirtingLocation =
          prefs.getString('bedRoomSkirtingLocation_${propertyId}');
      bedRoomsSkirtingCondition =
          prefs.getString('bedRoomsSkirtingCondition_${propertyId}');
      bedRoomWindowSillLocation =
          prefs.getString('bedRoomWindowSillLocation_${propertyId}');
      bedRoomWindowSillCondition =
          prefs.getString('bedRoomWindowSillCondition_${propertyId}');
      bedRoomCurtainsLocation =
          prefs.getString('bedRoomCurtainsLocation_${propertyId}');
      bedRoomCurtainsCondition =
          prefs.getString('bedRoomCurtainsCondition_${propertyId}');
      bedRoomBlindsLocation =
          prefs.getString('bedRoomBlindsLocation_${propertyId}');
      bedRoomBlindsCondition =
          prefs.getString('bedRoomBlindsCondition_${propertyId}');
      bedRoomLightSwitchesLocation =
          prefs.getString('bedRoomLightSwitchesLocation_${propertyId}');
      bedRoomLightSwitchesCondition =
          prefs.getString('bedRoomLightSwitchesCondition_${propertyId}');
      bedRoomSocketsLocation =
          prefs.getString('bedRoomSocketsLocation_${propertyId}');
      bedRoomSocketsCondition =
          prefs.getString('bedRoomSocketsCondition_${propertyId}');
      bedRoomFlooringLocation =
          prefs.getString('bedRoomFlooringLocation_${propertyId}');
      bedRoomFlooringCondition =
          prefs.getString('bedRoomFlooringCondition_${propertyId}');
      bedRoomAdditionalItemsLocation =
          prefs.getString('bedRoomAdditionalItemsLocation_${propertyId}');
      bedRoomAdditionalItemsCondition =
          prefs.getString('bedRoomAdditionalItemsCondition_${propertyId}');
      bedRoomDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      bedRoomDoorFrameImages =
          prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      bedRoomCeilingImages =
          prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      bedRoomlLightingImages =
          prefs.getStringList('lightingImages_${propertyId}') ?? [];
      bedRoomwWallsImages =
          prefs.getStringList('wallsImages_${propertyId}') ?? [];
      bedRoomSkirtingImages =
          prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      bedRoomWindowSillImages =
          prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      bedRoomCurtainsImages =
          prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      bedRoomBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      bedRoomLightSwitchesImages =
          prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      bedRoomSocketsImages =
          prefs.getStringList('socketsImages_${propertyId}') ?? [];
      bedRoomFlooringImages =
          prefs.getStringList('flooringImages_${propertyId}') ?? [];
      bedRoomAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      ensuitdoorCondition =
          prefs.getString('ensuitdoorCondition_${propertyId}');
      ensuitdoorLocation = prefs.getString('ensuitdoorLocation_${propertyId}');
      ensuitdoorFrameCondition =
          prefs.getString('ensuitdoorFrameCondition_${propertyId}');
      ensuitedoorFrameLocation =
          prefs.getString('ensuitedoorFrameLocation_${propertyId}');
      ensuiteceilingCondition =
          prefs.getString('ensuiteceilingCondition_${propertyId}');
      ensuitceilingLocation =
          prefs.getString('ensuitceilingLocation_${propertyId}');
      ensuitlightingCondition =
          prefs.getString('ensuitlightingCondition_${propertyId}');
      ensuitelightingLocation =
          prefs.getString('ensuitelightingLocation_${propertyId}');
      ensuitewallsCondition =
          prefs.getString('ensuitewallsCondition_${propertyId}');
      ensuitewallsLocation =
          prefs.getString('ensuitewallsLocation_${propertyId}');
      ensuiteskirtingCondition =
          prefs.getString('ensuiteskirtingCondition_${propertyId}');
      ensuiteskirtingLocation =
          prefs.getString('ensuiteskirtingLocation_${propertyId}');
      ensuitewindowSillCondition =
          prefs.getString('ensuitewindowSillCondition_${propertyId}');
      ensuitewindowSillLocation =
          prefs.getString('ensuitewindowSillLocation_${propertyId}');
      ensuitecurtainsCondition =
          prefs.getString('ensuitecurtainsCondition_${propertyId}');
      ensuitecurtainsLocation =
          prefs.getString('ensuitecurtainsLocation_${propertyId}');
      ensuiteblindsCondition =
          prefs.getString('ensuiteblindsCondition_${propertyId}');
      ensuiteblindsLocation =
          prefs.getString('ensuiteblindsLocation_${propertyId}');
      ensuitelightSwitchesCondition =
          prefs.getString('ensuitelightSwitchesCondition_${propertyId}');
      ensuitelightSwitchesLocation =
          prefs.getString('ensuitelightSwitchesLocation_${propertyId}');
      ensuiteSocketCondition =
          prefs.getString('ensuiteSocketCondition_${propertyId}');
      ensuiteSocketLocation =
          prefs.getString('ensuiteSocketLocation_${propertyId}');
      ensuiteFlooringCondition =
          prefs.getString('ensuiteFlooringCondition_${propertyId}');
      ensuiteFlooringLocation =
          prefs.getString('ensuiteFlooringLocation_${propertyId}');
      ensuiteAdditionItemsCondition =
          prefs.getString('ensuiteAdditionItemsCondition_${propertyId}');
      ensuiteAdditionItemsLocation =
          prefs.getString('ensuiteAdditionItemsLocation_${propertyId}');
      ensuiteHeatingCondition =
          prefs.getString('ensuiteHeatingCondition_${propertyId}');
      ensuiteHeatingLocation =
          prefs.getString('ensuiteHeatingLocation_${propertyId}');
      ensuiteShowerCondition =
          prefs.getString('ensuiteShowerCondition_${propertyId}');
      ensuiteShowerLocation =
          prefs.getString('ensuiteShowerLocation_${propertyId}');
      ensuiteToiletCondition =
          prefs.getString('ensuiteToiletCondition_${propertyId}');
      ensuiteToiletLocation =
          prefs.getString('ensuiteToiletLocation_${propertyId}');

      ensuitedoorImages = prefs.getStringList('ensuitedoorImages') ?? [];
      ensuitedoorFrameImages =
          prefs.getStringList('ensuitedoorFrameImages') ?? [];
      ensuiteceilingImages = prefs.getStringList('ensuiteceilingImages') ?? [];
      ensuitelightingImages =
          prefs.getStringList('ensuitelightingImages') ?? [];
      ensuitewallsImages = prefs.getStringList('ensuitewallsImages') ?? [];
      ensuiteskirtingImages =
          prefs.getStringList('ensuiteskirtingImages') ?? [];
      ensuitewindowSillImages =
          prefs.getStringList('ensuitewindowSillImages') ?? [];
      ensuitecurtainsImages =
          prefs.getStringList('ensuitecurtainsImages') ?? [];
      ensuiteblindsImages = prefs.getStringList('ensuiteblindsImages') ?? [];
      ensuitelightSwitchesImages =
          prefs.getStringList('ensuitelightSwitchesImages') ?? [];
      ensuiteSocketImages = prefs.getStringList('ensuitesocketsImages') ?? [];
      ensuiteflooringImages =
          prefs.getStringList('ensuiteflooringImages') ?? [];
      ensuiteadditionalItemsImages =
          prefs.getStringList('ensuiteadditionalItemsImages') ?? [];
    });
  }

  Future<List<String>> fetchDataFromFirestore(
      String propertyId, String collectionName, String documentId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .collection(collectionName)
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('images')) {
          return List<String>.from(data['images']);
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return [];
  }

  late PropertyDto property = PropertyDto(
    id: widget.propertyId,
    addressDto: AddressDto(
      addressLineOne: properties[0]['addressLineOne'] ?? 'No address',
      addressLineTwo: properties[0]['addressLineTwo'] ?? 'No address',
      city: properties[0]['city'] ?? 'No address',
      state: properties[0]['state'] ?? 'No address',
      country: properties[0]['country'] ?? 'No address',
      postalCode: properties[0]['postalCode'] ?? 'No address',
    ),
    userDto: UserDto(
      firebaseId: 'user001',
      firstName: 'Abishan',
      lastName: 'Ananthan',
      userName: userDetails[0]['userName'] ?? 'Taurgo',
      email: userDetails[0]['email'] ?? 'info@taurgo.co.uk',
      location: '+Vavuniya',
    ),
    inspectionDto: InspectionDto(
        inspectionId: 'insp001',
        inspectorName: properties[0]['client'] ?? 'No address',
        inspectionType: properties[0]['inspectionType'] ?? 'No address',
        date: properties[0]['date'] ?? 'No address',
        time: properties[0]['time'] ?? 'No address',
        keyLocation: properties[0]['keyLocation'] ?? 'No address',
        keyReference: properties[0]['keyLocation'] ?? 'No address',
        internalNotes: properties[0]['keyLocation'] ?? 'No address',
        inspectionReports: [
          //1 SOC
          InspectionReportDto(
            reportId: 'report001',
            name: 'Schedule of Condition',
            subTypes: [
              //1.1 Overview - Odours
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Overview - Odours',
                images: overviewImages,
                comments: overview ?? 'N/A',
                feedback: overview ?? 'N/A',
                conditionImages: [],
              ),

              //1.2 Accessory Cleanliness
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Accessory Cleanliness',
                images: accessoryCleanlinessImages,
                comments: accessoryCleanliness ?? '',
                feedback: accessoryCleanliness ?? '',
                conditionImages: [],
              ),

              //1.3 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: windowSillImages,
                comments: windowSill ?? 'N/A',
                feedback: windowSill ?? 'N/A',
                conditionImages: [],
              ),

              //1.4 Carpets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Carpets',
                images: carpetsImages,
                comments: carpets ?? 'N/A',
                feedback: carpets ?? 'N/A',
                conditionImages: [],
              ),

              //1.5 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: ceilingsImages,
                comments: ceilings ?? 'N/A',
                feedback: ceilings ?? 'N/A',
                conditionImages: [],
              ),

              //1.6 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: curtainsImages,
                comments: curtains ?? 'N/A',
                feedback: curtains ?? 'N/A',
                conditionImages: [],
              ),

              //1.7 Hard Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Hard Flooring',
                images: hardFlooringImages,
                comments: hardFlooring ?? 'N/A',
                feedback: hardFlooring ?? 'N/A',
                conditionImages: [],
              ),

              //1.8 Kitchen Area
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Kitchen Area',
                images: kitchenAreaImages,
                comments: kitchenArea ?? 'N/A',
                feedback: kitchenArea ?? 'N/A',
                conditionImages: [],
              ),

              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Kitchen',
                images: kitchenImages,
                comments: kitchen ?? 'N/A',
                feedback: kitchen ?? 'N/A',
                conditionImages: [],
              ),
              //1.9 Oven
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Oven',
                images: ovenImages,
                comments: oven ?? 'N/A',
                feedback: oven ?? 'N/A',
                conditionImages: [],
              ),

              //1.10 Mattress
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Mattress',
                images: mattressImages,
                comments: mattress ?? 'N/A',
                feedback: mattress ?? 'N/A',
                conditionImages: [],
              ),

              //1.11 Uholstrey
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Uholstrey',
                images: upholstreyImages,
                comments: upholstrey ?? 'N/A',
                feedback: upholstrey ?? 'N/A',
                conditionImages: [],
              ),

              //1.12 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: wallImages,
                comments: wall ?? 'N/A',
                feedback: wall ?? 'N/A',
                conditionImages: [],
              ),

              //1.13 Window
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window',
                images: windowImages,
                comments: window ?? 'N/A',
                feedback: window ?? 'N/A',
                conditionImages: [],
              ),

              //1.14 Woodwork
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Woodwork',
                images: woodworkImages,
                comments: woodwork ?? 'N/A',
                feedback: woodwork ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),
          //Keys Handed Over
          InspectionReportDto(
            reportId: 'report001',
            name: 'Keys Handed Over',
            subTypes: [
              //5.1 Yale
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Yale',
                images: keysHandOverYaleImages,
                comments: yale ?? 'N/A',
                feedback: yale ?? 'N/A',
                conditionImages: [],
              ),

              //5.2 Mortice
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Mortice',
                images: keysHandOverMorticeImages,
                comments: mortice ?? 'N/A',
                feedback: mortice ?? 'N/A',
                conditionImages: [],
              ),

              //5.3 Other

              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Other',
                images: keysHandOverOtherImages,
                comments: other ?? 'N/A',
                feedback: other ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report002',
            name: 'EV Charger',
            subTypes: [
              //2.1 EV Charger
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'EV Charger',
                images: evChargerImages,
                comments: evChargerDescription ?? 'N/A',
                feedback: evChargerDescription ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report002',
            name: 'Meter Reading',
            subTypes: [
              //1.1 Overview - Odours
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Gas Meter',
                images: gasMeterImages,
                comments: GasMeterReading ?? 'N/A',
                feedback: GasMeterReading ?? 'N/A',
                conditionImages: [],
              ),

              //1.2 Accessory Cleanliness
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Electric Meter',
                images: electricMeterImages,
                comments: electricMeterReading ?? 'N/A',
                feedback: electricMeterReading ?? 'N/A',
                conditionImages: [],
              ),

              //1.3 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Water Meter',
                images: waterMeterImages,
                comments: waterMeterReading ?? 'N/A',
                feedback: waterMeterReading ?? 'N/A',
                conditionImages: [],
              ),

              //1.4 Carpets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Oil Meter',
                images: oilMeterImages,
                comments: oilMeterReading ?? 'N/A',
                feedback: oilMeterReading ?? 'N/A',
                conditionImages: [],
              ),

              //1.5 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Other Meter',
                images: otherMeterImages,
                comments: otherMeterReading ?? 'N/A',
                feedback: otherMeterReading ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Keys',
            subTypes: [
              //4.1 Yale
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Yale',
                images: yaleImages,
                comments: yaleLocation ?? 'N/A',
                feedback: yaleLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.2 Mortice
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Mortice',
                images: morticeImages,
                comments: morticeLocation ?? 'N/A',
                feedback: morticeLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.3 Window Lock
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Lock',
                images: windowLockImages,
                comments: windowLockLocation ?? 'N/A',
                feedback: windowLockLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.4 Gas Meter
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Gas Meter',
                images: keygasMeterImages,
                comments: gasMeterLocation ?? 'N/A',
                feedback: gasMeterLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.5 Car Pass
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Car Pass',
                images: carPassImages,
                comments: carPassLocation ?? 'N/A',
                feedback: carPassLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.6 Remote
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Remote',
                images: remoteImages,
                comments: remoteLocation ?? 'N/A',
                feedback: remoteLocation ?? 'N/A',
                conditionImages: [],
              ),

              //4.7 Other
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Other',
                images: otherImages,
                comments: otherLocation ?? 'N/A',
                feedback: otherLocation ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Health and Safety',
            subTypes: [
              //6.1 Heat Sensor
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Heat Sensor',
                images: heatSensorImages,
                comments: heatSensorCondition ?? 'N/A',
                feedback: heatSensorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //6.2 Smoke Alarm
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Smoke Alarm',
                images: smokeAlarmImages,
                comments: smokeAlarmCondition ?? 'N/A',
                feedback: smokeAlarmCondition ?? 'N/A',
                conditionImages: [],
              ),

              //6.3 Other
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Other',
                images: carbonMonxideImages,
                comments: carbonMonoxideCondition ?? 'N/A',
                feedback: carbonMonoxideCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Bathroom',
            subTypes: [
              //19.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: bathroomdoorImages,
                comments: bathroomdoorCondition ?? 'N/A',
                feedback: bathroomdoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: bathroomdoorFrameImages,
                comments: bathroomdoorFrameCondition ?? 'N/A',
                feedback: bathroomdoorFrameCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: bathroomceilingImages,
                comments: bathroomceilingCondition ?? 'N/A',
                feedback: bathroomceilingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: bathroomlightingImages,
                comments: bathroomlightingCondition ?? 'N/A',
                feedback: bathroomlightingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: bathroomwallsImages,
                comments: bathroomwallsCondition ?? 'N/A',
                feedback: bathroomwallsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: bathroomskirtingImages,
                comments: bathroomskirtingCondition ?? 'N/A',
                feedback: bathroomskirtingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: bathroomwindowSillImages,
                comments: bathroomwindowSillCondition ?? 'N/A',
                feedback: bathroomwindowSillCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: bathroomcurtainsImages,
                comments: bathroomcurtainsCondition ?? 'N/A',
                feedback: bathroomcurtainsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: bathroomblindsImages,
                comments: bathroomblindsCondition ?? 'N/A',
                feedback: bathroomblindsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: bathroomswitchBoardImages,
                comments: bathroomswitchBoardCondition ?? 'N/A',
                feedback: bathroomswitchBoardCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: bathroomsocketImages,
                comments: bathroomsocketCondition ?? 'N/A',
                feedback: bathroomsocketCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: bathroomflooringImages,
                comments: bathroomflooringCondition ?? 'N/A',
                feedback: bathroomflooringCondition ?? 'N/A',
                conditionImages: [],
              ),

              //19.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: bathroomadditionItemsImages,
                comments: bathroomadditionItemsCondition ?? 'N/A',
                feedback: bathroomadditionItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),
          // 7 - Front Garden
          InspectionReportDto(
            reportId: 'report001',
            name: 'Front Garden',
            subTypes: [
              //7.1 Heat Sensor
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Garden',
                images: gardenImages,
                comments: gardenDescription ?? 'N/A',
                feedback: gardenDescription ?? 'N/A',
                conditionImages: [],
              ),
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Drive Way',
                images: driveWayImages,
                comments: driveWayCondition ?? 'N/A',
                feedback: driveWayCondition ?? 'N/A',
                conditionImages: [],
              ),

              //7.2 Outside Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Outside Lighting',
                images: outsideLightingImages,
                comments: outsideLightingDescription ?? 'N/A',
                feedback: outsideLightingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //7.3 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: additionalItemsImages,
                comments: additionalItemsCondition ?? 'N/A',
                feedback: additionalItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Garage',
            subTypes: [
              //8.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: garagedoorImages,
                comments: garageDoorCondition ?? 'N/A',
                feedback: garageDoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: garagedoorFrameImages,
                comments: garageDoorFrameCondition ?? 'N/A',
                feedback: garageDoorFrameCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: garageceilingImages,
                comments: garageceilingCondition ?? 'N/A',
                feedback: garageceilingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: garagelightingImages,
                comments: garagelightingCondition ?? 'N/A',
                feedback: garagelightingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: garagewallsImages,
                comments: garagewallsCondition ?? 'N/A',
                feedback: garagewallsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: garageskirtingImages,
                comments: garageskirtingCondition ?? 'N/A',
                feedback: garageskirtingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: garagewindowSillImages,
                comments: garagewindowSillCondition ?? 'N/A',
                feedback: garagewindowSillCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: garagecurtainsImages,
                comments: garagecurtainsCondition ?? 'N/A',
                feedback: garagecurtainsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: garageblindsImages,
                comments: garageblindsCondition ?? 'N/A',
                feedback: garageblindsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: garagelightSwitchesImages,
                comments: garagelightSwitchesCondition ?? 'N/A',
                feedback: garagelightSwitchesCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: garagesocketsImages,
                comments: garagesocketsCondition ?? 'N/A',
                feedback: garagesocketsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: garageflooringImages,
                comments: garageflooringCondition ?? 'N/A',
                feedback: garageflooringCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: garageadditionalItemsImages,
                comments: garageadditionalItemsCondition ?? 'N/A',
                feedback: garageadditionalItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Exterior Front',
            subTypes: [
              //9.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: exteriorFrontDoorImages,
                comments: exteriorFrontDoorCondition ?? 'N/A',
                feedback: exteriorFrontDoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //9.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: exteriorFrontDoorFrameImages,
                comments: exteriorFrontDoorFrameCondition ?? 'N/A',
                feedback: exteriorFrontDoorFrameCondition ?? 'N/A',
                conditionImages: [],
              ),

              //9.3 Porch
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Porch',
                images: exteriorFrontPorchImages,
                comments: exteriorFrontPorchCondition ?? 'N/A',
                feedback: exteriorFrontPorchCondition ?? 'N/A',
                conditionImages: [],
              ),

              //9.4 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: exteriorFrontAdditionalItemsImages,
                comments: exteriorFrontAdditionalItemsCondition ?? 'N/A',
                feedback: exteriorFrontAdditionalItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Entrance/Hallway',
            subTypes: [
              //8.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: entranceDoorImages,
                comments: entranceDoorCondition ?? 'N/A',
                feedback: entranceDoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: entranceDoorFrameImages,
                comments: entranceDoorFrameCondition ?? 'N/A',
                feedback: entranceDoorFrameCondition ?? 'N/A',
                conditionImages: [],
              ),

              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Bell',
                images: entranceDoorBellImages,
                comments: entranceDoorBellCondition ?? 'N/A',
                feedback: entranceDoorBellCondition ?? 'N/A',
                conditionImages: [],
              ),
              //8.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: entranceCeilingImages,
                comments: entranceCeilingCondition ?? 'N/A',
                feedback: entranceCeilingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: entranceLightingImages,
                comments: entranceLightSwitchesCondition ?? 'N/A',
                feedback: entranceLightSwitchesCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: entranceWallsImages,
                comments: entranceWallsCondition ?? 'N/A',
                feedback: entranceWallsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: entranceSkirtingImages,
                comments: entranceSkirtingCondition ?? 'N/A',
                feedback: entranceSkirtingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: entranceWindowSillImages,
                comments: entranceWindowSillCondition ?? 'N/A',
                feedback: entranceWindowSillCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: entranceCurtainsImages,
                comments: entranceCurtainsCondition ?? 'N/A',
                feedback: entranceCurtainsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: entranceBlindsImages,
                comments: entranceBlindsCondition ?? 'N/A',
                feedback: entranceBlindsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: entranceLightSwitchesImages,
                comments: entranceLightSwitchesCondition ?? 'N/A',
                feedback: entranceLightSwitchesCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: entranceSocketsImages,
                comments: entranceSocketsCondition ?? 'N/A',
                feedback: entranceSocketsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: entranceFlooringImages,
                comments: entranceFlooringCondition ?? 'N/A',
                feedback: entranceFlooringCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: entranceAdditionalItemsImages,
                comments: entranceAdditionalItemsCondition ?? 'N/A',
                feedback: entranceAdditionalItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Toilet',
            subTypes: [
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: toiletDoorImages,
                comments: toiletDoorCondition ?? 'N/A',
                feedback: toiletDoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.1 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: toiletDoorFrameImages,
                comments: toiletDoorCondition ?? 'N/A',
                feedback: toiletDoorCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.2 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: toiletCeilingImages,
                comments: toiletCeilingCondition ?? 'N/A',
                feedback: toiletCeilingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.3 Extractor Fan
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Extractor Fan',
                images: toiletExtractorFanImages,
                comments: toiletExtractorFanCondition ?? 'N/A',
                feedback: toiletExtractorFanCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: toiletlLightingImages,
                comments: toiletLightingCondition ?? 'N/A',
                feedback: toiletLightingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: toiletWallsImages,
                comments: toiletWallsCondition ?? 'N/A',
                feedback: toiletWallsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: toiletSkirtingImages,
                comments: toiletSkirtingCondition ?? 'N/A',
                feedback: toiletSkirtingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: toiletWindowSillImages,
                comments: toiletWindowSillCondition ?? 'N/A',
                feedback: toiletWindowSillCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: toiletCurtainsImages,
                comments: toiletCurtainsCondition ?? 'N/A',
                feedback: toiletCurtainsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: toiletBlindsImages,
                comments: toiletBlindsCondition ?? 'N/A',
                feedback: toiletBlindsCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.10 Toilet
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Toilet',
                images: toiletToiletImages,
                comments: toiletToiletCondition ?? 'N/A',
                feedback: toiletToiletCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.11 Basin
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Basin',
                images: toiletBasinImages,
                comments: toiletBasinCondition ?? 'N/A',
                feedback: toiletBasinCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.12 Shower Cubicle
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Shower Cubicle',
                images: toiletShowerCubicleImages,
                comments: toiletShowerCubicleCondition ?? 'N/A',
                feedback: toiletShowerCubicleCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.13 Bath
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Bath',
                images: toiletBathImages,
                comments: toiletBathCondition ?? 'N/A',
                feedback: toiletBathCondition ?? 'N/A',
                conditionImages: [],
              ),

              //11.14 Switch Board
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Switch Board',
                images: toiletSwitchBoardImages,
                comments: toiletSwitchBoardCondition ?? 'N/A',
                feedback: toiletSwitchBoardCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.15 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: toiletSocketImages,
                comments: toiletSocketCondition ?? 'N/A',
                feedback: toiletSocketCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.16 Heating
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Heating',
                images: toiletHeatingImages,
                comments: toiletHeatingCondition ?? 'N/A',
                feedback: toiletHeatingCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.17 Accessories
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Accessories',
                images: toiletAccessoriesImages,
                comments: toiletAccessoriesCondition ?? 'N/A',
                feedback: toiletAccessoriesCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.18 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: toiletFlooringImages,
                comments: toiletFlooringCondition ?? 'N/A',
                feedback: toiletFlooringCondition ?? 'N/A',
                conditionImages: [],
              ),

              //8.19 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: toiletAdditionalItemsImages,
                comments: toiletAdditionalItemsCondition ?? 'N/A',
                feedback: toiletAdditionalItemsCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),
          InspectionReportDto(
            reportId: 'report001',
            name: 'Rear Garden',
            subTypes: [
              //20.1 Garden Description
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Garden Description',
                images: reargardenDescriptionImages,
                comments: reargardenDescription ?? 'N/A',
                feedback: reargardenDescription ?? 'N/A',
                conditionImages: [],
              ),

              //20.2 Outside Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Outside Lightinge',
                images: rearGardenOutsideLightingImages,
                comments: rearGardenOutsideLighting ?? 'N/A',
                feedback: rearGardenOutsideLighting ?? 'N/A',
                conditionImages: [],
              ),

              //20.3 Summer House
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Summer House',
                images: rearGardensummerHouseImages,
                comments: rearGardensummerHouse ?? 'N/A',
                feedback: rearGardensummerHouse ?? 'N/A',
                conditionImages: [],
              ),

              //20.4 Shed
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Shed',
                images: rearGardenshedImages,
                comments: rearGardenshed ?? 'N/A',
                feedback: rearGardenshed ?? 'N/A',
                conditionImages: [],
              ),

              //20.5 Additional Information
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Information',
                images: rearGardenadditionalInformationImages,
                comments: rearGardenadditionalInformation ?? 'N/A',
                feedback: rearGardenadditionalInformation ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Stairs',
            subTypes: [
              //15.1 Door
              // SubTypeDto(
              //   subTypeId: 'subType001',
              //   subTypeName: 'Door',
              //   images: [overviewImages.toString()],
              //   comments: stairsdoorCondition ?? 'N/A',
              //   feedback: stairsdoorCondition ?? 'N/A',
              //   conditionImages: [],
              // ),

              // //15.2 Door Frame
              // SubTypeDto(
              //   subTypeId: 'subType001',
              //   subTypeName: 'Door Frame',
              //   images: [overviewImages.toString()],
              //   comments: stairsdoorFrameCondition ?? 'N/A',
              //   feedback: stairsdoorFrameCondition ?? 'N/A',
              //   conditionImages: [],
              // ),

              //15.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: stairsceilingImages,
                comments: stairsceilingCondition ?? 'N/A',
                feedback: stairsceilingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: stairslightingImages,
                comments: stairslightingCondition ?? 'N/A',
                feedback: stairslightingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: stairswallsImages,
                comments: stairswallsCondition ?? 'N/A',
                feedback: stairswallsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: stairsskirtingImages,
                comments: stairsskirtingCondition ?? 'N/A',
                feedback: stairsskirtingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: stairswindowSillImages,
                comments: stairswindowSillCondition ?? 'N/A',
                feedback: stairswindowSillDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: stairscurtainsImages,
                comments: stairscurtainsCondition ?? 'N/A',
                feedback: stairscurtainsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: stairsblindsImages,
                comments: stairsblindsCondition ?? 'N/A',
                feedback: stairsblindsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: stairslightSwitchesImages,
                comments: stairslightSwitchesCondition ?? 'N/A',
                feedback: stairslightSwitchesDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: stairssocketsImages,
                comments: stairssocketsCondition ?? 'N/A',
                feedback: stairssocketsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: stairsflooringImages,
                comments: stairsflooringCondition ?? 'N/A',
                feedback: stairsflooringDescription ?? 'N/A',
                conditionImages: [],
              ),

              //15.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: stairsadditionalItemsImages,
                comments: stairsadditionalItemsCondition ?? 'N/A',
                feedback: stairsadditionalItemsDescription ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Utility Area',
            subTypes: [
              //14.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: utilitydoorImages,
                comments: utilityDoorCondition ?? 'N/A',
                feedback: utilityDoorDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: utilitydoorFrameImages,
                comments: utilityDoorFrameCondition ?? 'N/A',
                feedback: utilityDoorFrameDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: utilityceilingImages,
                comments: utilityCeilingCondition ?? 'N/A',
                feedback: utilityCeilingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: utilitylightingImages,
                comments: utilityLightingCondition ?? 'N/A',
                feedback: utilitylightingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: utilitywallsImages,
                comments: utilitywallsCondition ?? 'N/A',
                feedback: utilitywallsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: utilityskirtingImages,
                comments: utilityskirtingCondition ?? 'N/A',
                feedback: utilityskirtingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: utilitywindowSillImages,
                comments: utilitywindowSillCondition ?? 'N/A',
                feedback: utilitywindowSillDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: utilitycurtainsImages,
                comments: utilitycurtainsCondition ?? 'N/A',
                feedback: utilitycurtainsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: utilityblindsImages,
                comments: utilityblindsCondition ?? 'N/A',
                feedback: utilityblindsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: utilitylightSwitchesImages,
                comments: utilitylightSwitchesCondition ?? 'N/A',
                feedback: utilitylightSwitchesDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: utilitysocketsImages,
                comments: utilitysocketsCondition ?? 'N/A',
                feedback: utilitysocketsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: utilityflooringImages,
                comments: utilityflooringCondition ?? 'N/A',
                feedback: utilityflooringDescription ?? 'N/A',
                conditionImages: [],
              ),

              //14.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: utilityadditionalItemsImages,
                comments: utilityadditionalItemsCondition ?? 'N/A',
                feedback: utilityadditionalItemsDescription ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report002',
            name: 'Bedroom',
            subTypes: [
              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomDoor',
                images: bedRoomDoorImages,
                comments: bedRoomDoorCondition ?? 'N/A',
                feedback: bedRoomDoorLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomDoorFrame',
                images: bedRoomDoorFrameImages,
                comments: bedRoomDoorFrameCondition ?? 'N/A',
                feedback: bedRoomDoorFrameLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomCeiling',
                images: bedRoomCeilingImages,
                comments: bedRoomCeilingCondition ?? 'N/A',
                feedback: bedRoomCeilingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomLighting',
                images: bedRoomlLightingImages,
                comments: bedRoomLightingCondition ?? 'N/A',
                feedback: bedRoomLightingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomWalls',
                images: bedRoomwWallsImages,
                comments: bedRoomWallsCondition ?? 'N/A',
                feedback: bedRoomWallsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomSkirting',
                images: bedRoomSkirtingImages,
                comments: bedRoomsSkirtingCondition ?? 'N/A',
                feedback: bedRoomSkirtingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomWindowSill',
                images: bedRoomWindowSillImages,
                comments: bedRoomWindowSillCondition ?? 'N/A',
                feedback: bedRoomWindowSillLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom

              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomCurtains',
                images: bedRoomCurtainsImages,
                comments: bedRoomCurtainsCondition ?? 'N/A',
                feedback: bedRoomCurtainsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomBlinds',
                images: bedRoomBlindsImages,
                comments: bedRoomBlindsCondition ?? 'N/A',
                feedback: bedRoomBlindsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomLightSwitches',
                images: bedRoomLightSwitchesImages,
                comments: bedRoomLightSwitchesCondition ?? 'N/A',
                feedback: bedRoomLightSwitchesLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomSockets',
                images: bedRoomSocketsImages,
                comments: bedRoomSocketsCondition ?? 'N/A',
                feedback: bedRoomSocketsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomFlooring',
                images: bedRoomFlooringImages,
                comments: bedRoomFlooringCondition ?? 'N/A',
                feedback: bedRoomFlooringLocation ?? 'N/A',
                conditionImages: [],
              ),

              //Bedroom

              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'bedRoomAdditionalItems',
                images: bedRoomAdditionalItemsImages,
                comments: bedRoomAdditionalItemsCondition ?? 'N/A',
                feedback: bedRoomAdditionalItemsLocation ?? 'N/A',
                conditionImages: [],
              ),
              // Add more InspectionReportDto items as needed
            ],
            additionalComments: '',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Lounge',
            subTypes: [
              //12.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: loungedoorImages,
                comments: lougeDoorCondition ?? 'N/A',
                feedback: loungedoorDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: loungedoorFrameImages,
                comments: loungedoorFrameCondition ?? 'N/A',
                feedback: loungedoorFrameDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: loungeceilingImages,
                comments: loungeceilingCondition ?? 'N/A',
                feedback: loungeceilingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: loungelightingImages,
                comments: loungelightingCondition ?? 'N/A',
                feedback: loungelightingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: loungewallsImages,
                comments: loungewallsCondition ?? 'N/A',
                feedback: loungewallsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: loungeskirtingImages,
                comments: loungeskirtingCondition ?? 'N/A',
                feedback: loungeskirtingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: loungewindowSillImages,
                comments: loungewindowSillCondition ?? 'N/A',
                feedback: loungewindowSillDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: loungecurtainsImages,
                comments: loungecurtainsCondition ?? 'N/A',
                feedback: loungecurtainsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: loungeblindsImages,
                comments: loungeblindsCondition ?? 'N/A',
                feedback: loungeblindsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: loungelightSwitchesImages,
                comments: loungelightSwitchesCondition ?? 'N/A',
                feedback: loungelightSwitchesDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: loungesocketsImages,
                comments: loungesocketsCondition ?? 'N/A',
                feedback: loungesocketsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: loungeflooringImages,
                comments: loungeflooringCondition ?? 'N/A',
                feedback: loungeflooringDescription ?? 'N/A',
                conditionImages: [],
              ),

              //12.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: loungeadditionalItemsImages,
                comments: loungeadditionalItemsCondition ?? 'N/A',
                feedback: loungeadditionalItemsDescription ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Manuals',
            subTypes: [
              //21.1 House Appliance Manual
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'House Appliance Manual',
                images: houseApplinceManualImages,
                comments: houseApplinceManual ?? 'N/A',
                feedback: houseApplinceManual ?? 'N/A',
                conditionImages: [],
              ),

              //21.2 Kitchen Appliance Manual
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Kitchen Appliance Manual',
                images: kitchenApplinceManualImages,
                comments: kitchenApplinceManual ?? 'N/A',
                feedback: kitchenApplinceManual ?? 'N/A',
                conditionImages: [],
              ),

              //21.3 Heating Manual
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Heating Manual',
                images: heatingManualImages,
                comments: heatingManual ?? 'N/A',
                feedback: heatingManual ?? 'N/A',
                conditionImages: [],
              ),

              //21.4 Landlord Gas Safety Certificate
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Landlord Gas Safety Certificate',
                images: landlordGasSafetyCertificateImages,
                comments: landlordGasSafetyCertificate ?? 'N/A',
                feedback: landlordGasSafetyCertificate ?? 'N/A',
                conditionImages: [],
              ),

              //21.5 Legionella Risk Assessment
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Legionella Risk Assessment',
                images: legionellaRiskAssessmentImages,
                comments: legionellaRiskAssessment ?? 'N/A',
                feedback: legionellaRiskAssessment ?? 'N/A',
                conditionImages: [],
              ),

              //21.6 Electricity Safety Certificate
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Electricity Safety Certificate',
                images: electricalSafetyCertificateImages,
                comments: electricalSafetyCertificate ?? 'N/A',
                feedback: electricalSafetyCertificate ?? 'N/A',
                conditionImages: [],
              ),

              //21.7 Energy Performance Certificate
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Energy Performance Certificate',
                images: energyPerformanceCertificateImages,
                comments: energyPerformanceCertificate ?? 'N/A',
                feedback: energyPerformanceCertificate ?? 'N/A',
                conditionImages: [],
              ),

              //21.8 Move In Checklist
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Move In Checklist',
                images: moveInChecklistImages,
                comments: moveInChecklist ?? 'N/A',
                feedback: moveInChecklist ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Landing',
            subTypes: [
              //16.1 Door
              // SubTypeDto(
              //   subTypeId: 'subType001',
              //   subTypeName: 'Door',
              //   images: landingdoorImages,
              //   comments: landingdoorCondition ?? 'N/A',
              //   feedback: landingdoorCondition ?? 'N/A',
              //   conditionImages: [],
              // ),

              // //16.2 Door Frame
              // SubTypeDto(
              //   subTypeId: 'subType001',
              //   subTypeName: 'Door Frame',
              //   images: landingdoorFrameImages,
              //   comments: landingdoorFrameCondition ?? 'N/A',
              //   feedback: landingdoorFrameCondition ?? 'N/A',
              //   conditionImages: [],
              // ),

              //16.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: landingceilingImages,
                comments: landingceilingCondition ?? 'N/A',
                feedback: landingceilingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: landinglightingImages,
                comments: landinglightingCondition ?? 'N/A',
                feedback: landinglightingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: ladingwallsImages,
                comments: landingwallsCondition ?? 'N/A',
                feedback: landingwallsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: landingskirtingImages,
                comments: landingskirtingCondition ?? 'N/A',
                feedback: landingskirtingDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: landingwindowSillImages,
                comments: landingwindowSillCondition ?? 'N/A',
                feedback: landingwindowSillDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: landingcurtainsImages,
                comments: landingcurtainsCondition ?? 'N/A',
                feedback: landingcurtainsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: landingblindsImages,
                comments: landingblindsCondition ?? 'N/A',
                feedback: landingblindsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: landinglightSwitchesImages,
                comments: landinglightSwitchesCondition ?? 'N/A',
                feedback: landinglightSwitchesDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: landingsocketsImages,
                comments: landingsocketsCondition ?? 'N/A',
                feedback: landingsocketsDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: landingflooringImages,
                comments: landingflooringCondition ?? 'N/A',
                feedback: landingflooringDescription ?? 'N/A',
                conditionImages: [],
              ),

              //16.13 Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: landingadditionalItemsImages,
                comments: landingadditionalItemsCondition ?? 'N/A',
                feedback: landingadditionalItemsDescription ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),

          InspectionReportDto(
            reportId: 'report001',
            name: 'Dining Room',
            subTypes: [
              //16.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Gas Meter',
                images: diningGasMeterImages,
                comments: diningGasMeterCondition ?? 'N/A',
                feedback: diningGasMeterCondition ?? 'N/A',
                conditionImages: [],
              ),

              //16.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Electric Meter',
                images: diningElectricMeterImages,
                comments: diningElectricMeterCondition ?? 'N/A',
                feedback: diningElectricMeterCondition ?? 'N/A',
                conditionImages: [],
              ),

              //16.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: '  Water Meter',
                images: diningWaterMeterImages,
                comments: diningWaterMeterCondition ?? 'N/A',
                feedback: diningWaterMeterCondition ?? 'N/A',
                conditionImages: [],
              ),

              //16.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: '  Oil Meter',
                images: diningOilMeterImages,
                comments: diningOilMeterCondition ?? 'N/A',
                feedback: diningOilMeterCondition ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),
          // 18 Ensuite
          InspectionReportDto(
            reportId: 'report001',
            name: 'Ensuite',
            subTypes: [
              //18.1 Door
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door',
                images: ensuitedoorImages,
                comments: ensuitdoorCondition ?? 'N/A',
                feedback: ensuitdoorLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.2 Door Frame
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Door Frame',
                images: ensuitedoorFrameImages,
                comments: ensuitdoorFrameCondition ?? 'N/A',
                feedback: ensuitedoorFrameLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.3 Ceilings
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Ceilings',
                images: ensuiteceilingImages,
                comments: ensuiteceilingCondition ?? 'N/A',
                feedback: ensuitceilingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.4 Lighting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Lighting',
                images: ensuitelightingImages,
                comments: ensuitlightingCondition ?? 'N/A',
                feedback: ensuitelightingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.5 Wall
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Wall',
                images: ensuitewallsImages,
                comments: ensuitewallsCondition ?? 'N/A',
                feedback: ensuitewallsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.6 Skirting
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Skirting',
                images: ensuiteskirtingImages,
                comments: ensuiteskirtingCondition ?? 'N/A',
                feedback: ensuiteskirtingLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.7 Window Sill
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Window Sill',
                images: ensuitewindowSillImages,
                comments: ensuitewindowSillCondition ?? 'N/A',
                feedback: ensuitewindowSillLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.8 Curtains
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Curtains',
                images: ensuitecurtainsImages,
                comments: ensuitecurtainsCondition ?? 'N/A',
                feedback: ensuitecurtainsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.9 Blinds
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Blinds',
                images: ensuiteblindsImages,
                comments: ensuiteblindsCondition ?? 'N/A',
                feedback: ensuiteblindsLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.10 Light Switches
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Light Switches',
                images: ensuitelightSwitchesImages,
                comments: ensuitelightSwitchesCondition ?? 'N/A',
                feedback: ensuitelightSwitchesLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.11 Sockets
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Sockets',
                images: ensuiteSocketImages,
                comments: ensuiteSocketCondition ?? 'N/A',
                feedback: ensuiteSocketLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.12 Flooring
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Flooring',
                images: ensuiteflooringImages,
                comments: ensuiteFlooringCondition ?? 'N/A',
                feedback: ensuiteFlooringLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.13 Toilet
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Toilet',
                images: ensuiteToiletImages,
                comments: ensuiteToiletCondition ?? 'N/A',
                feedback: ensuiteToiletLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.14 Basin
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Basin',
                images: ensuiteBasinImages,
                comments: ensuiteBasinCondition ?? 'N/A',
                feedback: ensuiteBasinLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.15 Shower Cubicle
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Shower Cubicle',
                images: ensuiteShowerCubicleImages,
                comments: ensuiteShowerCubicleCondition ?? 'N/A',
                feedback: ensuiteShowerCubicleLocation ?? 'N/A',
                conditionImages: [],
              ),

              //18.16 Shower
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Shower',
                images: ensuiteShowerImages,
                comments: ensuiteShowerCondition ?? 'N/A',
                feedback: ensuiteShowerLocation ?? 'N/A',
                conditionImages: [],
              ),

              // Additional Items
              SubTypeDto(
                subTypeId: 'subType001',
                subTypeName: 'Additional Items',
                images: ensuiteadditionalItemsImages,
                comments: ensuiteAdditionItemsCondition ?? 'N/A',
                feedback: ensuiteAdditionItemsLocation ?? 'N/A',
                conditionImages: [],
              ),
            ],
            additionalComments: 'All areas in good condition.',
          ),
          // Add more InspectionReportDto items as needed
        ]),
  );

  Future<void> sendPropertyData(
      BuildContext context, PropertyDto property) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible:
      false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: CircularProgressIndicator(
              color: kPrimaryColor,
              strokeWidth: 3.0,
            ),
          ),
        );
      },
    );

    final url =
        '$baseURL/summary/generateReport'; // Replace with your backend URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(property.toJson());

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Close the loading dialog after receiving a response
      Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200) {
        // Parse response and perform success actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                'Report Has been Sent to your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
              )),
        );
        // Hide the loading indicator
        Navigator.of(context).pop();

        // Navigate to the confirmation page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        });
      } else {
        // Handle non-200 status codes
        _showErrorDialog(
            context, 'Failed to save data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Close the loading dialog if an exception occurs
      Navigator.of(context, rootNavigator: true).pop();

      // Handle connection issues or other errors
      _showErrorDialog(context, 'An error occurred: $e');
    }
  }

// Function to show error dialogs
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getSharedPreferencesData() async {
    String propertyId = widget.propertyId;
    final prefs = await SharedPreferences.getInstance();

    // Retrieve address data
    final addressLineOne =
        prefs.getString('overview_${propertyId}') ?? 'Default Address Line One';
    final addressLineTwo =
        prefs.getString('addressLineTwo') ?? 'Default Address Line Two';
    final city = prefs.getString('city') ?? 'Default City';
    final state = prefs.getString('state') ?? 'Default State';
    final country = prefs.getString('country') ?? 'Default Country';
    final postalCode = prefs.getString('postalCode') ?? 'Default Postal Code';

    // Retrieve user data
    final userFirebaseId =
        prefs.getString('userFirebaseId') ?? 'Default Firebase ID';
    final userFirstName =
        prefs.getString('userFirstName') ?? 'Default First Name';
    final userLastName = prefs.getString('userLastName') ?? 'Default Last Name';
    final userUserName = prefs.getString('userUserName') ?? 'Default Username';
    final userEmail = prefs.getString('userEmail') ?? 'Default Email';
    final userLocation = prefs.getString('userLocation') ?? 'Default Location';

    // Retrieve inspection data
    final inspectionId =
        prefs.getString('inspectionId') ?? 'Default Inspection ID';
    final inspectorName =
        prefs.getString('inspectorName') ?? 'Default Inspector Name';
    final inspectionType =
        prefs.getString('inspectionType') ?? 'Default Inspection Type';
    final date = prefs.getString('date') ?? 'Default Date';
    final time = prefs.getString('time') ?? 'Default Time';
    final keyLocation =
        prefs.getString('keyLocation') ?? 'Default Key Location';
    final keyReference =
        prefs.getString('keyReference') ?? 'Default Key Reference';
    final internalNotes =
        prefs.getString('internalNotes') ?? 'Default Internal Notes';

    // Retrieve image paths or URLs from SharedPreferences
    final subTypeImagePaths = prefs.getString('overview_${propertyId}') ?? [];
    final subTypeComments =
        prefs.getString('subTypeComments') ?? 'Default Comments';
    final subTypeFeedback =
        prefs.getString('subTypeFeedback') ?? 'Default Feedback';
    final additionalComments =
        prefs.getString('additionalComments') ?? 'Default Additional Comments';

    return {
      'addressDto': {
        'addressLineOne': addressLineOne,
        'addressLineTwo': addressLineTwo,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
      },
      'userDto': {
        'firebaseId': userFirebaseId,
        'firstName': userFirstName,
        'lastName': userLastName,
        'userName': userUserName,
        'email': userEmail,
        'location': userLocation,
      },
      'inspectionDto': {
        'inspectionId': inspectionId,
        'inspectorName': inspectorName,
        'inspectionType': inspectionType,
        'date': date,
        'time': time,
        'keyLocation': keyLocation,
        'keyReference': keyReference,
        'internalNotes': internalNotes,
        'inspectionReports': [
          {
            'reportId': 'report001',
            'name': 'Schedule of Condition',
            'subTypes': [
              {
                'subTypeId': 'subType001',
                'subTypeName': 'Odours',
                'images': subTypeImagePaths, // Use image paths or URLs
                'comments': subTypeComments,
                'feedback': subTypeFeedback,
              },
            ],
            'additionalComments': additionalComments,
          },
        ],
      },
    };
  }

// Function to load images based on their paths
  Future<List<File>> loadImages(List<String> imagePaths) async {
    final imageFiles = <File>[];
    for (String path in imagePaths) {
      final file = File(path);
      if (await file.exists()) {
        imageFiles.add(file);
      }
    }
    return imageFiles;
  }

  // Example usage
  void exampleUsage() async {
    final data = await getSharedPreferencesData();
    final imagePaths = List<String>.from(
        data['inspectionDto']['inspectionReports'][0]['subTypes'][0]['images']);
    final imageFiles = await loadImages(imagePaths);

    // Now you have the list of image files and can use them as needed
  }

  late String firebaseId;

  Future<void> getFirebaseUserId() async {
    try {
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          firebaseId = user!.uid;
        });
        fetchUserDetails();
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error getting user UID: $e");
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final response =
      await http.get(Uri.parse('$baseURL/user/firebaseId/$firebaseId'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        final List<dynamic> userData = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Assuming you have a userDetails map to store user information
            userDetails =
                userData.map((item) => item as Map<String, dynamic>).toList();
            print(userDetails.length);
            isLoading = false;
          });
        }
      } else {
        print("Failed to load user data: ${response.statusCode}");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load user data. Please try again."),
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      // Schedule of Condition

      {
        'title': '1. Schedule of Condition',
        'icon': Icons.schedule,
        'subItems': [
          // Overview
          {
            'title': '1.1 Overview - Odours',
            'details': [
              {
                'label': 'Condition',
                'value': overview ?? 'N/A',
              },
            ],
            'images': overviewImages,
            // Use image paths or URLs
          },
          {
            'title': '1.2 Genral Cleanliness',
            'details': [
              {
                'label': 'Condition',
                'value': accessoryCleanliness ?? 'N/A',
              },
            ],
            'images': accessoryCleanlinessImages,
            // Use image paths or URLs
          },
          {
            'title': '1.3 Bathroom/En Suite/ Toilet(s)',
            'details': [
              {
                'label': 'Condition',
                'value': windowSill ?? 'N/A',
              },
            ],
            'images': windowSillImages,
            // Use image paths or URLs
          },
          {
            'title': '1.4 Carpets',
            'details': [
              {
                'label': 'Condition',
                'value': carpets ?? 'N/A',
              },
            ],
            'images': carpetsImages,
            // Use image paths or URLs
          },
          {
            'title': '1.5 Ceiling(s)',
            'details': [
              {
                'label': 'Condition',
                'value': ceilings ?? 'N/A',
              },
            ],
            'images': ceilingsImages,
            // Use image paths or URLs
          },
          {
            'title': '1.6 Curtains/Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': curtains ?? 'N/A',
              },
            ],
            'images': curtainsImages,
            // Use image paths or URLs
          },
          {
            'title': '1.7 Hard Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': hardFlooring ?? 'N/A',
              },
            ],
            'images': hardFlooringImages,
            // Use image paths or URLs
          },
          {
            'title': '1.8 Kitchen Area',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenArea ?? 'N/A',
              },
            ],
            'images': kitchenAreaImages,
            // Use image paths or URLs
          },
          {
            'title': '1.9 Kitchen - White Goods',
            'details': [
              {
                'label': 'Condition',
                'value': kitchen ?? 'N/A',
              },
            ],
            'images': kitchenImages,
            // Use image paths or URLs
          },
          {
            'title': '1.10 Oven/Hob/Extractor Hood/Cooker',
            'details': [
              {
                'label': 'Condition',
                'value': oven ?? 'N/A',
              },
            ],
            'images': ovenImages,
            // Use image paths or URLs
          },
          {
            'title': '1.11 Mattress(s)',
            'details': [
              {
                'label': 'Condition',
                'value': mattress ?? 'N/A',
              },
            ],
            'images': mattressImages,
            // Use image paths or URLs
          },
          {
            'title': '1.12 Upholstery',
            'details': [
              {
                'label': 'Condition',
                'value': upholstrey ?? 'N/A',
              },
            ],
            'images': upholstreyImages,
            // Use image paths or URLs
          },
          {
            'title': '1.13 Wall(s)',
            'details': [
              {
                'label': 'Condition',
                'value': wall ?? 'N/A',
              },
            ],
            'images': wallImages,
            // Use image paths or URLs
          },
          {
            'title': '1.14 Window(s)',
            'details': [
              {
                'label': 'Condition',
                'value': window ?? 'N/A',
              },
            ],
            'images': windowImages,
            // Use image paths or URLs
          },
          {
            'title': '1.15 Woodwork',
            'details': [
              {
                'label': 'Condition',
                'value': woodwork ?? 'N/A',
              },
            ],
            'images': woodworkImages,
            // Use image paths or URLs
          },
          // {
          //   'title': '1.2 Name - Cleanliness',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Clean'},
          //   ],
          //   'images': ['path_to_image3', 'path_to_image4']
          //   // Use image paths or URLs
          // },
        ],
      },

      {
        'title': '5. Keys Handed Over At Check In',
        'icon': Icons.key,
        'subItems': [
          {
            'title': '5.1 Yale',
            'details': [
              {
                'label': 'Condition',
                'value': yale ?? 'N/A',
              },
            ],
            'images': keysHandOverYaleImages, // Use image URLs
          },
          {
            'title': '5.2 Mortice',
            'details': [
              {
                'label': 'Condition',
                'value': mortice ?? 'N/A',
              },
            ],
            'images': keysHandOverMorticeImages, // Use image URLs
          },
          {
            'title': '5.3 Other',
            'details': [
              {
                'label': 'Condition',
                'value': other ?? 'N/A',
              },
            ],
            'images': keysHandOverOtherImages, // Use image URLs
          },
        ],
      },

      {
        'title': '2. EV Charger(s)',
        'icon': Icons.charging_station,
        'subItems': [
          {
            'title': '2.1 Overview',
            'details': [
              {
                'label': 'Condition',
                'value': evChargerDescription ?? 'N/A',
              },
            ],
            'images': evChargerImages,
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '3. Meter Readings',
        'icon': Icons.gas_meter,
        'subItems': [
          {
            'title': '3.1 Gas Meter ',
            'details': [
              {
                'label': 'Condition',
                'value': GasMeterReading ?? 'N/A',
              },
            ],
            'images': gasMeterImages
            // Use image paths or URLs
          },
          {
            'title': '3.2 Electric Meter ',
            'details': [
              {
                'label': 'Condition',
                'value': electricMeterReading ?? 'N/A',
              },
            ],
            'images': electricMeterImages
            // Use image paths or URLs
          },
          {
            'title': '3.3 Water Meter ',
            'details': [
              {
                'label': 'Condition',
                'value': waterMeterReading ?? 'N/A',
              },
            ],
            'images': waterMeterImages
            // Use image paths or URLs
          },
          {
            'title': '3.4 Oil Meter ',
            'details': [
              {
                'label': 'Condition',
                'value': oilMeterReading ?? 'N/A',
              },
            ],
            'images': oilMeterImages
            // Use image paths or URLs
          },
          {
            'title': '3.5 Other ',
            'details': [
              {
                'label': 'Condition',
                'value': otherMeterReading ?? 'N/A',
              },
            ],
            'images': otherMeterImages
            // Use image paths or URLs
          },
        ],
      },

      {
        'title': '4. Keys',
        'icon': Icons.key,
        'subItems': [
          {
            'title': '4.1 Yale ',
            'details': [
              {
                'label': 'Condition',
                'value': yaleLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': yaleLocation ?? 'N/A',
              },
            ],
            'images': yaleImages
            // Use image paths or URLs
          },
          {
            'title': '4.2 Mortice',
            'details': [
              {
                'label': 'Condition',
                'value': morticeLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': morticeLocation ?? 'N/A',
              },
            ],
            'images': morticeImages
            // Use image paths or URLs
          },
          {
            'title': '4.3 Window Lock',
            'details': [
              {
                'label': 'Condition',
                'value': windowLockLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': windowLockLocation ?? 'N/A',
              },
            ],
            'images': windowLockImages
            // Use image paths or URLs
          },
          {
            'title': '4.4 Gas/Electric Meter ',
            'details': [
              {
                'label': 'Condition',
                'value': gasMeterLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': gasMeterLocation ?? 'N/A',
              },
            ],
            'images': keygasMeterImages
            // Use image paths or URLs
          },
          {
            'title': '4.5 Car Pass/Permit ',
            'details': [
              {
                'label': 'Condition',
                'value': carPassLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': carPassReading ?? 'N/A',
              },
            ],
            'images': carPassImages
            // Use image paths or URLs
          },
          {
            'title': '4.6 Remote/Security Fob ',
            'details': [
              {
                'label': 'Condition',
                'value': remoteLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': remoteReading ?? 'N/A',
              },
            ],
            'images': remoteImages
            // Use image paths or URLs
          },
          {
            'title': '4.7 Other ',
            'details': [
              {
                'label': 'Condition',
                'value': otherLocation ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': otherReading ?? 'N/A',
              },
            ],
            'images': otherImages
            // Use image paths or URLs
          },
        ],
      },

      {
        'title': '6. Health & Safety | Smoke & Carbon Monoxide Alarms',
        'icon': Icons.health_and_safety,
        'subItems': [
          {
            'title': '6.1 Smoke Alarm(s)',
            'details': [
              {
                'label': 'Condition',
                'value': smokeAlarmCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': smokeAlarmDescription ?? 'N/A',
              },
            ],
            'images': smokeAlarmImages
            // Use image paths or URLs
          },
          {
            'title': '6.2 Heat Sensor Alarm(s)',
            'details': [
              {
                'label': 'Condition',
                'value': heatSensorCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': heatSensorDescription ?? 'N/A',
              },
            ],
            'images': heatSensorImages
            // Use image paths or URLs
          },
          {
            'title': '6.3 Carbon Monoxide Alarm(s)',
            'details': [
              {
                'label': 'Condition',
                'value': carbonMonoxideCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': carbonMonoxideDescription ?? 'N/A',
              },
            ],
            'images': carbonMonxideImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '8. Front Garden',
        'icon': Icons.lightbulb,
        'subItems': [
          {
            'title': '8.1 Garden Discritpion',
            'details': [
              {'label': 'Condition', 'value': gardenDescription ?? 'N/A'},
            ],
            'images': gardenImages,
            // Use image paths or URLs
          },
          {
            'title': '8.2 DriveWay',
            'details': [
              {
                'label': 'Condition',
                'value': driveWayDescription ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value':  ?? 'N/A',
              // },
            ],
            'images': driveWayImages
            // Use image paths or URLs
          },
          {
            'title': '8.3 Outside Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': outsideLightingDescription ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value':  ?? 'N/A',
              // },
            ],
            'images': outsideLightingImages
            // Use image paths or URLs
          },
          {
            'title': '8.4 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': additionalItemsDescription ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value':  ?? 'N/A',
              // },
            ],
            'images': additionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '7. Garage',
        'icon': Icons.garage,
        'subItems': [
          // {
          //   'title': '7.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '7.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': garageDoorCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': newdoor ?? 'N/A',
              // },
            ],
            'images': garagedoorImages
            // Use image paths or URLs
          },
          {
            'title': '7.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': garageDoorFrameCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garageDoorDescription ?? 'N/A',
              // },
            ],
            'images': garagedoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '7.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': garageceilingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garageceilingDescription ?? 'N/A',
              // },
            ],
            'images': garageceilingImages
            // Use image paths or URLs
          },
          {
            'title': '7.5 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': garagelightingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garagelightingDescription ?? 'N/A',
              // },
            ],
            'images': garagelightingImages
            // Use image paths or URLs
          },
          {
            'title': '7.6 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': garagewallsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garagewallsDescription ?? 'N/A',
              // },
            ],
            'images': garagewallsImages
            // Use image paths or URLs
          },
          {
            'title': '7.7 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': garagewindowSillCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garagewindowSillDescription ?? 'N/A',
              // },
            ],
            'images': garagewindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '7.8 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': garagelightSwitchesCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garagelightSwitchesDescription ?? 'N/A',
              // },
            ],
            'images': garagelightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '7.9 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': garagesocketsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garagesocketsDescription ?? 'N/A',
              // },
            ],
            'images': garagesocketsImages
            // Use image paths or URLs
          },
          {
            'title': '7.10 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': garageflooringCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': garageflooringDescription ?? 'N/A',
              // },
            ],
            'images': garageflooringImages
            // Use image paths or URLs
          },
          {
            'title': '7.11 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': garageadditionalItemsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': additionItemsImagePath ?? 'N/A',
              // },
            ],
            'images': garageadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },

      {
        'title': '9. Exterior Front',
        'icon': Icons.stairs,
        'subItems': [
          // {
          //   'title': '9.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Goods'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '9.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': exteriorFrontDoorCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': ExteriorFrontDoorCondition ?? 'N/A',
              // },
            ],
            'images': exteriorFrontDoorImages
            // Use image paths or URLs
          },
          {
            'title': '9.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': exteriorFrontDoorFrameCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': exteriorFrontDoorFrameCondition ?? 'N/A',
              // },
            ],
            'images': exteriorFrontDoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '9.4 Porch',
            'details': [
              {
                'label': 'Condition',
                'value': exteriorFrontPorchCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': exteriorFrontPorchCondition ?? 'N/A',
              // },
            ],
            'images': exteriorFrontPorchImages
            // Use image paths or URLs
          },
          {
            'title': '9.5 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': exteriorFrontAdditionalItemsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': exteriorFrontAdditionalItemsCondition ?? 'N/A',
              // },
            ],
            'images': exteriorFrontAdditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },

      {
        'title': '10. Entrance Hallway',
        'icon': Icons.stairs,
        'subItems': [
          // {
          //   'title': '10.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '10.2 Door',
            'details': [
              {'label': 'Condition', 'value': entranceDoorCondition ?? 'N/A'},
            ],
            'images': entranceDoorImages
            // Use image paths or URLs
          },
          {
            'title': '10.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': entranceDoorFrameCondition ?? 'N/A'
              },
            ],
            'images': entranceDoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '10.4 Door Bell/Reciever',
            'details': [
              {
                'label': 'Condition',
                'value': entranceDoorBellCondition ?? 'N/A'
              },
            ],
            'images': entranceDoorBellImages
            // Use image paths or URLs
          },
          {
            'title': '10.5 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': entranceCeilingCondition ?? 'N/A'
              },
            ],
            'images': entranceCeilingImages
            // Use image paths or URLs
          },
          {
            'title': '10.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': entranceLightSwitchesCondition ?? 'N/A'
              },
            ],
            'images': entranceLightingImages
            // Use image paths or URLs
          },
          {
            'title': '10.7 Walls',
            'details': [
              {'label': 'Condition', 'value': entranceWallsCondition ?? 'N/A'},
            ],
            'images': entranceWallsImages
            // Use image paths or URLs
          },
          {
            'title': '10.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': entranceSkirtingCondition ?? 'N/A'
              },
            ],
            'images': entranceSkirtingImages
            // Use image paths or URLs
          },
          {
            'title': '10.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': entranceWindowSillCondition ?? 'N/A'
              },
            ],
            'images': entranceWindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '10.10 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': entranceCurtainsCondition ?? 'N/A'
              },
            ],
            'images': entranceCurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '10.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': entranceBlindsCondition ?? 'N/A'},
            ],
            'images': entranceBlindsImages
            // Use image paths or URLs
          },
          {
            'title': '10.12 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': entranceLightSwitchesCondition ?? 'N/A'
              },
            ],
            'images': entranceLightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '10.13 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': entranceSocketsCondition ?? 'N/A'
              },
            ],
            'images': entranceSocketsImages
            // Use image paths or URLs
          },
          {
            'title': '10.14 Heating',
            'details': [
              {
                'label': 'Condition',
                'value': entranceHeatingCondition ?? 'N/A'
              },
            ],
            'images': entranceHeatingImages
            // Use image paths or URLs
          },
          {
            'title': '10.15 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': entranceFlooringCondition ?? 'N/A'
              },
            ],
            'images': entranceFlooringImages
            // Use image paths or URLs
          },
          {
            'title': '10.16 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': entranceAdditionalItemsCondition ?? 'N/A'
              },
            ],
            'images': entranceAdditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '11. Toilet',
        'icon': Icons.wash_rounded,
        'subItems': [
          // {
          //   'title': '11.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '11.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': toiletDoorCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletDoorDescription ?? 'N/A',
              // },
            ],
            'images': toiletDoorImages
            // Use image paths or URLs
          },
          {
            'title': '11.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': toiletDoorFrameCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletDoorFrameDescription ?? 'N/A',
              // },
            ],
            'images': toiletDoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '11.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': toiletCeilingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletCeilingDescription ?? 'N/A',
              // },
            ],
            'images': toiletCeilingImages
            // Use image paths or URLs
          },
          {
            'title': '11.5 Extractor Fan',
            'details': [
              {
                'label': 'Condition',
                'value': toiletExtractorFanCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletExtractorFanDescription ?? 'N/A',
              // },
            ],
            'images': toiletExtractorFanImages
            // Use image paths or URLs
          },
          {
            'title': '11.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': toiletLightingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletLightingDescription ?? 'N/A',
              // },
            ],
            'images': toiletlLightingImages
            // Use image paths or URLs
          },
          {
            'title': '11.7 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': toiletWallsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletWallsCondition ?? 'N/A',
              // },
            ],
            'images': toiletWallsImages
            // Use image paths or URLs
          },
          {
            'title': '11.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': toiletSkirtingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletSkirtingDescription ?? 'N/A',
              // },
            ],
            'images': toiletSkirtingImages
            // Use image paths or URLs
          },
          {
            'title': '11.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': toiletWindowSillCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletwWindowSillDescription ?? 'N/A',
              // },
            ],
            'images': toiletWindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '11.10 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': toiletBlindsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletBlindsDescription ?? 'N/A',
              // },
            ],
            'images': toiletBlindsImages
            // Use image paths or URLs
          },
          // {
          //   'title': '11.11 Toilet',
          //   'details': [
          //     {
          //       'label': 'Condition',
          //       'value': toiletToiletCondition ?? 'N/A',
          //     },
          //     // {
          //     //   'label': 'Additional Comments',
          //     //   'value': toiletToiletDescription ?? 'N/A',
          //     // },
          //   ],
          //   'images': toiletToiletImages
          //   // Use image paths or URLs
          // },
          {
            'title': '11.12 Basin',
            'details': [
              {
                'label': 'Condition',
                'value': toiletBasinCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletBasinDescription ?? 'N/A',
              // },
            ],
            'images': toiletBasinImages
            // Use image paths or URLs
          },
          {
            'title': '11.13 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': toiletSwitchBoardCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletSwitchBoardDescription ?? 'N/A',
              // },
            ],
            'images': toiletSwitchBoardImages
            // Use image paths or URLs
          },
          {
            'title': '11.14 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': toiletSocketCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletSocketDescription ?? 'N/A',
              // },
            ],
            'images': toiletSocketImages
            // Use image paths or URLs
          },
          {
            'title': '11.15 Heating',
            'details': [
              {
                'label': 'Condition',
                'value': toiletHeatingCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletHeatingDescription ?? 'N/A',
              // },
            ],
            'images': toiletHeatingImages
            // Use image paths or URLs
          },
          {
            'title': '11.16 Accessories',
            'details': [
              {
                'label': 'Condition',
                'value': toiletAccessoriesCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletAccessoriesDescription ?? 'N/A',
              // },
            ],
            'images': toiletAccessoriesImages
            // Use image paths or URLs
          },
          {
            'title': '11.17 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': toiletFlooringCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletFlooringDescription ?? 'N/A',
              // },
            ],
            'images': toiletFlooringImages
            // Use image paths or URLs
          },
          {
            'title': '11.18 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': toiletAdditionalItemsCondition ?? 'N/A',
              },
              // {
              //   'label': 'Additional Comments',
              //   'value': toiletAdditionalItemsDescription ?? 'N/A',
              // },
            ],
            'images': toiletAdditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '20. Rear Garden',
        'icon': Icons.landscape,
        'subItems': [
          {
            'title': '20.1 Garden Description',
            'details': [
              {
                'label': 'Condition',
                'value': reargardenDescription ?? 'N/A',
              },
            ],
            'images': reargardenDescriptionImages,
            // Use image paths or URLs
          },
          {
            'title': '20.2 Outside Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': rearGardenOutsideLighting ?? 'N/A',
              },
            ],
            'images': rearGardenOutsideLightingImages,
            // Use image paths or URLs
          },
          {
            'title': '20.3 Summer House',
            'details': [
              {
                'label': 'Condition',
                'value': rearGardensummerHouse ?? 'N/A',
              },
            ],
            'images': rearGardensummerHouseImages
            // Use image paths or URLs
          },
          {
            'title': '20.4 Shed(s)',
            'details': [
              {
                'label': 'Condition',
                'value': rearGardenshed ?? 'N/A',
              },
            ],
            'images': rearGardenshedImages,
            // Use image paths or URLs
          },
          {
            'title': '20.5 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': rearGardenadditionalInformation ?? 'N/A',
              },
            ],
            'images': rearGardenadditionalInformationImages,
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '15. Stairs',
        'icon': Icons.stairs,
        'subItems': [
          // {
          //   'title': '15.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '15.2 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': stairsceilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairsceilingDescription ?? 'N/A',
              },
            ],
            'images': stairsceilingImages
            // Use image paths or URLs
          },
          {
            'title': '15.3 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': stairslightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairslightingDescription ?? 'N/A',
              },
            ],
            'images': stairslightingImages
            // Use image paths or URLs
          },
          {
            'title': '15.4 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': stairswallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairswallsDescription ?? 'N/A',
              },
            ],
            'images': stairswallsImages
            // Use image paths or URLs
          },
          {
            'title': '15.5 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': stairsskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairsskirtingDescription ?? 'N/A',
              },
            ],
            'images': stairsskirtingImages
            // Use image paths or URLs
          },
          {
            'title': '15.6 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': stairswindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairswindowSillDescription ?? 'N/A',
              },
            ],
            'images': stairswindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '15.7 Curtains',
            'details': [
              {
                'label': 'Condition',
                'value': stairscurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairscurtainsDescription ?? 'N/A',
              },
            ],
            'images': stairscurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '15.8 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': stairsblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairsblindsDescription ?? 'N/A',
              },
            ],
            'images': stairsblindsImages
            // Use image paths or URLs
          },
          {
            'title': '15.9 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': stairslightSwitchesCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairslightSwitchesDescription ?? 'N/A',
              },
            ],
            'images': stairslightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '15.10 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': stairssocketsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairssocketsDescription ?? 'N/A',
              },
            ],
            'images': stairssocketsImages
            // Use image paths or URLs
          },
          // {
          //   'title': '15.11 Heating',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Goods'},
          //   ],
          //   'images':   stairsheatingImages
          //   // Use image paths or URLs
          // },
          // {
          //   'title': '15.12 Staircase',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images':   stairsstaircaseImages
          //   // Use image paths or URLs
          // },
          {
            'title': '15.11 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': stairsflooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairsflooringDescription ?? 'N/A',
              },
            ],
            'images': stairsflooringImages
            // Use image paths or URLs
          },
          {
            'title': '15.12 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': stairsadditionalItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': stairsadditionalItemsDescription ?? 'N/A',
              },
            ],
            'images': stairsadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '14. Utility Room/Area',
        'icon': Icons.meeting_room,
        'subItems': [
          // {
          //   'title': '14.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '14.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': utilityDoorCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityDoorDescription ?? 'N/A',
              },
            ],
            'images': utilitydoorImages
            // Use image paths or URLs
          },
          {
            'title': '14.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': utilityDoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityDoorFrameDescription ?? 'N/A',
              },
            ],
            'images': utilitydoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '14.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': utilityCeilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityCeilingDescription ?? 'N/A',
              },
            ],
            'images': utilityceilingImages
            // Use image paths or URLs
          },
          // {
          //   'title': '14.5 Extractor Fan',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Goods'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '14.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': utilityLightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitylightingDescription ?? 'N/A',
              },
            ],
            'images': utilitylightingImages
            // Use image paths or URLs
          },
          {
            'title': '14.7 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': utilitywallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitywallsDescription ?? 'N/A',
              },
            ],
            'images': utilitywallsImages
            // Use image paths or URLs
          },
          {
            'title': '14.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': utilityskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityskirtingDescription ?? 'N/A',
              },
            ],
            'images': utilityskirtingImages
            // Use image paths or URLs
          },
          {
            'title': '14.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': utilitywindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitywindowSillDescription ?? 'N/A',
              },
            ],
            'images': utilitywindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '14.10 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': utilitycurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitycurtainsDescription ?? 'N/A',
              },
            ],
            'images': utilitycurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '14.11 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': utilityblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityblindsDescription ?? 'N/A',
              },
            ],
            'images': utilityblindsImages
            // Use image paths or URLs
          },
          {
            'title': '14.12 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': utilitylightSwitchesCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitylightSwitchesDescription ?? 'N/A',
              },
            ],
            'images': utilitylightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '14.13 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': utilitysocketsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilitysocketsDescription ?? 'N/A',
              },
            ],
            'images': utilitysocketsImages
            // Use image paths or URLs
          },

          {
            'title': '13.21 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': utilityflooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityflooringDescription ?? 'N/A',
              },
            ],
            'images': utilityflooringImages
            // Use image paths or URLs
          },
          {
            'title': '13.22 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': utilityadditionalItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': utilityadditionalItemsDescription ?? 'N/A',
              },
            ],
            'images': utilityadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      }, // Add more headings here
      {
        'title': '19. Bedroom ',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '5.4 Door',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomDoorLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomDoorCondition ?? 'N/A',
              },
            ],
            'images': bedRoomDoorImages,
          },
          {
            'title': '5.5 DoorFrame',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomDoorFrameLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomDoorFrameCondition ?? 'N/A',
              },
            ],
            'images': bedRoomDoorFrameImages,
          },
          {
            'title': '5.6 Ceiling',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomCeilingLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomCeilingCondition ?? 'N/A',
              },
            ],
            'images': bedRoomCeilingImages,
          },
          {
            'title': '5.7 Lighting',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomLightingLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomLightingCondition ?? 'N/A',
              },
            ],
            'images': bedRoomlLightingImages,
          },
          {
            'title': '5.8 Walls',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomWallsLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomWallsCondition ?? 'N/A',
              },
            ],
            'images': bedRoomwWallsImages,
          },
          {
            'title': '5.9 Skirting',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomSkirtingLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomsSkirtingCondition ?? 'N/A',
              },
            ],
            'images': bedRoomSkirtingImages,
          },
          {
            'title': '5.10 Window Sill',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomWindowSillLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomWindowSillCondition ?? 'N/A',
              },
            ],
            'images': bedRoomWindowSillImages,
          },
          {
            'title': '5.11 Curtains',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomCurtainsLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomCurtainsCondition ?? 'N/A',
              },
            ],
            'images': bedRoomCurtainsImages,
          },
          {
            'title': '5.12 Blinds',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomBlindsLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomBlindsCondition ?? 'N/A',
              },
            ],
            'images': bedRoomBlindsImages,
          },
          {
            'title': '5.13 Light Switches',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomLightSwitchesLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomLightSwitchesCondition ?? 'N/A',
              },
            ],
            'images': bedRoomLightSwitchesImages,
          },
          {
            'title': '5.14 Sockets',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomSocketsLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomSocketsCondition ?? 'N/A',
              },
            ],
            'images': bedRoomSocketsImages,
          },
          {
            'title': '5.15 Flooring',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomFlooringLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomFlooringCondition ?? 'N/A',
              },
            ],
            'images': bedRoomFlooringImages,
          },
          {
            'title': '5.16 Additional Items',
            'details': [
              {
                'label': 'Location',
                'value': bedRoomAdditionalItemsLocation ?? 'N/A',
              },
              {
                'label': 'Condition',
                'value': bedRoomAdditionalItemsCondition ?? 'N/A',
              },
            ],
            'images': bedRoomAdditionalItemsImages,
          },
        ],
      },
      {
        'title': '13. Kitchen',
        'icon': Icons.kitchen,
        'subItems': [
          // {
          //   'title': '13.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '13.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenNewDoor ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenDoorDescription ?? 'N/A',
              },
            ],
            'images': kitchenDoorImages
            // Use image paths or URLs
          },
          {
            'title': '13.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenDoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenDoorFrameDescription ?? 'N/A',
              },
            ],
            'images': kitchenDoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '13.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenCeilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenCeilingDescription ?? 'N/A',
              },
            ],
            'images': kitchenCeilingImages
            // Use image paths or URLs
          },
          {
            'title': '13.5 Extractor Fan',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenExtractorFanCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenExtractorFanDescription ?? 'N/A',
              },
            ],
            'images': kitchenExtractorFanImages
            // Use image paths or URLs
          },
          {
            'title': '13.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenLightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenLightingDescription ?? 'N/A',
              },
            ],
            'images': kitchenLightingImages
            // Use image paths or URLs
          },
          {
            'title': '13.7 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenWallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenWallsDescription ?? 'N/A',
              },
            ],
            'images': kitchenWallsImages
            // Use image paths or URLs
          },
          {
            'title': '13.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSkirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSkirtingDescription ?? 'N/A',
              },
            ],
            'images': kitchenSkirtingImages
            // Use image paths or URLs
          },
          {
            'title': '13.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenWindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenWindowSillDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.10 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenCurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenCurtainsDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.11 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenBlindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenBlindsDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.12 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSwitchBoardCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSwitchBoardDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.13 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSocketCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSocketDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.14 Heating',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenHeatingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenHeatingDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.15 Kitchen Units',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.16 Extractor Hood',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.17 Cooker',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.18 Hod',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.19 Oven',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.20 Worktop(s)',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.21 Sink',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.22 Fridge/Freezer',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.24 Dishwasher',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.25 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenFlooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenFlooringDescription ?? 'N/A',
              },
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.26 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Goods'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '12. Lounge',
        'icon': Icons.stairs,
        'subItems': [
          // {
          //   'title': '12.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '12.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': lougeDoorCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungedoorDescription ?? 'N/A',
              },
            ],
            'images': loungedoorImages
            // Use image paths or URLs
          },
          {
            'title': '12.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': loungedoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungedoorFrameDescription ?? 'N/A',
              },
            ],
            'images': loungedoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '12.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': loungeceilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungeceilingDescription ?? 'N/A',
              },
            ],
            'images': loungeceilingImages
            // Use image paths or URLs
          },
          {
            'title': '12.5 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': loungelightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungelightingDescription ?? 'N/A',
              },
            ],
            'images': loungelightingImages
            // Use image paths or URLs
          },
          {
            'title': '12.6 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': loungewallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungewallsDescription ?? 'N/A',
              },
            ],
            'images': loungewallsImages
            // Use image paths or URLs
          },
          {
            'title': '12.7 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': loungeskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungeskirtingDescription ?? 'N/A',
              },
            ],
            'images': loungeskirtingImages
            // Use image paths or URLs
          },
          {
            'title': '12.8 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': loungewindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungewindowSillDescription ?? 'N/A',
              },
            ],
            'images': loungewindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '12.9 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': loungecurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungecurtainsDescription ?? 'N/A',
              },
            ],
            'images': loungecurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '12.10 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': loungeblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungeblindsDescription ?? 'N/A',
              },
            ],
            'images': loungeblindsImages
            // Use image paths or URLs
          },
          {
            'title': '12.11 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': loungelightSwitchesCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungelightSwitchesDescription ?? 'N/A',
              },
            ],
            'images': loungelightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '12.12 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': loungesocketsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungesocketsDescription ?? 'N/A',
              },
            ],
            'images': loungesocketsImages
            // Use image paths or URLs
          },
          // {
          //   'title': '12.13 Heating',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Goods'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          // {
          //   'title': '12.14 Fireplace',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Goods'},
          //   ],
          //   'images':
          //   // Use image paths or URLs
          // },
          {
            'title': '12.15 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': loungeflooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungeflooringDescription ?? 'N/A',
              },
            ],
            'images': loungeflooringImages
            // Use image paths or URLs
          },
          {
            'title': '12.16 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': loungeadditionalItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': loungeadditionalItemsDescription ?? 'N/A',
              },
            ],
            'images': loungeadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '21. Manuals & Certificates',
        'icon': Icons.receipt_long,
        'subItems': [
          {
            'title': '21.1 House Application Manual',
            'details': [
              {
                'label': 'Condition',
                'value': houseApplinceManual ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': houseApplinceManualDescription ?? 'N/A',
              },
            ],
            'images': houseApplinceManualImages
            // Use image paths or URLs
          },
          {
            'title': '21.2 Kitchen Appliances Manuals',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenApplinceManual ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': houseApplinceManualDescription ?? 'N/A',
              },
            ],
            'images': kitchenApplinceManualImages
            // Use image paths or URLs
          },
          {
            'title': '21.3 Heating System Manual',
            'details': [
              {
                'label': 'Condition',
                'value': heatingManual ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': heatingManualDescription ?? 'N/A',
              },
            ],
            'images': heatingManualImages
            // Use image paths or URLs
          },
          {
            'title': '21.4 Landlord Gas Safety Certificate',
            'details': [
              {
                'label': 'Condition',
                'value': landlordGasSafetyCertificate ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landlordGasSafetyCertificateDescription ?? 'N/A',
              },
            ],
            'images': landlordGasSafetyCertificateImages
            // Use image paths or URLs
          },
          {
            'title': '21.5 Legionella Risk Assessment',
            'details': [
              {
                'label': 'Condition',
                'value': legionellaRiskAssessment ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': legionellaRiskAssessmentDescription ?? 'N/A',
              },
            ],
            'images': legionellaRiskAssessmentImages
            // Use image paths or URLs
          },
          {
            'title': '21.6 Electrical Safety Certificate',
            'details': [
              {
                'label': 'Condition',
                'value': electricalSafetyCertificate ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': electricalSafetyCertificateDescription ?? 'N/A',
              },
            ],
            'images': electricalSafetyCertificateImages
            // Use image paths or URLs
          },
          {
            'title': '21.7 Energy Performance Certificate',
            'details': [
              {
                'label': 'Condition',
                'value': energyPerformanceCertificate ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': energyPerformanceCertificateDescription ?? 'N/A',
              },
            ],
            'images': energyPerformanceCertificateImages
            // Use image paths or URLs
          },
          {
            'title': '21.8 Move In Checklist',
            'details': [
              {
                'label': 'Condition',
                'value': moveInChecklist ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': moveInChecklistDescription ?? 'N/A',
              },
            ],
            'images': moveInChecklistImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '16. Landing',
        'icon': Icons.stairs,
        'subItems': [
          // {
          //   'title': '16.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          // {
          //   'title': '16.1 Door',
          //   'details': [
          //     {
          //       'label': 'Condition',
          //       'value': landingdoorCondition ?? 'N/A',
          //     },
          //     {
          //       'label': 'Additional Comments',
          //       'value': landingceilingDescription ?? 'N/A',
          //     },
          //   ],
          //   'images': landingdoorImages
          //   // Use image paths or URLs
          // },
          // {
          //   'title': '16.2 Door Frame',
          //   'details': [
          //     {
          //       'label': 'Condition',
          //       'value': landingdoorFrameCondition ?? 'N/A',
          //     },
          //     {
          //       'label': 'Additional Comments',
          //       'value': landingceilingDescription ?? 'N/A',
          //     },
          //   ],
          //   'images': landingdoorFrameImages
          //   // Use image paths or URLs
          // },
          {
            'title': '16.3 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': landingceilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingceilingDescription ?? 'N/A',
              },
            ],
            'images': landingceilingImages
            // Use image paths or URLs
          },
          {
            'title': '16.4 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': landinglightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landinglightingDescription ?? 'N/A',
              },
            ],
            'images': landinglightingImages
            // Use image paths or URLs
          },
          {
            'title': '16.5 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': landingwallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingwallsDescription ?? 'N/A',
              },
            ],
            'images': ladingwallsImages
            // Use image paths or URLs
          },
          {
            'title': '16.6 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': landingskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingskirtingDescription ?? 'N/A',
              },
            ],
            'images': landingskirtingImages
            // Use image paths or URLs
          },
          {
            'title': '16.7 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': landingwindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingwindowSillDescription ?? 'N/A',
              },
            ],
            'images': landingwindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '16.8 Curtains',
            'details': [
              {
                'label': 'Condition',
                'value': landingcurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingcurtainsDescription ?? 'N/A',
              },
            ],
            'images': landingcurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '16.9 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': landingblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingblindsDescription ?? 'N/A',
              },
            ],
            'images': landingblindsImages
            // Use image paths or URLs
          },
          {
            'title': '16.10 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': landinglightSwitchesCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landinglightSwitchesDescription ?? 'N/A',
              },
            ],
            'images': landinglightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '16.11 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': landingsocketsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingsocketsDescription ?? 'N/A',
              },
            ],
            'images': landingsocketsImages
            // Use image paths or URLs
          },
          // {
          //   'title': '16.12 Heating',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images':   landingheatingImages
          //   // Use image paths or URLs
          // },
          {
            'title': '16.13 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': landingflooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingflooringDescription ?? 'N/A',
              },
            ],
            'images': landingflooringImages
            // Use image paths or URLs
          },
          {
            'title': '16.14 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': landingadditionalItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': landingadditionalItemsDescription ?? 'N/A',
              },
            ],
            'images': landingadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },

      {
        'title': '2. Dining Room',
        'icon': Icons.dining,
        'subItems': [
          {
            'title': '2.1 Gas Meter',
            'details': [
              {
                'label': 'Condition',
                'value': diningGasMeterCondition ?? 'N/A',
              },
            ],
            'images': diningGasMeterImages
            // Use image paths or URLs
          },
          {
            'title': '2.1 Electric Meter',
            'details': [
              {
                'label': 'Condition',
                'value': diningElectricMeterCondition ?? 'N/A',
              },
            ],
            'images': diningElectricMeterImages
            // Use image paths or URLs
          },
          {
            'title': '2.1 Water Meter',
            'details': [
              {
                'label': 'Condition',
                'value': diningWaterMeterCondition ?? 'N/A',
              },
            ],
            'images': diningWaterMeterImages
            // Use image paths or URLs
          },
          {
            'title': '2.1 Oil Meter',
            'details': [
              {
                'label': 'Condition',
                'value': diningOilMeterCondition ?? 'N/A',
              },
            ],
            'images': diningOilMeterImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '18. En-Suite',
        'icon': Icons.meeting_room,
        'subItems': [
          // {
          //   'title': '18.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '18.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitdoorCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitdoorLocation ?? 'N/A',
              },
            ],
            'images': ensuitedoorImages
            // Use image paths or URLs
          },
          {
            'title': '18.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitdoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitedoorFrameLocation ?? 'N/A',
              },
            ],
            'images': ensuitedoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '18.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteceilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitceilingLocation ?? 'N/A',
              },
            ],
            'images': ensuiteceilingImages
            // Use image paths or URLs
          },

          {
            'title': '18.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitlightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitelightingLocation ?? 'N/A',
              },
            ],
            'images': ensuitelightingImages
            // Use image paths or URLs
          },
          {
            'title': '18.7 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitewallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitewallsLocation ?? 'N/A',
              },
            ],
            'images': ensuitewallsImages
            // Use image paths or URLs
          },
          {
            'title': '18.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteskirtingLocation ?? 'N/A',
              },
            ],
            'images': ensuiteskirtingImages
            // Use image paths or URLs
          },
          {
            'title': '18.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitewindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitewindowSillLocation ?? 'N/A',
              },
            ],
            'images': ensuitewindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '18.10 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitecurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitecurtainsLocation ?? 'N/A',
              },
            ],
            'images': ensuitecurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '18.11 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteblindsLocation ?? 'N/A',
              },
            ],
            'images': ensuiteblindsImages
            // Use image paths or URLs
          },
          {
            'title': '18.12 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': ensuitelightSwitchesCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuitelightSwitchesLocation ?? 'N/A',
              },
            ],
            'images': ensuitelightSwitchesImages
            // Use image paths or URLs
          },
          {
            'title': '18.13 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteSocketCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteSocketLocation ?? 'N/A',
              },
            ],
            'images': ensuiteSocketImages
            // Use image paths or URLs
          },
          {
            'title': '18.14 Heating',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteHeatingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteHeatingLocation ?? 'N/A',
              },
            ],
            'images': ensuiteHeatingImages
            // Use image paths or URLs
          },
          {
            'title': '18.15 Shower Cubicle',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteShowerCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteShowerLocation ?? 'N/A',
              },
            ],
            'images': ensuiteShowerImages
            // Use image paths or URLs
          },
          {
            'title': '18.16 Toilet',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteToiletCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteToiletLocation ?? 'N/A',
              },
            ],
            'images': ensuiteToiletImages
            // Use image paths or URLs
          },
          {
            'title': '18.17 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteFlooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteFlooringLocation ?? 'N/A',
              },
            ],
            'images': ensuiteflooringImages
            // Use image paths or URLs
          },
          {
            'title': '18.18 Additional Items',
            'details': [
              {
                'label': 'Condition',
                'value': ensuiteAdditionItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': ensuiteAdditionItemsLocation ?? 'N/A',
              },
            ],
            'images': ensuiteadditionalItemsImages
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '13. Kitchen',
        'icon': Icons.kitchen,
        'subItems': [
          // {
          //   'title': '13.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': '13.2 Door',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenNewDoor ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenDoorDescription ?? 'N/A',
              },
            ],
            'images': kitchenDoorImages
            // Use image paths or URLs
          },
          {
            'title': '13.3 Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenDoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenDoorFrameDescription ?? 'N/A',
              },
            ],
            'images': kitchenDoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': '13.4 Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenCeilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenCeilingDescription ?? 'N/A',
              },
            ],
            'images': kitchenCeilingImages
            // Use image paths or URLs
          },
          {
            'title': '13.5 Extractor Fan',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenExtractorFanCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenExtractorFanDescription ?? 'N/A',
              },
            ],
            'images': kitchenExtractorFanImages
            // Use image paths or URLs
          },
          {
            'title': '13.6 Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenLightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenLightingDescription ?? 'N/A',
              },
            ],
            'images': kitchenLightingImages
            // Use image paths or URLs
          },
          {
            'title': '13.7 Walls',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenWallsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenWallsDescription ?? 'N/A',
              },
            ],
            'images': kitchenWallsImages
            // Use image paths or URLs
          },
          {
            'title': '13.8 Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSkirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSkirtingDescription ?? 'N/A',
              },
            ],
            'images': kitchenSkirtingImages
            // Use image paths or URLs
          },
          {
            'title': '13.9 Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenWindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenWindowSillDescription ?? 'N/A',
              },
            ],
            'images': kitchenWindowSillImages
            // Use image paths or URLs
          },
          {
            'title': '13.10 Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenCurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenCurtainsDescription ?? 'N/A',
              },
            ],
            'images': ktichenCurtainsImages
            // Use image paths or URLs
          },
          {
            'title': '13.11 Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenBlindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenBlindsDescription ?? 'N/A',
              },
            ],
            'images': kitchenBlindsImages
            // Use image paths or URLs
          },
          {
            'title': '13.12 Switch',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSwitchBoardCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSwitchBoardDescription ?? 'N/A',
              },
            ],
            'images': kitchenSwitchBoardImages
            // Use image paths or URLs
          },
          {
            'title': '13.13 Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSocketCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSocketDescription ?? 'N/A',
              },
            ],
            'images': kitchenSocketImages
            // Use image paths or URLs
          },
          {
            'title': '13.14 Heating',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenHeatingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenHeatingDescription ?? 'N/A',
              },
            ],
            'images': kitchenHeatingImages
            // Use image paths or URLs
          },
          {
            'title': '13.15 Oven',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenOvenCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenOvenDescription ?? 'N/A',
              },
            ],
            'images': kitchenOvenImages
            // Use image paths or URLs
          },
          {
            'title': '13.16 Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenFlooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenFlooringDescription ?? 'N/A',
              },
            ],
            'images': kitchenFlooringImages
            // Use image paths or URLs
          },
          {
            'title': '13.17 Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenAdditionItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenAdditionItemsDescription ?? 'N/A',
              },
            ],
            'images': kitchenAdditionItemsImages
            // Use image paths or URLs
          },

          // //13.18 Fridge
          {
            'title': 'Fridge/Freezer',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenFridgeFreezerCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenFridgeFreezerDescription ?? 'N/A',
              },
            ],
            'images': kitchenFridgeFreezerImages
            // Use image paths or URLs
          },

          // //13.21 Dishwasher
          {
            'title': 'Dishwasher',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenDishwasherCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenDishwasherDescription ?? 'N/A',
              },
            ],
            'images': kitchenDishwasherImages
            // Use image paths or URLs
          },

          // //13.24 Hob
          {
            'title': 'Hob',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenHobCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenHobDescription ?? 'N/A',
              },
            ],
            'images': kitchenHobImages
            // Use image paths or URLs
          },
          //Cooker
          {
            'title': 'Cooker',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenCookerCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenCookerDescription ?? 'N/A',
              },
            ],
            'images': kitchenCookerImages
            // Use image paths or URLs
          },

          //kitchen units
          {
            'title': 'Hob',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenHobCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenHobDescription ?? 'N/A',
              },
            ],
            'images': kitchenHobImages
            // Use image paths or URLs
          },
          //13.25 Extractor Fan
          {
            'title': 'Extractor Hood',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenExtractorFanCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenExtractorFanDescription ?? 'N/A',
              },
            ],
            'images': kitchenExtractorFanImages
            // Use image paths or URLs
          },

          //13.26 Sink
          {
            'title': 'Sink',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenSinkCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenSinkDescription ?? 'N/A',
              },
            ],
            'images': kitchenSinkImages
            // Use image paths or URLs
          },

          // // 13.27 Tap

          // //13.28 Worktop

          //13.31 Additional Items/ Information
          {
            'title': 'Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': kitchenAdditionItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': kitchenAccessoriesDescription ?? 'N/A',
              },
            ],
            'images': kitchenAdditionItemsImages

            // Use image paths or URLs
          },
        ],
      },
      //Bathroom
      {
        'title': '14. Bathroom',
        'icon': Icons.bathtub,
        'subItems': [
          // {
          //   'title': '13.1 Overview',
          //   'details': [
          //     {'label': 'Condition', 'value': 'Good'},
          //   ],
          //   'images': ['path_to_image5', 'path_to_image6']
          //   // Use image paths or URLs
          // },
          {
            'title': 'Door',
            'details': [
              {
                'label': 'Condition',
                'value':  bathroomdoorCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value':  bathroomdoorDescription ?? 'N/A',
              },
            ],
            'images':   bathroomdoorImages
            // Use image paths or URLs
          },
          {
            'title': 'Door Frame',
            'details': [
              {
                'label': 'Condition',
                'value':  bathroomdoorFrameCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomdoorFrameDescription ?? 'N/A',
              },
            ],
            'images': bathroomdoorFrameImages
            // Use image paths or URLs
          },
          {
            'title': 'Ceiling',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomceilingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomceilingDescription ?? 'N/A',
              },
            ],
            'images': bathroomceilingImages
            // Use image paths or URLs
          },
          {
            'title': 'Extractor Fan',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomextractorFanCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomextractorFanDescription ?? 'N/A',
              },
            ],
            'images': bathroomextractorFanImages
            // Use image paths or URLs
          },
          {
            'title': 'Lighting',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomlightingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomlightingDescription ?? 'N/A',
              },
            ],
            'images': bathroomlightingImages
            // Use image paths or URLs
          },
          // {
          //   'title': 'Walls',
          //   'details': [
          //     {
          //       'label': 'Condition',
          //       'value': bathroomwallsCondition ?? 'N/A',
          //     },
          //     {
          //       'label': 'Additional Comments',
          //       'value': bathroomwallsDescription ?? 'N/A',
          //     },
          //   ],
          //   'images': bathroomwallsImages
          //   // Use image paths or URLs
          // },
          {
            'title': 'Skirting',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomskirtingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomskirtingDescription ?? 'N/A',
              },
            ],
            'images': bathroomskirtingImages
            // Use image paths or URLs
          },
          {
            'title': 'Window(s)/Sill',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomwindowSillCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomwindowSillDescription ?? 'N/A',
              },
            ],
            'images': bathroomwindowSillImages
            // Use image paths or URLs
          },
          {
            'title': 'Curtain',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomcurtainsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomcurtainsDescription ?? 'N/A',
              },
            ],
            'images': bathroomcurtainsImages
            // Use image paths or URLs
          },

          {
            'title': 'Blinds',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomblindsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomblindsDescription ?? 'N/A',
              },
            ],
            'images': bathroomblindsImages
            // Use image paths or URLs
          },
          {
            'title': 'Switch',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomswitchBoardCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomswitchBoardDescription ?? 'N/A',
              },
            ],
            'images': bathroomswitchBoardImages
            // Use image paths or URLs
          },
          {
            'title': 'Sockets',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomsocketCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomsocketDescription ?? 'N/A',
              },
            ],
            'images': bathroomsocketImages
            // Use image paths or URLs
          },
          {
            'title': 'Heating',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomheatingCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomheatingDescription ?? 'N/A',
              },
            ],
            'images':   bathroomheatingImages
            // Use image paths or URLs
          },
          {
            'title': 'Shower Cubicle',
            'details': [
              {
                'label': 'Condition',
                'value':  bathroombathCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroombathDescription ?? 'N/A',
              },
            ],
            'images': bathroombathImages
            // Use image paths or URLs
          },
          {
            'title': 'Toilet',
            'details': [
              {
                'label': 'Condition',
                'value':  bathroomtoiletCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomtoiletDescription ?? 'N/A',
              },
            ],
            'images': bathroomtoiletImages
            // Use image paths or URLs
          },

          {
            'title': 'Flooring',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomflooringCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomflooringDescription ?? 'N/A',
              },
            ],
            'images': bathroomflooringImages
            // Use image paths or URLs
          },

          {
            'title': 'Additional Items/ Information',
            'details': [
              {
                'label': 'Condition',
                'value': bathroomadditionItemsCondition ?? 'N/A',
              },
              {
                'label': 'Additional Comments',
                'value': bathroomadditionItemsDescription ?? 'N/A',
              },
            ],
            'images': bathroomadditionItemsImages
            // Use image paths or URLs
          },


        ]
      }
      // Add more headings here
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inspection Confirmation'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingScreen(),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: kPrimaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                sendPropertyData(
                    context, property); // Link the save button to the function
              },
              child: Icon(
                Icons.save,
                size: 20,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // Prevents ListView from scrolling independently
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ExpansionTile(
                      title: Text(item['title']),
                      leading: Icon(
                        item['icon'],
                        color: kPrimaryColor,
                      ),
                      children: item['subItems'].map<Widget>((subItem) {
                        return ExpansionTile(
                          title: Text(subItem['title']),
                          children: [
                            Column(
                              children:
                              subItem['details'].map<Widget>((detail) {
                                return ListTile(
                                  title: Text(detail['label']),
                                  subtitle: Text(detail['value']),
                                );
                              }).toList(),
                            ),
                            Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subItem['images'].length,
                                itemBuilder: (context, imgIndex) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    width: 100,
                                    child: Image.network(
                                      subItem['images'][imgIndex],
                                      fit: BoxFit.cover,
                                    ), // Use Image.network() for URLs
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Text('Declaration',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                const Text(
                    'I/We the undersigned, affirm  that if I/we do not'
                        ' comment on the inventory in writing within seven days '
                        'of receipt of this inventory I/We accept the inventory '
                        'as being an accurate record of the contents and '
                        'conditions of the property',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: kPrimaryTextColourTwo,
                      fontSize: 12, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                const Text('Please put the signature here',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14, // Adjust the font size
                      fontFamily: "Inter",
                    )),
                const SizedBox(height: 15),
                Card(
                  child: Center(
                    child: Signature(
                      height: 200,
                      width: double.maxFinite,
                      controller: controller!,
                      backgroundColor: bWhite,
                    ),
                  ),
                ),
                buttonWidgets(context)!,
                const SizedBox(height: 30),
                signature != null
                    ? Column(
                  children: [
                    Center(child: Image.memory(signature!)),
                    const SizedBox(height: 10),
                    MaterialButton(
                      color: Colors.green,
                      onPressed: () {},
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buttonWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            controller?.clear();
            setState(() {
              signature = null;
            });
          },
          child: const Text("Re-Sign",
              style: TextStyle(fontSize: 20, color: Colors.redAccent)),
        ),
      ],
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: controller!.points,
    );

    final signature = exportController.toPngBytes();

    //clean up the memory
    exportController.dispose();

    return signature;
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
