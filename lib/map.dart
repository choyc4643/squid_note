import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart';
// import 'main.dart';



class MapMarker extends StatefulWidget{
  // late final Function(String) onchangeLocation;

  @override

  // MapMarker({
  //   required this.onchangeLocation,
  // });

  _MapMarkerState createState() => _MapMarkerState();
}

var onchangeLocation;


class _MapMarkerState extends State<MapMarker> {
  String googleApikey = "AIzaSyAHYxrupHnzvDGMod089DRiTi9D3Cq3cik";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(36.08871700, 129.39664200);
  String location = "지번:";



  @override
  Widget build(BuildContext context) {
    return  Stack(
            children:[
              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: startLocation, //initial position
                  zoom: 15.0, //initial zoom level
                ),
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
                myLocationEnabled: true,

                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona; //when map is dragging
                },
                onCameraIdle: () async { //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                  setState(() { //get place name from lat and lang
                    location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                    onchangeLocation=location as String;
                  });
                },
              ),

              Center( //picker image on google map
                child: Image.asset("assets/marker.png", width: 15,),
              ),


              Positioned(  //widget to display location name
                  bottom:10,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            leading: Image.asset("assets/marker.png", width: 30,),
                            title:Text(location, style: TextStyle(fontSize: 18),),
                            dense: true,
                          )
                      ),
                    ),
                  )
              )
            ]
    );
  }

  //move current location
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}