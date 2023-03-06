import 'package:dio/dio.dart';
import 'package:flutter_maps/constants/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesWebServices {
  static late Dio dio;

//https://maps.googleapis.com/maps/api/place/
  //https://maps.googleapis.com/maps/api/directions/json
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );
  }

  static Future<List<dynamic>> getSuggestions({
    required String place,
    required String sessiontoken,
  }) async {
    Response res = await dio.get(
      'place/autocomplete/json',
      queryParameters: {
        'input': place,
        'type': 'address',
        'components': 'country:eg',
        'key': apiKey,
        'sessiontoken': sessiontoken,
      },
    );
    return res.data['predictions'];
  }

  static Future<Map<String, dynamic>> getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    Response res = await dio.get(
      'place/details/json',
      queryParameters: {
        'place_id': placeId,
        'fields': 'geometry',
        'key': apiKey,
        'sessiontoken': sessiontoken,
      },
    );

    return res.data;
  }

// origin is current location or placeId
  static   Future<Map<String,dynamic>> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    Response res = await dio.get(
      'directions/json',
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
      },
    );

    return res.data;
  }
}
