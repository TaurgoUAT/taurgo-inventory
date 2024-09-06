import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';
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

  const InspectionConfimationPage({super.key, required this.propertyId});

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

  //SOC
  String? overview;
  String? accessoryCleanliness;
  String? windowSill;
  String? carpets;
  String? ceilings;
  String? curtains;
  String? hardFlooring;
  String? kitchenArea;
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
  List<String> ovenImages = [];
  List<String> mattressImages = [];
  List<String> upholstreyImages = [];
  List<String> wallImages = [];
  List<String> windowImages = [];
  List<String> woodworkImages = [];

  //EV Charger
  String? evChargerDescription;
  List<String> evChargerImages = [];

  //Meter Reading
  String? gasMeterReading;
  String? electricMeterReading;
  String? waterMeterReading;
  String? oilMeterReading;
  String? otherMeterReading;

  List<String> gasMeterImages = [];
  List<String> electricMeterImages = [];
  List<String> waterMeterImages = [];
  List<String> oilMeterImages = [];
  List<String> otherMeterImages = [];

  //Keys
  String? yaleLocation;
  String? yaleReading;
  String? morticeLocation;
  String? morticeReading;
  String? windowLockLocation;
  String? windowLockReading;
  String? gasMeterLocation;

  // String? gasMeterReading;
  String? carPassLocation;
  String? carPassReading;
  String? remoteLocation;
  String? remoteReading;
  String? otherLocation;
  String? otherReading;
  List<String> yaleImages = [];
  List<String> morticeImages = [];
  List<String> windowLockImages = [];
  // List<String> gasMeterImages = [];
  List<String> carPassImages = [];
  List<String> remoteImages = [];
  List<String> otherImages = [];

  //Keys Handed Over
  String? yale;
  String? mortice;
  String? other;
  List<String> keysHandOverYaleImages = [];
  List<String> keysHandOverMorticeImages = [];
  List<String> keysHandOverOtherImages = [];

  //Health and Safety
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

  //Front Garden
  String? driveWayCondition;
  String? driveWayDescription;
  String? outsideLightingCondition;
  String? outsideLightingDescription;
  String? additionalItemsCondition;
  String? additionalItemsDescription;
  List<String> driveWayImages = [];
  List<String> outsideLightingImages = [];
  List<String> additionalItemsImages = [];

  //Garage
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

  //Exterior Front
  String? ExteriorFrontDoorCondition;
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
  String? entranceSocketsCondition;
  String? entranceSocketsLocation;
  String? entranceFlooringCondition;
  String? entranceFlooringLocation;
  String? entranceAdditionalItemsCondition;
  String? entranceAdditionalItemsLocation;
  // String? entranceDoorImagePaths;
  // String? doorFrameImagePaths;
  // String? ceilingImagePaths;
  // String? lightingImagePaths;
  // String? wallsImagePaths;
  // String? skirtingImagePaths;
  // String? windowSillImagePaths;
  // String? curtainsImagePaths;
  // String? blindsImagePaths;
  // String? lightSwitchesImagePaths;
  // String? socketsImagePaths;
  // String? flooringImagePaths;
  // String? additionalItemsImagePaths;

  List<String> entranceDoorImages = [];
  List<String> entranceDoorFrameImages = [];
  List<String> entranceCeilingImages = [];
  List<String> entranceLightingImages = [];
  List<String> entranceWallsImages = [];
  List<String> entranceSkirtingImages = [];
  List<String> entranceWindowSillImages = [];
  List<String> entranceCurtainsImages = [];
  List<String> entranceBlindsImages = [];
  List<String> entranceLightSwitchesImages = [];
  List<String> entranceSocketsImages = [];
  List<String> entranceFlooringImages = [];
  List<String> entranceAdditionalItemsImages = [];

  //Toilet
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
  // String? doorImagePath;
  // String? doorFrameImagePath;
  // String? ceilingImagePath;
  // String? extractorFanImagePath;
  // String? lightingImagePath;
  // String? wallsImagePath;
  // String? skirtingImagePath;
  // String? windowSillImagePath;
  // String? curtainsImagePath;
  // String? blindsImagePath;
  // String? toiletImagePath;
  // String? basinImagePath;
  // String? showerCubicleImagePath;
  // String? bathImagePath;
  // String? switchBoardImagePath;
  // String? socketImagePath;
  // String? heatingImagePath;
  // String? accessoriesImagePath;
  // String? flooringImagePath;
  // String? additionalItemsImagePath;
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
  List<String> toileFflooringImages = [];
  List<String> toiletAdditionalItemsImages = [];

  //Lounge
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


  //Dining Room
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

  //Ensuite
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
  String? ensuitesocketsCondition;
  String? ensuitesocketsLocation;
  String? ensuiteflooringCondition;
  String? ensuiteflooringLocation;
  String? ensuiteadditionalItemsCondition;
  String? ensuiteadditionalItemsLocation;
  List<String> ensuitedoorImages = [];
  List<String> ensuitedoorFrameImages = [];
  List<String> ensuiteceilingImages = [];
  List<String> ensuitelightingImages = [];
  List<String> ensuitewallsImages = [];
  List<String> ensuiteskirtingImages = [];
  List<String> ensuitewindowSillImages = [];
  List<String> ensuitecurtainsImages = [];
  List<String> ensuiteblindsImages = [];
  List<String> ensuitelightSwitchesImages = [];
  List<String> ensuitesocketsImages = [];
  List<String> ensuiteflooringImages = [];
  List<String> ensuiteadditionalItemsImages = [];
  //Kitchen

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
  String? kitchenWallsCondition;
  String? kitchenWallsDescription;
  String? kitchenSkirtingCondition;
  String? kitchenSkirtingDescription;
  String? kitchenWindowSillCondition;
  String? kitchenWindowSillDescription;
  String? kitchenCurtainsCondition;
  String? kitchenCurtainsDescription;
  String? kitchenBlindsCondition;
  String? kitchenBlindsDescription;
  String? kitchenToiletCondition;
  String? kitchenToiletDescription;
  String? kitchenBasinCondition;
  String? kitchenBasinDescription;
  String? kitchenShowerCubicleCondition;
  String? kitchenShowerCubicleDescription;
  String? kitchenBathCondition;
  String? kitchenBathDescription;
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
  String? kitchenAdditionItemsCondition;
  String? kitchenAdditionItemsDescription;
  List<String> kitchenDoorImages = [];
  List<String> kitchenDoorFrameImages = [];
  List<String> kitchenCeilingImages = [];
  List<String> kitchenExtractorFanImages = [];
  List<String> kitchenLightingImages = [];
  List<String> kitchenWallsImages = [];
  List<String> kitchenSkirtingImages = [];
  List<String> kitchenWindowSillImages = [];
  List<String> ktichenCurtainsImages = [];
  List<String> kitchenBlindsImages = [];
  List<String> kitchenToiletImages = [];
  List<String> kitchenBasinImages = [];
  List<String> kitchenShowerCubicleImages = [];
  List<String> kitchenBathImages = [];
  List<String> kitchenSwitchBoardImages = [];
  List<String> kitchenSocketImages = [];
  List<String> kitchenHeatingImages = [];
  List<String> kitchenAccessoriesImages = [];
  List<String> kitchenFlooringImages = [];
  List<String> kitchenAdditionItemsImages = [];

  //Landing
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

  //Bedroom
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
  // String? bedRoomDoorImage;
  // String? doorFrameImage;
  // String? ceilingImage;
  // String? lightingImage;
  // String? wallsImage;
  // String? skirtingImage;
  // String? windowSillImage;
  // String? curtainsImage;
  // String? blindsImage;
  // String? lightSwitchesImage;
  // String? socketsImage;
  // String? flooringImage;
  // String? additionalItemsImage;
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

  // REar Garden
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
  List<String> stairslooringImages = [];
  List<String> stairsadditionalItemsImages = [];
  //Manuals and Certificates

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

  //Bath Room
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
  List<String> bathroomaccessoriesImages = [];
  List<String> bathroomflooringImages = [];
  List<String> bathroomadditionItemsImages = [];
  @override
  void initState() {
    super.initState();
    fetchProperties();
    getFirebaseUserId();
    // fetchProperties();
    controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
    getSharedPreferencesData();
    print(overview);
    _loadPreferences(widget.propertyId);
  }

  Future<void> _loadPreferences(String propertyId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      //SOC
      overview = prefs.getString('overview_${propertyId}' ?? "N/A");

      accessoryCleanliness =
          prefs.getString('accessoryCleanliness_${propertyId}' ?? "N/A");
      windowSill = prefs.getString('windowSill_${propertyId}' ?? "N/A");
      carpets = prefs.getString('carpets_${propertyId}');
      ceilings = prefs.getString('ceilings_${propertyId}');
      curtains = prefs.getString('curtains_${propertyId}');
      hardFlooring = prefs.getString('hardFlooring_${propertyId}');
      kitchenArea = prefs.getString('kitchenArea_${propertyId}');
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

      //Ev Charger
      evChargerDescription = prefs.getString
        ('evChargerDescription_${propertyId}');

      evChargerImages = prefs.getStringList('evChargerImages_${propertyId}')
          ?? [];

      //Metr Reading
      gasMeterReading =
          prefs.getString('gasMeterReading${propertyId}');
      electricMeterReading =
          prefs.getString('electricMeterReading${propertyId}');
      waterMeterReading =
          prefs.getString('waterMeterReading${propertyId}');
      oilMeterReading =
          prefs.getString('oilMeterReading${propertyId}');
      otherMeterReading =
          prefs.getString('otherMeterReading${propertyId}');

      waterMeterImages =
          prefs.getStringList('waterMeterImages${propertyId}') ?? [];
      electricMeterImages =
          prefs.getStringList('electricMeterImages${propertyId}') ?? [];
      waterMeterImages = prefs.getStringList('waterMeterImages${propertyId}') ?? [];
      oilMeterImages =
          prefs.getStringList('oilMeterImages${propertyId}') ?? [];
      otherMeterImages =
          prefs.getStringList('otherMeterImages${propertyId}') ?? [];


      //Keys
      yaleLocation = prefs.getString('yaleLocation_${propertyId}');
      yaleReading = prefs.getString('yaleReading_${propertyId}');
      morticeLocation = prefs.getString('morticeLocation_${propertyId}');
      morticeReading = prefs.getString('morticeReading_${propertyId}');
      windowLockLocation = prefs.getString('windowLockLocation_${propertyId}');
      windowLockReading = prefs.getString('windowLockReading_${propertyId}');
      gasMeterLocation = prefs.getString('gasMeterLocation_${propertyId}');
      gasMeterReading = prefs.getString('gasMeterReading_${propertyId}');
      carPassLocation = prefs.getString('carPassLocation_${propertyId}');
      carPassReading = prefs.getString('carPassReading_${propertyId}');
      remoteLocation = prefs.getString('remoteLocation_${propertyId}');
      remoteReading = prefs.getString('remoteReading_${propertyId}');
      otherLocation = prefs.getString('otherLocation_${propertyId}');
      otherReading = prefs.getString('otherReading_${propertyId}');

      yaleImages = prefs.getStringList('yaleImages_${propertyId}') ?? [];
      morticeImages = prefs.getStringList('morticeImages_${propertyId}') ?? [];
      windowLockImages = prefs.getStringList('windowLockImages_${propertyId}') ?? [];
      gasMeterImages = prefs.getStringList('gasMeterImages_${propertyId}') ?? [];
      carPassImages = prefs.getStringList('carPassImages_${propertyId}') ?? [];
      remoteImages = prefs.getStringList('remoteImages_${propertyId}') ?? [];
      otherImages = prefs.getStringList('otherImages_${propertyId}') ?? [];

      //Keys Hand Over
      yale = prefs.getString('yale_${propertyId}');
      mortice = prefs.getString('mortice_${propertyId}');
      other = prefs.getString('other_${propertyId}');

      keysHandOverYaleImages = prefs.getStringList
        ('yaleImages_${propertyId}') ?? [];
      keysHandOverMorticeImages = prefs.getStringList
        ('morticeImages_${propertyId}') ?? [];
      keysHandOverOtherImages = prefs.getStringList
        ('otherImages_${propertyId}') ?? [];

      //Health and Safety
      heatSensorCondition = prefs.getString('heatSensorCondition_${propertyId}');
      heatSensorDescription = prefs.getString('heatSensorDescription_${propertyId}');
      smokeAlarmCondition = prefs.getString('smokeAlarmCondition_${propertyId}');
      smokeAlarmDescription = prefs.getString('smokeAlarmDescription_${propertyId}');
      carbonMonoxideCondition = prefs.getString('carbonMonoxideCondition_${propertyId}');
      carbonMonoxideDescription = prefs.getString('carbonMonoxideDescription_${propertyId}');
      smokeAlarmImages = prefs.getStringList('smokeAlarmImages_${propertyId}') ?? [];
      heatSensorImages = prefs.getStringList('heatSensorImages_${propertyId}') ?? [];
      carbonMonxideImages = prefs.getStringList('carbonMonxideImages_${propertyId}') ?? [];
      //Front Garden
      driveWayCondition = prefs.getString('driveWayCondition_${propertyId}');
      driveWayDescription = prefs.getString('driveWayDescription_${propertyId}');
      outsideLightingCondition = prefs.getString('outsideLightingCondition_${propertyId}');
      outsideLightingDescription = prefs.getString('outsideLightingDescription_${propertyId}');
      additionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      additionalItemsDescription = prefs.getString('additionalItemsDescription_${propertyId}');

      driveWayImages = prefs.getStringList('driveWayImages_${propertyId}') ?? [];
      outsideLightingImages = prefs.getStringList('outsideLightingImages_${propertyId}') ?? [];
      additionalItemsImages = prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      //Garage
      newdoor = prefs.getString('newdoor_${propertyId}');
      garageDoorCondition = prefs.getString('doorCondition_${propertyId}');
      garageDoorDescription = prefs.getString('doorDescription_${propertyId}');
      garageDoorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      garageDoorFrameDescription = prefs.getString('doorFrameDescription_${propertyId}');
      garageceilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      garageceilingDescription = prefs.getString('ceilingDescription_${propertyId}');
      garagelightingCondition = prefs.getString('lightingCondition_${propertyId}');
      garagelightingDescription = prefs.getString('lightingDescription_${propertyId}');
      garagewallsCondition = prefs.getString('wallsCondition_${propertyId}');
      garagewallsDescription = prefs.getString('wallsDescription_${propertyId}');
      garageskirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      garageskirtingDescription = prefs.getString('skirtingDescription_${propertyId}');
      garagewindowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      garagewindowSillDescription = prefs.getString('windowSillDescription_${propertyId}');
      garagecurtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      garagecurtainsDescription = prefs.getString('curtainsDescription_${propertyId}');
      garageblindsCondition = prefs.getString('blindsCondition_${propertyId}');
      garageblindsDescription = prefs.getString('blindsDescription_${propertyId}');
      garagelightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      garagelightSwitchesDescription = prefs.getString('lightSwitchesDescription_${propertyId}');
      garagesocketsCondition = prefs.getString('socketsCondition_${propertyId}');
      garagesocketsDescription = prefs.getString('socketsDescription_${propertyId}');
      garageflooringCondition = prefs.getString('flooringCondition_${propertyId}');
      garageflooringDescription = prefs.getString('flooringDescription_${propertyId}');
      garageadditionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      garageadditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');

      garagedoorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      garageceilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      garagelightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      garagewallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      garageskirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      garagewindowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      garagecurtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      garageblindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      garagelightSwitchesImages = prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      garagesocketsImages = prefs.getStringList('socketsImages_${propertyId}') ?? [];
      garageflooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      garageadditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      //Exterior Front
      ExteriorFrontDoorCondition = prefs.getString('doorCondition');
      exteriorFrontDoorDescription = prefs.getString('doorDescription');
      exteriorFrontDoorFrameCondition = prefs.getString('doorFrameCondition');
      exteriorFrontDoorFrameDescription = prefs.getString('doorFrameDescription');
      exteriorFrontPorchCondition = prefs.getString('porchCondition');
      exteriorFrontPorchDescription = prefs.getString('porchDescription');
      exteriorFrontAdditionalItemsCondition = prefs.getString('additionalItemsCondition');
      exteriorFrontAdditionalItemsDescription = prefs.getString('additionalItemsDescription');

      exteriorFrontDoorImages = prefs.getStringList('doorImages') ?? [];
      exteriorFrontDoorFrameImages = prefs.getStringList('doorFrameImages') ?? [];
      exteriorFrontPorchImages = prefs.getStringList('porchImages') ?? [];
      exteriorFrontAdditionalItemsImages = prefs.getStringList('additionalItemsImages') ?? [];

      //Entrance
      entranceDoorCondition = prefs.getString('doorCondition_${propertyId}');
      entranceDoorLocation = prefs.getString('doorLocation_${propertyId}');
      entranceDoorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      entranceDoorFrameLocation = prefs.getString('doorFrameLocation_${propertyId}');
      entranceCeilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      entranceCeilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      entranceLightingCondition = prefs.getString('lightingCondition_${propertyId}');
      entranceLightingLocation = prefs.getString('lightingLocation_${propertyId}');
      entranceWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      entranceWallsLocation = prefs.getString('wallsLocation_${propertyId}');
      entranceSkirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      entranceSkirtingLocation = prefs.getString('skirtingLocation_${propertyId}');
      entranceWindowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      entranceWindowSillLocation = prefs.getString('windowSillLocation_${propertyId}');
      entranceCurtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      entranceCurtainsLocation = prefs.getString('curtainsLocation_${propertyId}');
      entranceBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      entranceBlindsLocation = prefs.getString('blindsLocation_${propertyId}');
      entranceLightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      entranceLightSwitchesLocation = prefs.getString('lightSwitchesLocation_${propertyId}');
      entranceSocketsCondition = prefs.getString('socketsCondition_${propertyId}');
      entranceSocketsLocation = prefs.getString('socketsLocation_${propertyId}');
      entranceFlooringCondition = prefs.getString('flooringCondition_${propertyId}');
      entranceFlooringLocation = prefs.getString('flooringLocation_${propertyId}');
      entranceAdditionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      entranceAdditionalItemsLocation = prefs.getString('additionalItemsLocation_${propertyId}');

      entranceDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      entranceDoorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      entranceCeilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      entranceLightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      entranceWallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      entranceSkirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      entranceWindowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      entranceCurtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      entranceBlindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      entranceLightSwitchesImages = prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      entranceSocketsImages = prefs.getStringList('socketsImages_${propertyId}') ?? [];
      entranceFlooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      entranceAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      //Toilet
      toiletDoorCondition = prefs.getString('doorCondition_${propertyId}');
      toiletDoorDescription = prefs.getString('doorDescription_${propertyId}');
      toiletDoorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      toiletDoorFrameDescription = prefs.getString('doorFrameDescription_${propertyId}');
      toiletCeilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      toiletCeilingDescription = prefs.getString('ceilingDescription_${propertyId}');
      toiletExtractorFanCondition = prefs.getString('extractorFanCondition_${propertyId}');
      toiletExtractorFanDescription = prefs.getString('extractorFanDescription_${propertyId}');
      toiletLightingCondition = prefs.getString('lightingCondition_${propertyId}');
      toiletLightingDescription = prefs.getString('lightingDescriptionv_${propertyId}');
      toiletWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      toiletWallsDescription = prefs.getString('wallsDescription_${propertyId}');
      toiletSkirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      toiletSkirtingDescription = prefs.getString('skirtingDescription_${propertyId}');
      toiletWindowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      toiletwWindowSillDescription = prefs.getString('windowSillDescription_${propertyId}');
      toiletCurtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      toiletCurtainsDescription = prefs.getString('curtainsDescription_${propertyId}');
      toiletBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      toiletBlindsDescription = prefs.getString('blindsDescription_${propertyId}');
      toiletToiletCondition = prefs.getString('toiletCondition_${propertyId}');
      toiletToiletDescription = prefs.getString('toiletDescription_${propertyId}');
      toiletBasinCondition = prefs.getString('basinCondition_${propertyId}');
      toiletBasinDescription = prefs.getString('basinDescription_${propertyId}');
      toiletShowerCubicleCondition = prefs.getString('showerCubicleCondition_${propertyId}');
      toiletShowerCubicleDescription = prefs.getString('showerCubicleDescription_${propertyId}');
      toiletBathCondition = prefs.getString('bathCondition_${propertyId}');
      toiletBathDescription = prefs.getString('bathDescription_${propertyId}');
      toiletSwitchBoardCondition = prefs.getString('switchBoardCondition_${propertyId}');
      toiletSwitchBoardDescription = prefs.getString('switchBoardDescription_${propertyId}');
      toiletSocketCondition = prefs.getString('socketCondition_${propertyId}');
      toiletSocketDescription = prefs.getString('socketDescription_${propertyId}');
      toiletHeatingCondition = prefs.getString('heatingCondition_${propertyId}');
      toiletHeatingDescription = prefs.getString('heatingDescription_${propertyId}');
      toiletAccessoriesCondition = prefs.getString('accessoriesCondition_${propertyId}');
      toiletAccessoriesDescription = prefs.getString('accessoriesDescription_${propertyId}');
      toiletFlooringCondition = prefs.getString('flooringCondition_${propertyId}');
      toiletFlooringDescription = prefs.getString('flooringDescription_${propertyId}');
      toiletAdditionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      toiletAdditionalItemsDescription =
          prefs.getString('additionalItemsDescription_${propertyId}');
      toiletDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      toiletDoorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      toiletCeilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      toiletExtractorFanImages = prefs.getStringList('extractorFanImages_${propertyId}') ?? [];
      toiletlLightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      toiletWallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      toiletSkirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      toiletWindowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      toiletCurtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      toiletBlindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      toiletToiletImages = prefs.getStringList('toiletImages_${propertyId}') ?? [];
      toiletBasinImages = prefs.getStringList('basinImages_${propertyId}') ?? [];
      toiletShowerCubicleImages = prefs.getStringList('showerCubicleImages_${propertyId}') ?? [];
      toiletBathImages = prefs.getStringList('bathImages_${propertyId}') ?? [];
      toiletSwitchBoardImages = prefs.getStringList('switchBoardImages_${propertyId}') ?? [];
      toiletSocketImages = prefs.getStringList('socketImages_${propertyId}') ?? [];
      toiletHeatingImages = prefs.getStringList('heatingImages_${propertyId}') ?? [];
      toiletAccessoriesImages = prefs.getStringList('accessoriesImages_${propertyId}') ?? [];
      toileFflooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      toiletAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];


      //Lounge
      lougeDoorCondition = prefs.getString('doorCondition_${propertyId}');
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

      loungedoorImages =
          prefs.getStringList('loungedoorImages_${propertyId}') ?? [];
      loungedoorFrameImages =
          prefs.getStringList('loungedoorFrameImages_${propertyId}') ?? [];
      loungeceilingImages =
          prefs.getStringList('loungeceilingImages_${propertyId}') ?? [];
      loungelightingImages =
          prefs.getStringList('loungelightingImages_${propertyId}') ?? [];
      loungewallsImages =
          prefs.getStringList('loungewallsImages_${propertyId}') ?? [];
      loungeskirtingImages =
          prefs.getStringList('loungeskirtingImages_${propertyId}') ?? [];
      loungewindowSillImages =
          prefs.getStringList('loungewindowSillImages_${propertyId}') ?? [];
      loungecurtainsImages =
          prefs.getStringList('loungecurtainsImages_${propertyId}') ?? [];
      loungeblindsImages =
          prefs.getStringList('loungeblindsImages_${propertyId}') ?? [];
      loungelightSwitchesImages =
          prefs.getStringList('loungelightSwitchesImages_${propertyId}') ?? [];
      loungesocketsImages =
          prefs.getStringList('loungesocketsImages_${propertyId}') ?? [];
      loungeflooringImages =
          prefs.getStringList('loungeflooringImages_${propertyId}') ?? [];
      loungeadditionalItemsImages =
          prefs.getStringList('loungeadditionalItemsImages_${propertyId}') ??
              [];

      //Dining Room
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

      //En Suite
      ensuitdoorCondition = prefs.getString('ensuitdoorCondition');
      ensuitdoorLocation = prefs.getString('ensuitdoorLocation');
      ensuitdoorFrameCondition = prefs.getString('ensuitdoorFrameCondition');
      ensuitedoorFrameLocation = prefs.getString('ensuitedoorFrameLocation');
      ensuiteceilingCondition = prefs.getString('ensuiteceilingCondition');
      ensuitceilingLocation = prefs.getString('ensuitceilingLocation');
      ensuitlightingCondition = prefs.getString('ensuitlightingCondition');
      ensuitelightingLocation = prefs.getString('ensuitelightingLocation');
      ensuitewallsCondition = prefs.getString('ensuitewallsCondition');
      ensuitewallsLocation = prefs.getString('ensuitewallsLocation');
      ensuiteskirtingCondition = prefs.getString('ensuiteskirtingCondition');
      ensuiteskirtingLocation = prefs.getString('ensuiteskirtingLocation');
      ensuitewindowSillCondition =
          prefs.getString('ensuitewindowSillCondition');
      ensuitewindowSillLocation = prefs.getString('ensuitewindowSillLocation');
      ensuitecurtainsCondition = prefs.getString('ensuitecurtainsCondition');
      ensuitecurtainsLocation = prefs.getString('ensuitecurtainsLocation');
      ensuiteblindsCondition = prefs.getString('ensuiteblindsCondition');
      ensuiteblindsLocation = prefs.getString('ensuiteblindsLocation');
      ensuitelightSwitchesCondition =
          prefs.getString('ensuitelightSwitchesCondition');
      ensuitelightSwitchesLocation =
          prefs.getString('ensuitelightSwitchesLocation');
      ensuitesocketsCondition = prefs.getString('ensuitesocketsCondition');
      ensuitesocketsLocation = prefs.getString('ensuitesocketsLocation');
      ensuiteflooringCondition = prefs.getString('ensuiteflooringCondition');
      ensuiteflooringLocation = prefs.getString('ensuiteflooringLocation');
      ensuiteadditionalItemsCondition =
          prefs.getString('ensuiteadditionalItemsCondition');
      ensuiteadditionalItemsLocation =
          prefs.getString('ensuiteadditionalItemsLocation');

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
      ensuitesocketsImages = prefs.getStringList('ensuitesocketsImages') ?? [];
      ensuiteflooringImages =
          prefs.getStringList('ensuiteflooringImages') ?? [];
      ensuiteadditionalItemsImages =
          prefs.getStringList('ensuiteadditionalItemsImages') ?? [];


      //Kitchen
      kitchenNewDoor = prefs.getString('kitchenNewDoor_${propertyId}');
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
      kitchenExtractorFanCondition =
          prefs.getString('kitchenExtractorFanCondition_${propertyId}');
      kitchenExtractorFanDescription =
          prefs.getString('kitchenExtractorFanDescription_${propertyId}');
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
      kitchenToiletCondition =
          prefs.getString('kitchenToiletCondition_${propertyId}');
      kitchenToiletDescription =
          prefs.getString('kitchenToiletDescription_${propertyId}');
      kitchenBasinCondition =
          prefs.getString('kitchenBasinCondition_${propertyId}');
      kitchenBasinDescription =
          prefs.getString('kitchenBasinDescription_${propertyId}');
      kitchenShowerCubicleCondition =
          prefs.getString('kitchenShowerCubicleCondition_${propertyId}');
      kitchenShowerCubicleDescription =
          prefs.getString('kitchenShowerCubicleDescription_${propertyId}');
      kitchenBathCondition =
          prefs.getString('kitchenBathCondition_${propertyId}');
      kitchenBathDescription =
          prefs.getString('kitchenBathDescription_${propertyId}');
      kitchenSwitchBoardCondition =
          prefs.getString('kitchenSwitchBoardCondition_${propertyId}');
      kitchenSwitchBoardDescription =
          prefs.getString('kitchenSwitchBoardDescription_${propertyId}');
      kitchenSocketCondition =
          prefs.getString('kitchenSocketCondition_${propertyId}');
      kitchenSocketDescription =
          prefs.getString('kitchenSocketDescription_${propertyId}');
      kitchenHeatingCondition =
          prefs.getString('kitchenHeatingCondition_${propertyId}');
      kitchenHeatingDescription =
          prefs.getString('kitchenHeatingDescription_${propertyId}');
      kitchenAccessoriesCondition =
          prefs.getString('kitchenAccessoriesCondition_${propertyId}');
      kitchenAccessoriesDescription =
          prefs.getString('kitchenAccessoriesDescription_${propertyId}');
      kitchenFlooringCondition =
          prefs.getString('kitchenFlooringCondition_${propertyId}');
      kitchenFlooringDescription =
          prefs.getString('kitchenFlooringDescription_${propertyId}');
      kitchenAdditionItemsCondition =
          prefs.getString('kitchenAdditionItemsCondition_${propertyId}');
      kitchenAdditionItemsDescription =
          prefs.getString('kitchenAdditionItemsDescription_${propertyId}');

      kitchenDoorImages =
          prefs.getStringList('kitchenDoorImages_${propertyId}') ?? [];
      kitchenDoorFrameImages =
          prefs.getStringList('kitchenDoorFrameImages_${propertyId}') ?? [];
      kitchenCeilingImages =
          prefs.getStringList('kitchenCeilingImages_${propertyId}') ?? [];
      kitchenExtractorFanImages =
          prefs.getStringList('kitchenExtractorFanImages_${propertyId}') ?? [];
      kitchenLightingImages =
          prefs.getStringList('kitchenLightingImages_${propertyId}') ?? [];
      kitchenWallsImages =
          prefs.getStringList('kitchenWallsImages_${propertyId}') ?? [];
      kitchenSkirtingImages =
          prefs.getStringList('kitchenSkirtingImages_${propertyId}') ?? [];
      kitchenWindowSillImages =
          prefs.getStringList('kitchenWindowSillImages_${propertyId}') ?? [];
      ktichenCurtainsImages =
          prefs.getStringList('ktichenCurtainsImages_${propertyId}') ?? [];
      kitchenBlindsImages =
          prefs.getStringList('blindsImages_${propertyId}') ?? [];
      kitchenToiletImages =
          prefs.getStringList('kitchenToiletImages_${propertyId}') ?? [];
      kitchenBasinImages =
          prefs.getStringList('kitchenBasinImages_${propertyId}') ?? [];
      kitchenShowerCubicleImages =
          prefs.getStringList('kitchenShowerCubicleImages_${propertyId}') ?? [];
      kitchenBathImages =
          prefs.getStringList('kitchenBathImages_${propertyId}') ?? [];
      kitchenSwitchBoardImages =
          prefs.getStringList('kitchenSwitchBoardImages_${propertyId}') ?? [];
      kitchenSocketImages =
          prefs.getStringList('kitchenSocketImages_${propertyId}') ?? [];
      kitchenHeatingImages =
          prefs.getStringList('kitchenHeatingImages_${propertyId}') ?? [];
      kitchenAccessoriesImages =
          prefs.getStringList('kitchenAccessoriesImages_${propertyId}') ?? [];
      kitchenFlooringImages =
          prefs.getStringList('kitchenFlooringImages_${propertyId}') ?? [];
      kitchenAdditionItemsImages =
          prefs.getStringList('kitchenAdditionItemsImages_${propertyId}') ?? [];


      //Landing
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

      //Bedroom
      bedRoomDoorLocation = prefs.getString('doorLocation_${propertyId}');
      bedRoomDoorCondition = prefs.getString('doorCondition_${propertyId}');
      bedRoomDoorFrameLocation = prefs.getString('doorFrameLocation_${propertyId}');
      bedRoomDoorFrameCondition = prefs.getString('doorFrameCondition_${propertyId}');
      bedRoomCeilingLocation = prefs.getString('ceilingLocation_${propertyId}');
      bedRoomCeilingCondition = prefs.getString('ceilingCondition_${propertyId}');
      bedRoomLightingLocation = prefs.getString('lightingLocation_${propertyId}');
      bedRoomLightingCondition = prefs.getString('lightingCondition_${propertyId}');
      bedRoomWallsLocation = prefs.getString('wallsLocation_${propertyId}');
      bedRoomWallsCondition = prefs.getString('wallsCondition_${propertyId}');
      bedRoomSkirtingLocation = prefs.getString('skirtingLocation_${propertyId}');
      bedRoomsSkirtingCondition = prefs.getString('skirtingCondition_${propertyId}');
      bedRoomWindowSillLocation = prefs.getString('windowSillLocation_${propertyId}');
      bedRoomWindowSillCondition = prefs.getString('windowSillCondition_${propertyId}');
      bedRoomCurtainsLocation = prefs.getString('curtainsLocation_${propertyId}');
      bedRoomCurtainsCondition = prefs.getString('curtainsCondition_${propertyId}');
      bedRoomBlindsLocation = prefs.getString('blindsLocation_${propertyId}');
      bedRoomBlindsCondition = prefs.getString('blindsCondition_${propertyId}');
      bedRoomLightSwitchesLocation = prefs.getString('lightSwitchesLocation_${propertyId}');
      bedRoomLightSwitchesCondition = prefs.getString('lightSwitchesCondition_${propertyId}');
      bedRoomSocketsLocation = prefs.getString('socketsLocation_${propertyId}');
      bedRoomSocketsCondition = prefs.getString('socketsCondition_${propertyId}');
      bedRoomFlooringLocation = prefs.getString('flooringLocation_${propertyId}');
      bedRoomFlooringCondition = prefs.getString('flooringCondition_${propertyId}');
      bedRoomAdditionalItemsLocation = prefs.getString('additionalItemsLocation_${propertyId}');
      bedRoomAdditionalItemsCondition = prefs.getString('additionalItemsCondition_${propertyId}');
      bedRoomDoorImages = prefs.getStringList('doorImages_${propertyId}') ?? [];
      bedRoomDoorFrameImages = prefs.getStringList('doorFrameImages_${propertyId}') ?? [];
      bedRoomCeilingImages = prefs.getStringList('ceilingImages_${propertyId}') ?? [];
      bedRoomlLightingImages = prefs.getStringList('lightingImages_${propertyId}') ?? [];
      bedRoomwWallsImages = prefs.getStringList('wallsImages_${propertyId}') ?? [];
      bedRoomSkirtingImages = prefs.getStringList('skirtingImages_${propertyId}') ?? [];
      bedRoomWindowSillImages = prefs.getStringList('windowSillImages_${propertyId}') ?? [];
      bedRoomCurtainsImages = prefs.getStringList('curtainsImages_${propertyId}') ?? [];
      bedRoomBlindsImages = prefs.getStringList('blindsImages_${propertyId}') ?? [];
      bedRoomLightSwitchesImages = prefs.getStringList('lightSwitchesImages_${propertyId}') ?? [];
      bedRoomSocketsImages = prefs.getStringList('socketsImages_${propertyId}') ?? [];
      bedRoomFlooringImages = prefs.getStringList('flooringImages_${propertyId}') ?? [];
      bedRoomAdditionalItemsImages =
          prefs.getStringList('additionalItemsImages_${propertyId}') ?? [];

      //Rear Garden
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

      //Stairs
      stairsdoorCondition =
          prefs.getString('stairsdoorCondition_${propertyId}');
      stairsdoorDescription =
          prefs.getString('stairsdoorDescription_${propertyId}');
      stairsdoorFrameCondition =
          prefs.getString('doorFrameCondition_${propertyId}');
      stairsdoorFrameDescription =
          prefs.getString('stairsdoorFrameDescription_${propertyId}');
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
          prefs.getString('stairsstairslightSwitchesDescription_${propertyId}');
      stairssocketsCondition =
          prefs.getString('stairssocketsCondition_${propertyId}');
      stairssocketsDescription =
          prefs.getString('socketsDescription_${propertyId}');
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
      stairslooringImages =
          prefs.getStringList('fstairslooringImages_${propertyId}') ?? [];
      stairsadditionalItemsImages =
          prefs.getStringList('stairsadditionalItemsImages_${propertyId}') ??
              [];
      // Manuals And Certificates
      houseApplinceManual = prefs.getString('houseApplinceManual_${propertyId}');
      houseApplinceManualDescription = prefs.getString('houseApplinceManualDescription_${propertyId}');
      kitchenApplinceManual = prefs.getString('kitchenApplinceManual_${propertyId}');
      kitchenApplinceManualDescription = prefs.getString('kitchenApplinceManualDescription_${propertyId}');
      heatingManual = prefs.getString('heatingManual_${propertyId}');
      heatingManualDescription = prefs.getString('heatingManualDescription_${propertyId}');
      landlordGasSafetyCertificate = prefs.getString('landlordGasSafetyCertificate_${propertyId}');
      landlordGasSafetyCertificateDescription = prefs.getString('landlordGasSafetyCertificateDescription_${propertyId}');
      legionellaRiskAssessment = prefs.getString('legionellaRiskAssessment_${propertyId}');
      legionellaRiskAssessmentDescription = prefs.getString('legionellaRiskAssessmentDescription_${propertyId}');
      electricalSafetyCertificate = prefs.getString('electricalSafetyCertificate_${propertyId}');
      electricalSafetyCertificateDescription = prefs.getString('electricalSafetyCertificateDescription_${propertyId}');
      energyPerformanceCertificate = prefs.getString('energyPerformanceCertificate_${propertyId}');
      energyPerformanceCertificateDescription = prefs.getString('energyPerformanceCertificateDescription_${propertyId}');
      moveInChecklist = prefs.getString('moveInChecklist_${propertyId}');
      moveInChecklistDescription = prefs.getString('moveInChecklistDescription_${propertyId}');

      houseApplinceManualImages = prefs.getStringList('houseApplinceManualImages_${propertyId}') ?? [];
      kitchenApplinceManualImages = prefs.getStringList('kitchenApplinceManualImages_${propertyId}') ?? [];
      heatingManualImages = prefs.getStringList('heatingManualImages_${propertyId}') ?? [];
      landlordGasSafetyCertificateImages = prefs.getStringList('landlordGasSafetyCertificateImages_${propertyId}') ?? [];
      legionellaRiskAssessmentImages = prefs.getStringList('legionellaRiskAssessmentImages_${propertyId}') ?? [];
      electricalSafetyCertificateImages = prefs.getStringList('electricalSafetyCertificateImages_${propertyId}') ?? [];
      energyPerformanceCertificateImages = prefs.getStringList('energyPerformanceCertificateImages_${propertyId}') ?? [];
      moveInChecklistImages = prefs.getStringList('moveInChecklistImages_${propertyId}') ?? [];

      //Utility Area
      utilityNewdoor = prefs.getString('utilityNewdoor_${propertyId}');
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
          prefs.getString('utilityskirtingDescription_${propertyId}');
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
      utilitydoorImages =
          prefs.getStringList('utilitydoorImages_${propertyId}') ?? [];
      utilitydoorFrameImages =
          prefs.getStringList('utilitydoorFrameImages_${propertyId}') ?? [];
      utilityceilingImages =
          prefs.getStringList('utilityceilingImages_${propertyId}') ?? [];
      utilitylightingImages =
          prefs.getStringList('utilitylightingImages_${propertyId}') ?? [];
      utilitywallsImages =
          prefs.getStringList('utilitywallsImages_${propertyId}') ?? [];
      utilityskirtingImages =
          prefs.getStringList('utilityskirtingImages_${propertyId}') ?? [];
      utilitywindowSillImages =
          prefs.getStringList('utilitywindowSillImages_${propertyId}') ?? [];
      utilitycurtainsImages =
          prefs.getStringList('utilitycurtainsImages_${propertyId}') ?? [];
      utilityblindsImages =
          prefs.getStringList('utilityblindsImages_${propertyId}') ?? [];
      utilitylightSwitchesImages =
          prefs.getStringList('utilitylightSwitchesImages_${propertyId}') ?? [];
      utilitysocketsImages =
          prefs.getStringList('utilitysocketsImages_${propertyId}') ?? [];
      utilityflooringImages =
          prefs.getStringList('utilityflooringImages_${propertyId}') ?? [];
      utilityadditionalItemsImages =
          prefs.getStringList('utilityadditionalItemsImages_${propertyId}') ??
              [];

      //BATH ROOM
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
    });
  }

  // List<String> getOverviewImages(String propertyId) {
  //   // Retrieve the image URLs from SharedPreferences
  //   final prefs = SharedPreferences.getInstance();
  //   final imageUrls = prefs.getStringList('overviewImages_${propertyId}') ?? [];
  //
  //   // Return the list of image URLs
  //   return imageUrls;
  // }

  late PropertyDto property = PropertyDto(
    id: 'property123',
    addressDto: AddressDto(
      addressLineOne: overview ?? 'N/A',
      addressLineTwo: accessoryCleanliness ?? 'N/A',
      city: 'Vavuniya',
      state: 'Western',
      country: 'Sri Lanka',
      postalCode: '12345',
    ),
    userDto: UserDto(
      firebaseId: 'user001',
      firstName: 'Abishan',
      lastName: 'Ananthan',
      userName: 'abishaan09',
      email: 'abiabishan09@gmail.com',
      location: '+Vavuniya',
    ),
    inspectionDto: InspectionDto(
      inspectionId: 'insp001',
      inspectorName: 'Jane Smith',
      inspectionType: 'Check Out',
      date: '2024-09-01',
      time: '2024-09-01',
      keyLocation: '2024-09-01',
      keyReference: '2024-09-01',
      internalNotes: '2024-09-01',
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
              images: [overviewImages.toString()],
              comments: overview ?? 'N/A',
              feedback: overview ?? 'N/A',
              conditionImages: [],
            ),

            //1.2 Accessory Cleanliness
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Accessory Cleanliness',
              images: [accessoryCleanliness.toString()],
              comments: accessoryCleanliness ?? 'N/A',
              feedback: accessoryCleanliness ?? 'N/A',
              conditionImages: [],
            ),

            //1.3 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [windowSill.toString()],
              comments: windowSill ?? 'N/A',
              feedback: windowSill ?? 'N/A',
              conditionImages: [],
            ),

            //1.4 Carpets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Carpets',
              images: [carpets.toString()],
              comments: carpets ?? 'N/A',
              feedback: carpets ?? 'N/A',
              conditionImages: [],
            ),

            //1.5 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [ceilings.toString()],
              comments: ceilings ?? 'N/A',
              feedback: ceilings ?? 'N/A',
              conditionImages: [],
            ),

            //1.6 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [curtains.toString()],
              comments: curtains ?? 'N/A',
              feedback: curtains ?? 'N/A',
              conditionImages: [],
            ),

            //1.7 Hard Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Hard Flooring',
              images: [hardFlooring.toString()],
              comments:hardFlooring ?? 'N/A',
              feedback: hardFlooring ?? 'N/A',
              conditionImages: [],
            ),

            //1.8 Kitchen Area
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Kitchen Area',
              images: [kitchenArea.toString()],
              comments: kitchenArea ?? 'N/A',
              feedback: kitchenArea ?? 'N/A',
              conditionImages: [],
            ),

            //1.9 Oven
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Oven',
              images: [oven.toString()],
              comments: oven ?? 'N/A',
              feedback: oven ?? 'N/A',
              conditionImages: [],
            ),

            //1.10 Mattress
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Mattress',
              images: [mattress.toString()],
              comments: mattress ?? 'N/A',
              feedback: mattress ?? 'N/A',
              conditionImages: [],
            ),

            //1.11 Uholstrey
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Uholstrey',
              images: [upholstrey.toString()],
              comments: upholstrey ?? 'N/A',
              feedback: upholstrey ?? 'N/A',
              conditionImages: [],
            ),

            //1.12 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: wall ?? 'N/A',
              feedback: wall ?? 'N/A',
              conditionImages: [],
            ),

            //1.13 Window
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window',
              images: [overviewImages.toString()],
              comments: window ?? 'N/A',
              feedback: window ?? 'N/A',
              conditionImages: [],
            ),

            //1.14 Woodwork
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Woodwork',
              images: [overviewImages.toString()],
              comments: woodwork ?? 'N/A',
              feedback: woodwork ?? 'N/A',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        //2 EV Charger
        InspectionReportDto(
          reportId: 'report002',
          name: 'EV Charger',
          subTypes: [
            //2.1 EV Charger
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'EV Charger',
              images: [evChargerDescription.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        //3 Meter Reading
        InspectionReportDto(
          reportId: 'report002',
          name: 'Meter Reading',
          subTypes: [
            //1.1 Overview - Odours
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Gas Meter',
              images: [overviewImages.toString()],
              comments: gasMeterReading ?? 'N/A',
              feedback: gasMeterReading ?? 'N/A',
              conditionImages: [],
            ),

            //1.2 Accessory Cleanliness
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Electric Meter',
              images: [overviewImages.toString()],
              comments: electricMeterReading ?? 'N/A',
              feedback: electricMeterReading ?? 'N/A',
              conditionImages: [],
            ),

            //1.3 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Water Meter',
              images: [overviewImages.toString()],
              comments: waterMeterReading ?? 'N/A',
              feedback: waterMeterReading ?? 'N/A',
              conditionImages: [],
            ),

            //1.4 Carpets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Oil Meter',
              images: [overviewImages.toString()],
              comments: oilMeterReading ?? 'N/A',
              feedback: oilMeterReading ?? 'N/A',
              conditionImages: [],
            ),

            //1.5 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Other Meter',
              images: [overviewImages.toString()],
              comments: otherMeterReading ?? 'N/A',
              feedback: otherMeterReading ?? 'N/A',
              conditionImages: [],
            ),

          ],
          additionalComments: 'All areas in good condition.',
        ),

        //Keys
        InspectionReportDto(
          reportId: 'report001',
          name: 'Keys',
          subTypes: [
            //4.1 Yale
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Yale',
              images: [overviewImages.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),

            //4.2 Mortice
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Mortice',
              images: [overviewImages.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),

            //4.3 Window Lock
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Lock',
              images: [overviewImages.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),

            //4.4 Gas Meter
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Gas Meter',
              images: [overviewImages.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),

            //4.5 Car Pass
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Car Pass',
              images: [overviewImages.toString()],
              comments: evChargerDescription ?? 'N/A',
              feedback: evChargerDescription ?? 'N/A',
              conditionImages: [],
            ),

            //4.6 Remote
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Remote',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //4.7 Other
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Other',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
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
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //5.2 Mortice
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Mortice',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //5.3 Other
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Other',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        //Health and Safety
        InspectionReportDto(
          reportId: 'report001',
          name: 'Health and Safety',
          subTypes: [
            //6.1 Heat Sensor
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Heat Sensor',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //6.2 Smoke Alarm
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Smoke Alarm',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //6.3 Other
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Other',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
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
              subTypeName: 'Drive Way',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //7.2 Outside Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Outside Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //7.3 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 8 Garage
        InspectionReportDto(
          reportId: 'report001',
          name: 'Schedule of Condition',
          subTypes: [
            //8.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 9 Exterior Front
        InspectionReportDto(
          reportId: 'report001',
          name: 'Exterior Front',
          subTypes: [
            //9.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //9.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //9.3 Porch
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Porch',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //9.4 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 10 Entrance Hallway
        InspectionReportDto(
          reportId: 'report001',
          name: 'Entrance/Hallway',
          subTypes: [
            //8.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 11 Toilet
        InspectionReportDto(
          reportId: 'report001',
          name: 'Entrance/Hallway',
          subTypes: [

            //11.1 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.2 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.3 Extractor Fan
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Extractor Fan',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.10 Toilet
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Toilet',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.11 Basin
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Basin',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.12 Shower Cubicle
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Shower Cubicle',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.13 Bath
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Bath',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //11.14 Switch Board
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Switch Board',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.15 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.16 Heating
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Heating',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.17 Accessories
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Accessories',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.18 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //8.19 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 12 Lounge
        InspectionReportDto(
          reportId: 'report001',
          name: 'Lounge',
          subTypes: [
            //12.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //12.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 13 Kitchen
        InspectionReportDto(
          reportId: 'report001',
          name: 'Kitchen',
          subTypes: [
            //13.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //13.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 14 Utility Area
        InspectionReportDto(
          reportId: 'report001',
          name: 'Utility Area',
          subTypes: [
            //14.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //14.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 15 Stairs
        InspectionReportDto(
          reportId: 'report001',
          name: 'Stairs',
          subTypes: [
            //15.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //15.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 16 Landing
        InspectionReportDto(
          reportId: 'report001',
          name: 'Landing',
          subTypes: [
            //16.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //16.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 17 Bedroom
        InspectionReportDto(
          reportId: 'report001',
          name: 'Bedroom',
          subTypes: [
            //17.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //17.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
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
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //18.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 19 Bathroom
        InspectionReportDto(
          reportId: 'report001',
          name: 'Bathroom',
          subTypes: [
            //19.1 Door
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.2 Door Frame
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Door Frame',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.3 Ceilings
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Ceilings',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.4 Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Lighting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.5 Wall
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Wall',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.6 Skirting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Skirting',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.7 Window Sill
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Window Sill',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.8 Curtains
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Curtains',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.9 Blinds
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Blinds',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.10 Light Switches
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Light Switches',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.11 Sockets
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Sockets',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.12 Flooring
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Flooring',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //19.13 Additional Items
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Items',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 20 Rear Garden
        InspectionReportDto(
          reportId: 'report001',
          name: 'Rear Garden',
          subTypes: [
            //20.1 Garden Description
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Garden Description',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //20.2 Outside Lighting
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Outside Lightinge',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //20.3 Summer House
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Summer House',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //20.4 Shed
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Shed',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //20.5 Additional Information
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Additional Information',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),
          ],
          additionalComments: 'All areas in good condition.',
        ),

        // 21 Manuals
        InspectionReportDto(
          reportId: 'report001',
          name: 'Manuals',
          subTypes: [
            //21.1 House Appliance Manual
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'House Appliance Manual',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.2 Kitchen Appliance Manual
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Kitchen Appliance Manual',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.3 Heating Manual
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Heating Manual',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.4 Landlord Gas Safety Certificate
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Landlord Gas Safety Certificate',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.5 Legionella Risk Assessment
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Legionella Risk Assessment',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.6 Electricity Safety Certificate
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Electricity Safety Certificate',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.7 Energy Performance Certificate
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Energy Performance Certificate',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

            //21.8 Move In Checklist
            SubTypeDto(
              subTypeId: 'subType001',
              subTypeName: 'Move In Checklist',
              images: [overviewImages.toString()],
              comments: 'Condition: Good, Additional Comments: Good',
              feedback: '',
              conditionImages: [],
            ),

          ],
          additionalComments: 'All areas in good condition.',
        ),



        // Add more InspectionReportDto items as needed
      ],
    ),
  );

  Future<void> _saveData() async {
    try {
      await sendPropertyData(property);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data saved successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save data: $e'),
      ));
    }
  }

  Future<void> sendPropertyData(PropertyDto property) async {
    final url =
        '$baseURL/summary/generateReport'; // Replace with your backend URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(property.toJson());

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save data: ${response.reasonPhrase}');
    }
  }

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
        print("Edit Page - $propertyId");
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

  // void onPreviewPressed() async {
  //   final data = await getSharedPreferencesData();
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => InspectionConfimationPage(
  //         finalDate: data,),
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   getFirebaseUserId();
  //   // fetchProperties();
  //   controller = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
  //   super.initState();
  //
  // }

  // Future<void> _saveData() async {
  //   try {
  //     await sendPropertyData(property);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Data saved successfully!'),
  //     ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to save data: $e'),
  //     ));
  //   }
  // }

  // Future<void> sendPropertyData(PropertyDto property) async {
  //   final url = '$baseURL/summary/generateReport'; // Replace with your backend URL
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to save data: ${response.reasonPhrase}');
  //   }
  // }

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

  // void _previewReport() async {
  //   try {
  //     // Pass all types, subtypes, and images from the form into the DTO
  //     property.inspectionDto!.inspectionReports[0].subTypes = [
  //       SubTypeDto(
  //         subTypeId: 'subType001',
  //         subTypeName: 'Overview - Odours',
  //         imageUrls: [], // Initially empty, will be populated after upload
  //         images: selectedImages, // List of image files selected by user
  //         comments: 'Condition: Good, Additional Comments: Good',
  //         feedback: '',
  //       ),
  //       // Add more subtypes as necessary
  //     ];
  //
  //     // Navigate to preview or call _saveData if needed
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PreviewPage(property: property),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error in previewing report: $e");
  //   }
  // }
  //
  // Future<void> sendPropertyData(PropertyDto property) async {
  //   final url = '$baseURL/summary/generateReport';
  //   final headers = {'Content-Type': 'application/json'};
  //
  //   // Upload images first, then update imageUrls in DTO
  //   for (var report in property.inspectionDto.inspectionReports) {
  //     for (var subType in report.subTypes) {
  //       await uploadImages(subType);
  //     }
  //   }
  //
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to save data: ${response.reasonPhrase}');
  //   }
  // }
  //
  // Future<void> uploadImages(SubTypeDto subType) async {
  //   final url = '$baseURL/uploadImages';
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //   // Attach the images to the request
  //   for (File image in subType.images) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'images',
  //         image.path,
  //       ),
  //     );
  //   }
  //
  //   final response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     List<String> uploadedImageUrls = jsonDecode(responseBody);
  //
  //     // Update imageUrls with uploaded URLs
  //     subType.imageUrls.addAll(uploadedImageUrls);
  //   } else {
  //     throw Exception('Failed to upload images');
  //   }
  // }

  // Future<void> sendPropertyData(PropertyDto.dart property) async {
  //   final url = 'http://your-backend-url/api/property';
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode(property.toJson());
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Data sent successfully');
  //   } else {
  //     print('Failed to send data: ${response.reasonPhrase}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      //Schedule of Condition',
      {
        'title': '1. Schedule of Condition',
        'icon': Icons.schedule,
        'subItems': [
          // Overview
          {
            'title': '1.1 Overview - Odours',
            'details': [
              {'label': 'Condition', 'value': overview ?? 'N/A',},
              {'label': 'Additional Comments', 'value': overview ?? 'N/A',},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.2 Genral Cleanliness',
            'details': [
              {'label': 'Condition', 'value': accessoryCleanliness ?? 'N/A',},
              {'label': 'Additional Comments', 'value': accessoryCleanliness ?? 'N/A',},

            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.3 Bathroom/En Suite/ Toilet(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.4 Carpets',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.5 Ceiling(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.6 Curtains/Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.7 Hard Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.8 Kitchen Area',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.9 Kitchen - White Goods',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.10 Oven/Hob/Extractor Hood/Cooker',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.11 Mattress(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.12 Upholstery',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.13 Wall(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
            // Use image paths or URLs
          },
          {
            'title': '1.14 Window(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image3', 'path_to_image4']
            // Use image paths or URLs
          },
          {
            'title': '1.15 Woodwork',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image1', 'path_to_image2']
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
        'title': '2. EV Charger(s)',
        'icon': Icons.charging_station,
        'subItems': [
          {
            'title': '2.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '3.2 Electric Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.3 Water Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.4 Oil Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '3.5 Other ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '4.2 Mortice',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.3 Window Lock',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.4 Gas/Electric Meter ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.5 Car Pass/Permit ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.6 Remote/Security Fob ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '4.7 Other ',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '5. Keys Handed Over At Check In',
        'icon': Icons.key,
        'subItems': [
          {
            'title': '5.1 Yale',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '5.2 Mortice',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '5.3 Other',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '6.2 Heat Sensor Alarm(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '6.3 Carbon Monoxide Alarm(s)',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '7. Garage',
        'icon': Icons.garage,
        'subItems': [
          {
            'title': '7.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '7.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.7 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.8 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.9 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.10 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
            // Use image paths or URLs
          },
          {
            'title': '7.11 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Clean'},
            ],
            'images': ['path_to_image7', 'path_to_image8']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.2 DriveWay',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.3 Outside Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '8.4 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '9. Exterior Front',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '9.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.4 Porch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '9.5 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '10. Entrance Hallway',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '10.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.4 Door Bell/Reciever',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.5 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.15 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '10.16 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '11. Toilet',
        'icon': Icons.wash_rounded,
        'subItems': [
          {
            'title': '11.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.11 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.12 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.13 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.14 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.15 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.16 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.17 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '11.18 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
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
          {
            'title': '12.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.7 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.8 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.9 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.11 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.12 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.13 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.14 Fireplace',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.15 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '12.16 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '13. Kitchen',
        'icon': Icons.kitchen,
        'subItems': [
          {
            'title': '13.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.15 Kitchen Units',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.16 Extractor Hood',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.17 Cooker',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.18 Hod',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.19 Oven',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.20 Worktop(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.21 Sink',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.22 Fridge/Freezer',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.24 Dishwasher',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.25 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.26 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '14. Utility Room/Area',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '14.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.12 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.13 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.14 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.15 Kitchen Units',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.16 Worktop(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.17 Sink',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.18 Fridge/Freezer',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.19 Washing Machine',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '14.20 Dishwasher',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.21 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '13.22 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '15. Stairs',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '15.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.2 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.3 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.4 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.5 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.6 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.7 Curtains',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.8 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.9 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.10 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.11 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.12 Staircase',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.13 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '15.14 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '16. Landing',
        'icon': Icons.stairs,
        'subItems': [
          {
            'title': '16.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.2 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.3 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.4 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.5 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.6 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.7 Curtains',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.8 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.9 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.10 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.11 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.12 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '16.13 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '17. Bedroom 1',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '17.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.5 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.6 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.7 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.8 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.9 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.10 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.11 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.12 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.13 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.14 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '17.15 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '18. En-Suite',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '18.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.12 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.13 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.14 Shower Unit/Cubicle',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.15 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.16 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.17 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.18 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.19 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '18.20 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '19. Bedroom ',
        'icon': Icons.meeting_room,
        'subItems': [
          {
            'title': '19.1 Overview',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.2 Door',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.3 Door Frame',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.4 Ceiling',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.5 Extractor Fan',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.6 Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.7 Walls',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.8 Skirting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.9 Window(s)/Sill',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.10 Curtain',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.11 Blinds',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.12 Toilet',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.13 Basin',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.14 Shower Unit/Cubicle',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.15 Bath/ Bath Panels',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.16 Switch',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.17 Sockets',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.18 Heating',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.19 Accessories',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.20 Flooring',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '19.21 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.2 Outside Lighting',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.3 Summer House',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.4 Shed(s)',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '20.5 Additional Items/ Information',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
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
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.2 Kitchen Appliances Manuals',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.3 Heating System Manual',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.4 Landlord Gas Safety Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.5 Legionella Risk Assessment',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.6 Electrical Safety Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.7 Energy Performance Certificate',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
          {
            'title': '21.8 Move In Checklist',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },
      {
        'title': '22. Property Receipts',
        'icon': Icons.receipt_long,
        'subItems': [
          {
            'title': '22.1 Receipts',
            'details': [
              {'label': 'Condition', 'value': 'Good'},
            ],
            'images': ['path_to_image5', 'path_to_image6']
            // Use image paths or URLs
          },
        ],
      },

      // Add more headings here
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report Preview',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 14,
              fontFamily: "Inter",
            ),
          ),
          centerTitle: true,
          backgroundColor: bWhite,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingScreen(),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       elevation: 10,
              //       backgroundColor: Colors.white,
              //       title: Row(
              //         children: [
              //           Icon(Icons.info_outline, color: kPrimaryColor),
              //           SizedBox(width: 10),
              //           Text(
              //             'Do you want to Exit',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       content: Text(
              //         'Your process will not be saved if you exit the process',
              //         style: TextStyle(
              //           color: Colors.grey[800],
              //           fontSize: 14,
              //           fontWeight: FontWeight.w400,
              //           height: 1.5,
              //         ),
              //       ),
              //       actions: <Widget>[
              //         TextButton(
              //           child: Text(
              //             'Cancel',
              //             style: TextStyle(
              //               color: kPrimaryColor,
              //               fontSize: 16,
              //             ),
              //           ),
              //           onPressed: () {
              //             Navigator.of(context).pop(); // Close the dialog
              //           },
              //         ),
              //         TextButton(
              //           onPressed: () {
              //             Navigator.pushReplacement(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => LandingScreen()),
              //             ); // Close the dialog
              //           },
              //           style: TextButton.styleFrom(
              //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //             backgroundColor: kPrimaryColor,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //           ),
              //           child: Text(
              //             'Exit',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // );
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
                _saveData(); // Link the save button to the function
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       elevation: 10,
                //       backgroundColor: Colors.white,
                //       title: Row(
                //         children: [
                //           Icon(Icons.info_outline, color: kPrimaryColor),
                //           SizedBox(width: 10),
                //           Text(
                //             'Continue Saving',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ],
                //       ),
                //       content: Text(
                //         'You Cannot make any changes after you save the Property',
                //         style: TextStyle(
                //           color: Colors.grey[800],
                //           fontSize: 14,
                //           fontWeight: FontWeight.w400,
                //           height: 1.5,
                //         ),
                //       ),
                //       actions: <Widget>[
                //         TextButton(
                //           child: Text('Cancel',
                //             style: TextStyle(
                //               color: kPrimaryColor,
                //               fontSize: 16,
                //             ),
                //           ),
                //           onPressed: () {
                //             Navigator.of(context).pop(); // Close the dialog
                //           },
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(builder: (context) => DetailsConfirmationPage(
                //                 lineOneAddress: widget.lineOneAddress,
                //                 lineTwoAddress: widget.lineTwoAddress,
                //                 city: widget.city,
                //                 state: widget.state,
                //                 country: widget.country,
                //                 postalCode: widget.postalCode,
                //                 reference: widget.reference,
                //                 client: widget.client,
                //                 type: widget.type,
                //                 furnishing: widget.furnishing,
                //                 noOfBeds: widget.noOfBeds,
                //                 noOfBaths: widget.noOfBaths,
                //                 garage: garageSelected,
                //                 parking: parkingSelected,
                //                 notes: widget.notes,
                //                 selectedType: selectedType.toString(),
                //                 date: selectedDate,
                //                 time: selectedTime,
                //                 keyLocation: keysIwth.toString(),
                //                 referenceForKey: referenceController.text,
                //                 internalNotes: internalNotesController.text,
                //               )),
                //             );
                //           },
                //           style: TextButton.styleFrom(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 16, vertical: 8),
                //             backgroundColor: kPrimaryColor,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           child: Text(
                //             'Continue',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 16,
                //             ),
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Save', // Replace with the actual location
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 14, // Adjust the font size
                    fontFamily: "Inter",
                  ),
                ),
              ),
            )
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
                                    child: Image.asset(subItem['images'][
                                        imgIndex]), // Use Image.network() for URLs
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
        // TextButton(
        //   onPressed: () async {
        //     if (controller!.isNotEmpty) {
        //       final sign = await exportSignature();
        //       setState(() {
        //         signature = sign;
        //       });
        //     } else {
        //       //showMessage
        //       // Please put your signature;
        //     }
        //   },
        //   child: const Text("Preview",
        //       style: TextStyle(fontSize: 20, color: kPrimaryColor)),
        // ),
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
