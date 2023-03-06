import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/data/models/place_directions.dart';
import 'package:flutter_maps/data/models/place_model.dart';
import 'package:flutter_maps/data/models/place_suggestions%20_model.dart';
import 'package:flutter_maps/data/web_services/places_web_servises.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial());
  List<PlaceSuggestionsModel> suggestions = [];
  late Place place;

  static MapsCubit get(context) => BlocProvider.of(context);

  void getSuggestionsCubit(
      {required String place, required String sessiontoken}) async {
    emit(PlacesLoading());
    PlacesWebServices.getSuggestions(place: place, sessiontoken: sessiontoken)
        .then((value) {
      suggestions =
          value.map((e) => PlaceSuggestionsModel.fromJson(e)).toList();
      emit(PlacesLoadedSuccess(suggestions));
    }).catchError((onError) {
      emit(PlacesLoadedError(onError.toString()));
    });
  }

  void getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    emit(PlacesLocationLoading());
    PlacesWebServices.getPlaceLocation(
      placeId: placeId,
      sessiontoken: sessiontoken,
    ).then((value) {
      place = Place.fromJson(value);
      emit(PlacesLocationLoadedSuccess(place));
    }).catchError((onError) {
      emit(PlacesLocationLoadedError(onError.toString()));
    });
  }

  void getPlaceDirections({
    required LatLng origin,
    required LatLng destination,
  }) {
    emit(GetPlacesDirectionsLoading());
    PlacesWebServices.getDirections(
      origin: origin,
      destination: destination,
    ).then((value) {

    final  readyDirection = PlaceDirections.fromJson(value);
      emit(GetPlacesDirectionsSuccess(readyDirection));
    }).catchError((onError) {
      emit(GetPlacesDirectionsError(onError.toString()));
    });
  }
}
