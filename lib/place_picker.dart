
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker/CustomGoogleMap.dart';
import 'package:location_picker/app_util.dart';
import 'package:location_picker/custom_google_map_bloc.dart';

class PlacePicker {
 static  Function? pickResult;

  static void openPlacePicker(
      {required LatLng initialPoint,
      required BuildContext buildContext,
      required Function result,
      required String googleApiKey,
        required Color themeColor
      }) {
    customGoogleMapBloc.setIntialLocation(intialLocation: initialPoint);
   customGoogleMapBloc.setBuildContext(buildContext: buildContext);
   customGoogleMapBloc.setGoogleKey(googleKey: googleApiKey);
   customGoogleMapBloc.setThemeColor(themeColor: themeColor);
   PluginUtil.setBuildContext(context: buildContext);
    pickResult=result;
    Navigator.push(buildContext,
        MaterialPageRoute(builder: (context) => LocationPickerGoogleMap()));
  }
}

final placePicker = PlacePicker();
