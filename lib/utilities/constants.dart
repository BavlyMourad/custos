import 'package:flutter/material.dart';

// Style for status text in the home screen
const kStatusTextStyle = TextStyle(
    fontSize: 35.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
);

// Style for the label of the navigation list in the drawer
const kNavLabelTextStyle = TextStyle(
    color: Color(0xFF777777),
    fontSize: 17.0,
    fontWeight: FontWeight.w400,
);

// Style for the random tip's title and primary's, other's contacts title
const kTitleTextStyle = TextStyle(
    color: Color(0xFF4682B4),
    fontSize: 27.0,
);

// Style for the random tip's description
const kTipBodyTextStyle = TextStyle(
    fontSize: 17.0,
    height: 1.5,
    color: Color(0xFF5E5C5C),
);

// Style for the app name in sign in and sign up screens
const kAppTitleTextStyle = TextStyle(
    fontSize: 40.0,
    color: Colors.white,
);

// Style for the text form field
const kTextFormFieldDecoration = InputDecoration(
    prefixIcon: null,
    suffixIcon: null,
    hintText: null,
    hintStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
            color: Color(0xFFBDBDBD),
        ),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
            color: Color(0xFF4682B4),
        ),
    ),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
            color: Color(0xFF4682B4),
        ),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
);

// Style for the enabled border text field in the login and register screens
const kAuthFieldDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
        color: Colors.white,
    ),
);

// Style for text form field value
const kTextFieldValueDecoration = TextStyle(
  color: Color(0xFF5E5C5C),
);

// Style for empty message text in the saved tips screen
const kEmptySavedTips = TextStyle(
    fontSize: 18.0,
    color: Color(0xFF616161)
);

// Style for texts in settings screen
const kSettingsText = TextStyle(
    fontSize: 15.0,
    color: Color(0xFF616161)
);

// FirebaseStorage Bucket
const kStorageBucket = 'gs://custos-273806.appspot.com';

// Google maps night theme
const kMapNightTheme = [
    {
        "elementType": "geometry",
        "stylers": [
            {"color": "#242f3e"}
        ]
    },
    {
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#746855"}
        ]
    },
    {
        "elementType": "labels.text.stroke",
        "stylers": [
            {"color": "#242f3e"}
        ]
    },
    {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#d59563"}
        ]
    },
    {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#d59563"}
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
            {"color": "#263c3f"}
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#6b9a76"}
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {"color": "#38414e"}
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
            {"color": "#212a37"}
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#9ca5b3"}
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
            {"color": "#746855"}
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {"color": "#1f2835"}
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#f3d19c"}
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {"color": "#2f3948"}
        ]
    },
    {
        "featureType": "transit.station",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#d59563"}
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {"color": "#17263c"}
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
            {"color": "#515c6d"}
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
            {"color": "#17263c"}
        ]
    }
];