import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_picker/app_util.dart';
import 'package:location_picker/pick_result.dart';
import 'package:location_picker/place_picker.dart';
import 'package:location_picker/plugin_colors.dart';
import 'package:location_picker/search_place_result_response.dart'
    as searchResultResModel;
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as locationPlugin;
import 'package:uuid/uuid.dart';

class CustomGoogleMapBloc {
  BuildContext? _buildContext;
  GoogleMapController? mapController; //controller for Google map
  CameraPosition? _cameraPosition;
  LatLng? _initialLocation = new LatLng(28.80, 77.50);
  TextEditingController _placeEditController = TextEditingController();
  Uuid _uuid = new Uuid();
  String? _sessionToken;
  List<searchResultResModel.Prediction> _placeList = [];
  String? _googleApiKey;
  PickResult? _result;

  Color? _themeColor = PluginColors.primary;

  final BehaviorSubject<bool> _loadingController =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<String> _locationController =
      BehaviorSubject<String>.seeded('Fetching Location...');

  final BehaviorSubject<String> location =
      BehaviorSubject<String>.seeded('Fetching Location...');

  final BehaviorSubject<bool> _clearIconVisibility =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _searchLoadingController =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _locationIconVisibility =
      BehaviorSubject<bool>.seeded(false);

  locationPlugin.Location locationPluginVar = new locationPlugin.Location();

  Uuid get uuid => _uuid;

  String? get sessionToken => _sessionToken;

  List<searchResultResModel.Prediction>? get placeList => _placeList;

  TextEditingController get placeEditController => _placeEditController;

  BehaviorSubject<bool> get loadingController => _loadingController;

  BehaviorSubject<bool> get clearIconVisibility => _clearIconVisibility;

  BehaviorSubject<bool> get locationIconVisibility => _locationIconVisibility;

  BehaviorSubject<bool> get searchLoadingController => _searchLoadingController;

  BehaviorSubject<String> get locationController => _locationController;
  String? _locationAddress = "";

  /*Setter & Getter For Context*/

  void setThemeColor({required Color? themeColor}) {
    this._themeColor = themeColor;
  }

  Color? getThemeColor() {
    return _themeColor;
  }



  void setBuildContext({required BuildContext? buildContext}) {
    this._buildContext = buildContext;
  }

  BuildContext getBuildContext() {
    return _buildContext!;
  }

  setLocationAddress({String? locationAddress}) {
    this._locationAddress = locationAddress!;
  }

  String getLocationAddress() {
    return this._locationAddress!;
  }

  setCameraPosition({CameraPosition? cameraPosition}) {
    this._cameraPosition = cameraPosition!;
  }

  getCameraPosition() {
    return this._cameraPosition;
  }

  setIntialLocation({LatLng? intialLocation}) {
    this._initialLocation = _initialLocation;
  }

  LatLng? getInitialLocation() {
    return this._initialLocation;
  }

  setResult({PickResult? result}) {
    this._result = result;
  }

  PickResult? getResult({PickResult? result}) {
    return _result;
  }

  /* Getter Setter for Google Key */

  String? getGoogleKey() {
    return _googleApiKey;
  }

  setGoogleKey({required String? googleKey}) {
    this._googleApiKey = googleKey;
  }

  cameraIdleGetLocation({double? latitude, double? longitude}) async {
    loadingController.add(true);
    PluginUtil.printAppLog(
        logValue:
            "onCameraIdle called latitude -$latitude--longitude $longitude");
    //when map drag stops
    GeocodingResponse response =
        await new GoogleMapsGeocoding(apiKey: getGoogleKey()).searchByLocation(
      Location(lat: latitude!, lng: longitude!),
      language: "en",
    );
    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage!);
      loadingController.add(false);
      loadingController.addError(response.errorMessage!);
      return;
    }
    var pickResult = PickResult.fromGeocodingResult(response.results[0]);
    PluginUtil.printAppLog(logValue: pickResult.formattedAddress!);
    setLocationAddress(locationAddress: pickResult.formattedAddress!);
    loadingController.add(false);
    setResult(result: pickResult);
  }

  void getSuggestion(String input) async {
    searchLoadingController.add(true);
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String? request =
        '$baseURL?input=$input&key=${getGoogleKey()}&sessiontoken=$_sessionToken&components=country:in&language=en';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      //    _placeList = json.decode(response.body)['predictions'];
      searchResultResModel.SearchPlaceResultResModel model =
          searchResultResModel.SearchPlaceResultResModel.fromJson(
              json.decode(response.body));
      _placeList = model.predictions!;
      searchLoadingController.add(false);
    } else {
      searchLoadingController.add(false);
      searchLoadingController.addError('Failed to load predictions');
      PluginUtil.printAppLog(logValue: "Failed to load predictions");
      throw Exception('Failed to load predictions');
    }
  }

  addChangeListner() {
    placeEditController.addListener(() {
      if (placeEditController.text != null &&
          placeEditController.text.length > 2) {
        clearIconVisibility.add(true);
        onChanged();
      } else {
        clearIconVisibility.add(false);
      }
    });
  }

  onChanged() {
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
      _sessionToken = uuid.v4();
    }
    getSuggestion(placeEditController.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  onSelectLocation({searchResultResModel.Prediction? prediction}) async {
    PluginUtil.printAppLog(logValue: "prediction-- ${prediction!.placeId!}");
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: getGoogleKey(),
    );
    final PlacesDetailsResponse detailResponse =
        await places.getDetailsByPlaceId(
      prediction.placeId!,
      language: "en",
    );

    if (detailResponse.errorMessage?.isNotEmpty == true ||
        detailResponse.status == "REQUEST_DENIED") {
      print(
          "Fetching details by placeId Error: " + detailResponse.errorMessage!);
    }

    PickResult pickResult =
        PickResult.fromPlaceDetailResult(detailResponse.result);
    updateCameraPosition(
        latlng: LatLng(pickResult.geometry!.location.lat,
            pickResult.geometry!.location.lng));

    /*Send call Back*/
    setResult(result: pickResult);
  }

  clearTheTextSearchField() {
    FocusScope.of(PluginUtil.getBuildContext()).unfocus();
    placeList!.clear();
    placeEditController.text = '';
    searchLoadingController.add(false);
    PluginUtil.closeKeyboard();
  }

  void updateCameraPosition({LatLng? latlng}) {
    PluginUtil.printAppLog(logValue: "updateCameraPosition--step 1");
    if (mapController != null) {
      PluginUtil.printAppLog(logValue: "updateCameraPosition--step 2");
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(latlng!, 14));
    }
  }

  void onDeniedPermissionUpdateDefaultLocation() {
    locationIconVisibility.add(false);
    updateCameraPosition(latlng: getInitialLocation());
    cameraIdleGetLocation(
        latitude: getInitialLocation()!.latitude,
        longitude: getInitialLocation()!.longitude);
  }

  Future<bool> checkPermission() async {
    PluginUtil.printAppLog(logValue: "checkPermission");
    var status = await Permission.location.status;
    PluginUtil.printAppLog(logValue: "checkPermission $status");

    if (await Permission.location.isGranted) {
      PluginUtil.printAppLog(logValue: "checkPermission $status");
      getLocation();
      locationIconVisibility.add(true);
      return true;
    }

    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      PluginUtil.printAppLog(logValue: 'Permission.location.isRestricted');
      onDeniedPermissionUpdateDefaultLocation();
      return false;
    }

    if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      PluginUtil.printAppLog(logValue: 'Permission.speech.isPermanentlyDenied');
      onDeniedPermissionUpdateDefaultLocation();
      openAppSettings();
    }

    if (status.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      PluginUtil.printAppLog(
          logValue:
              'checkPermission isPermanentlyDenied--: ${status.isDenied}');
      onDeniedPermissionUpdateDefaultLocation();
    }

    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      PluginUtil.printAppLog(
          logValue: 'checkPermission step 1--: ${status.isDenied}');
      updateCameraPosition(latlng: getInitialLocation());
      locationIconVisibility.add(false);
      return requestPermission();
    }
    return false;
  }

  requestPermission() async {
    PluginUtil.printAppLog(logValue: "requestPermission Step 1");
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      onDeniedPermissionUpdateDefaultLocation();
      return false;
    }
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
      PluginUtil.printAppLog(logValue: "requestPermission Step 2");
      getLocation();
      locationIconVisibility.add(true);
      return true;
    } else {
      PluginUtil.printAppLog(logValue: "requestPermission Step 3");
      updateCameraPosition(latlng: getInitialLocation());
      locationIconVisibility.add(false);
      return false;
    }
  }

  getLocation() async {
    loadingController.add(true);
    locationPluginVar.enableBackgroundMode(enable: false);
    var location = await locationPluginVar.getLocation();
    PluginUtil.printAppLog(logValue: "Cureent location $location");
    updateCameraPosition(
        latlng: new LatLng(location.latitude!, location.longitude!));

    /*locationPluginVar.onLocationChanged.listen((locationPlugin.LocationData currentLocation) {
      // Use current location
      AppLogger.printLog("Cureent location location changed $currentLocation");
    });*/
  }

  void confirmLocation() {
    PlacePicker.pickResult!(getResult());
  }
}

final customGoogleMapBloc = CustomGoogleMapBloc();
