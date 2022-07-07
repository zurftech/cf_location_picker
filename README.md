## Captain Fresh Location picker for the ease the process of choose the location by user.

## Features

* Pick single location 
* Display Google Maps
* Can Work with bloc pattern 
* Customisation of theme color
* Search for the location using google places api.



## Getting started

At first you have to put your configration settings



``` 
## In AndroidManifest.xml put this code with google api key for load the google map in your app.

    <meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_KEY_HERE"/>
```


## Usage
* Use this below code to open the location picker.

> OpenMapLocationPicker
```dart
   PlacePicker.openPlacePicker(
                 initialPoint: new LatLng(28.9716, 77.5946), // Pass the lat lng of the initial point or default location.
                 result: (PickResult pickResult) {
                 //You will get the selected location here 
                 print(pickResult.formattedAddress);
                 },
                 buildContext: context,
                 themeColor:Colors.red, // Your theme color here 
               googleApiKey: "YOUR_GOOGLE_API_KEY_HERE"
             );
    
```


