import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:room_finder/screens/add_new_room/add_new_room_screen.dart';
import 'package:room_finder/screens/login_screen/components/my_button.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {



  GoogleMapController? mapController;

   LatLng _selectedLocation = LatLng(25.4358,81.8463);

  Future<void> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _selectedLocation = LatLng(position.latitude, position.longitude);

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(flex: 1,
              child:GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(25.4358,81.8463),
                  zoom: 14.0,
                ),

                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                onTap: (LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                  });
                },
                markers: _selectedLocation == null
                    ? {}
                    : {
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: _selectedLocation,
                  ),
                },
              ),
            ),
            SizedBox(height: 10),
            MyButton(onTap:(){ Navigator.pop(context,_selectedLocation);}, buttonText: 'Select Location')
          ],
        ),
      ),
    );
  }
}
