import 'package:dio/dio.dart';
import 'package:flutter_maps/constants/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesWebServices {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  static Future<List<dynamic>> getSuggestions({
    required String place,
    required String sessiontoken,
  }) async {
    Response res = await dio.get(
      suggestionAautocompleteEndPoint,
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
      placesLocationDetailsEndPoint,
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
      directionsEndPoint,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
      },
    );

    return res.data;
  }
}
