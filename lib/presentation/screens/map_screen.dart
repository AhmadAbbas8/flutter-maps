import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/maps_logic/maps_cubit.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/data/models/place_model.dart';
import 'package:flutter_maps/data/models/place_suggestions%20_model.dart';
import 'package:flutter_maps/helper/location_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_maps/presentation/widgets/my_drawer.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../widgets/place_item.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position? position;
  late List<PlaceSuggestionsModel> places;

  FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  static final CameraPosition _myCurrentLocation = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );
  Completer<GoogleMapController> _mapController = Completer();

  Set<Marker> markers = Set();
  late PlaceSuggestionsModel placeSuggestion;
  late Place selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSearchedForPlace;

  void buildCameraNewPosition() {
    goToSearchedForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result!.geometry!.location!.lat!,
        selectedPlace.result!.geometry!.location!.lng!,
      ),
      zoom: 13,
    );
  }

  Future<void> getCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
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
    return BlocConsumer<MapsCubit, MapsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text('Map'),
          // ),
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ConditionalBuilder(
                  condition: position != null,
                  builder: (context) => buildMap(),
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.myBlue,
                    ),
                  ),
                ),
                buildFloatingSearchBar(),
              ],
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
            child: FloatingActionButton(
              backgroundColor: MyColors.myBlue,
              onPressed: _goToMyCurrentLocation,
              child: const Icon(
                Icons.place,
                color: MyColors.myWhite,
              ),
            ),
          ),
          drawer: MyDrawer(),
        );
      },
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        return FloatingSearchBar(
          controller: _floatingSearchBarController,
          hint: 'Search...',
          elevation: 6,
          hintStyle: TextStyle(fontSize: 18),
          queryStyle: TextStyle(fontSize: 18),
          border: BorderSide(style: BorderStyle.none),
          margins: EdgeInsets.fromLTRB(20, 50, 20, 0),
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          height: 52,
          iconColor: MyColors.myBlue,
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 600),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          axisAlignment: isPortrait ? 0.0 : -1.0,
          openAxisAlignment: 0.0,
          width: isPortrait ? 600 : 500,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            getSuggestions(query);
          },
          onFocusChanged: (isFocused) {},
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: Icon(
                  Icons.place,
                  color: MyColors.myBlack.withOpacity(0.6),
                ),
                onPressed: () {},
              ),
            ),
            // FloatingSearchBarAction.searchToClear(
            //   showIfClosed: false,
            // ),
          ],
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  children: [
                    if (state is PlacesLoading)
                      Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: MapsCubit.get(context).suggestions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              placeSuggestion =
                                  MapsCubit.get(context).suggestions[index];
                              _floatingSearchBarController.close();
                              getSelectedPlacedLocation();
                              // TODO
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsetsDirectional.all(8),
                              padding: EdgeInsetsDirectional.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyColors.myLightBlue,
                                      ),
                                      child: Icon(
                                        Icons.place,
                                        color: MyColors.myBlue,
                                      ),
                                    ),
                                    title: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${MapsCubit.get(context).suggestions[index].description.split(',')[0]}\n',
                                          style: TextStyle(
                                            color: MyColors.myBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: MapsCubit.get(context)
                                              .suggestions[index]
                                              .description
                                              .replaceAll(
                                                  MapsCubit.get(context)
                                                      .suggestions[index]
                                                      .description
                                                      .split(',')[0],
                                                  '')
                                              .substring(2),
                                          style: TextStyle(
                                            color: MyColors.myBlack,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    buildSelectedPlaceLocationBloc(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void getSelectedPlacedLocation() {
    final sessiontoken = Uuid().v4();
    MapsCubit.get(context).getPlaceLocation(
      placeId: placeSuggestion.placeId,
      sessiontoken: sessiontoken,
    );
  }

  Widget buildMap() {
    return GoogleMap(
      markers: markers,
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

  Widget buildSuggestionsCubit() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PlacesLoadedSuccess) {
          places = state.suggestions;
          if (places != 0) {
            return buildPlacesList();
          } else
            return Container();
        } else
          return Container();
      },
    );
  }

  Widget buildPlacesList() {
    return ListView.builder(
      itemCount: MapsCubit.get(context).suggestions.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        InkWell(
          onTap: () {
            _floatingSearchBarController.close();
          },
          child:
              PlaceItem(suggestions: MapsCubit.get(context).suggestions[index]),
        );
      },
    );
  }

  void getSuggestions(String query) {
    final sessiontoken = Uuid().v4();
    MapsCubit.get(context)
        .getSuggestionsCubit(place: query, sessiontoken: sessiontoken);
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlacesLocationLoadedSuccess) {
          selectedPlace = state.place;
          goToMySearchedForLocation();
        }
      },
      child: Container(),
    );
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController googleMapController = await _mapController.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      markerId: MarkerId('2'),
      position: goToSearchedForPlace.target,
      onTap: () {
        buildCurrentLocationMarker();
      },
      infoWindow: InfoWindow(
        title: '${placeSuggestion.description}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUI(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(position!.latitude, position!.longitude),
      infoWindow: const InfoWindow(
        title: 'your Current Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUI(currentLocationMarker);
  }

  void addMarkerToMarkersAndUpdateUI(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }
}
