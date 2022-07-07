import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker/app_util.dart';
import 'package:location_picker/buttons.dart';
import 'package:location_picker/custom_google_map_bloc.dart';
import 'package:location_picker/extensions.dart';
import 'package:location_picker/plugin_colors.dart';
import 'package:location_picker/text_styles.dart';

class LocationPickerGoogleMap extends StatefulWidget {
  const LocationPickerGoogleMap({Key? key}) : super(key: key);

  @override
  _LocationPickerGoogleMapState createState() => _LocationPickerGoogleMapState();
}

class _LocationPickerGoogleMapState extends State<LocationPickerGoogleMap> {
  @override
  void initState() {
    super.initState();
    customGoogleMapBloc.checkPermission();
    customGoogleMapBloc.addChangeListner();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Location Picker"),
              backgroundColor:customGoogleMapBloc.getThemeColor(),
            ),
            body: Stack(children: [
              GoogleMap(
                onTap: (argument) {
                  PluginUtil.closeKeyboard();
                  PluginUtil.printAppLog(logValue: "GestureDetector called");
                },
                //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: true,
                //enable Zoom in, out on map
                initialCameraPosition: CameraPosition(
                  //innital position in map
                  target: customGoogleMapBloc.getInitialLocation()!,
                  //initial position
                  zoom: 2.0, //initial zoom level
                ),
                mapType: MapType.normal,
                //map type
                onMapCreated: (controller) {
                  //method called when map is created
                  customGoogleMapBloc.mapController = controller;
                },
                onCameraMove: (CameraPosition cameraPosition) {
                  customGoogleMapBloc.setCameraPosition(
                      cameraPosition: cameraPosition);
                },
                onCameraIdle: () async {
                  if (customGoogleMapBloc.getCameraPosition() != null) {
                    PluginUtil.printAppLog(logValue: "onCameraIdle called");
                    customGoogleMapBloc.cameraIdleGetLocation(
                        latitude: customGoogleMapBloc
                            .getCameraPosition()!
                            .target
                            .latitude,
                        longitude: customGoogleMapBloc
                            .getCameraPosition()!
                            .target
                            .longitude);
                  }
                },
              ),
              Center(
                  //picker image on google map
                  child: Icon(Icons.location_on_rounded)),
              Align(
                  //widget to display location name
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: StreamBuilder<bool>(
                          stream: customGoogleMapBloc.loadingController,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return getLocationWidget(loading: snapshot.data);
                            }
                            if(snapshot.hasError)
                              {
                                return Padding(padding: EdgeInsets.all(20),
                                  child: Text('${snapshot.error}'),
                                );
                              }
                            return SizedBox();
                          }),
                    ),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: getSearchPlaces(),
              ),
              StreamBuilder<bool>(
                  stream: customGoogleMapBloc.locationIconVisibility,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!) {
                      return  Positioned(
                        bottom: 195,
                        right: 5,
                        child:
                        InkWell(
                          onTap: () {
                            customGoogleMapBloc.checkPermission();
                          },
                          child:   Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: customGoogleMapBloc.getThemeColor(),
                              // color: CfColors.primary,
                              border: Border.all(width: 1, color: customGoogleMapBloc.getThemeColor()!),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: PluginColors.white,
                            ),
                          ),
                        ),

                      );
                    }

                    return SizedBox();
                  }),

            ])));
  }

  getSearchPlaces() {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              controller: customGoogleMapBloc.placeEditController,
              decoration: InputDecoration(
                hintText: "Seek your location here",
                focusColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.map),
                suffixIcon: StreamBuilder<bool>(
                    stream: customGoogleMapBloc.clearIconVisibility,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              customGoogleMapBloc.clearTheTextSearchField();
                            },
                          );
                        }
                      }
                      return SizedBox();
                    }),
              ),
            ),
          ),
          StreamBuilder<bool>(
              stream: customGoogleMapBloc.searchLoadingController,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return CircularProgressIndicator();
                  } else {
                    if (customGoogleMapBloc.placeList!.isNotEmpty) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: customGoogleMapBloc.placeList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              customGoogleMapBloc.onSelectLocation(
                                  prediction:
                                      customGoogleMapBloc.placeList![index]);
                              customGoogleMapBloc.clearTheTextSearchField();
                            },
                            child: ListTile(
                              title: Text(customGoogleMapBloc
                                  .placeList![index].description!),
                            ),
                          );
                        },
                      );
                    } else {
                      if (customGoogleMapBloc.placeEditController.text.length >
                          2) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 10, top: 5, bottom: 10),
                          child: Column(
                            children: [
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              20.heightBox,
                              Text(
                                "No Result Found!",
                                style: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }
                  }
                }
                return SizedBox();
              }),
        ],
      ),
    );
  }

  getLocationWidget({bool? loading}) {
    return Container(
      decoration: BoxDecoration(
        // color: CfColors.primary,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.heightBox,
            Text(
              'Choose/Search customer delivery location on map',
              style: CfTextStyles.getTextStyle(
                TStyle.b1_600,
                customStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: PluginColors.textGrey),
              ),
            ),
            15.heightBox,
            Text(
              (() {
                if (loading!) {
                  return "Fetching location...";
                }
                return customGoogleMapBloc.getLocationAddress();
              }()),
              style: CfTextStyles.getTextStyle(
                TStyle.b2_600,
                customStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            15.heightBox,
            (() {
              if (loading!) {
                return cfCircularButton(
                  isProgress: true,
                  onPressed: () {},
                  cornerRadius: 10,
                  text: 'Confirm Location',
                );
              }

              return cfCircularButton(
                isProgress: false,
                onPressed: () {
                  customGoogleMapBloc.confirmLocation();
                },
                cornerRadius: 10,
                text: 'Confirm Location',
              );
            }()),
          ],
        ),
      ),
    );
  }
}
