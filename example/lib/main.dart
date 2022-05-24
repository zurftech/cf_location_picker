import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker/app_util.dart';
import 'package:location_picker/location_picker.dart';
import 'package:location_picker/pick_result.dart';
import 'package:location_picker/place_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await LocationPicker.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
   return  Scaffold(
       appBar: AppBar(
         title: const Text('Plugin example app'),
       ),
       body:   Center(
         child: InkWell(
           onTap: () {
             PluginUtil.printAppLog(logValue: "Click i am");
             PlacePicker.openPlacePicker(
                 initialPoint: new LatLng(28.9716, 77.5946),
                 result: (PickResult pickResult) {
                   PluginUtil.printAppLog(logValue:'i am called ${pickResult.formattedAddress}');
                 },
                 buildContext: context,
               googleApiKey: ""
             );
           },
           child:
           Text('Running on: \n'),
         ),

       )
   );


  }

}
