import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/business_logic/phone_auth/phone_auth_state.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/helper/loacation_helper.dart';
import 'package:flutter_maps/presentation/screens/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position? position;
  static final CameraPosition _myCurrentLocation = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );
  Completer<GoogleMapController> _mapController = Completer();

  Future<void> getCurrentLocation() async {
    position =  await LocationHelper.getCurrentLocation().whenComplete(() {setState(() {

    });});
    // position = await Geolocator.getLastKnownPosition().whenComplete(() {
    //   setState(() {});
    // });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Map'),
          ),
          body: Stack(
            children: [
              position != null
                  ? buildMap()
                  : Center(
                      child: CircularProgressIndicator(
                        color: MyColors.myBlue,
                      ),
                    ),
            ],
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
            child: FloatingActionButton(
              backgroundColor: MyColors.myBlue,
              onPressed: _goToMyCurrentLocation,
              child: Icon(
                Icons.place,
                color: MyColors.myWhite,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      initialCameraPosition: _myCurrentLocation,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_myCurrentLocation),
    );
  }
}
