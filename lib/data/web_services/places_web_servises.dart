import 'package:dio/dio.dart';
import 'package:flutter_maps/constants/const.dart';

class PlacesWebServices {
  static late Dio dio;
//https://maps.googleapis.com/maps/api/place/
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/place/',
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
      'autocomplete/json',
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

  static Future<Map<String,dynamic>> getPlaceLocation({
    required String placeId,
    required String sessiontoken,
  }) async {
    Response res = await dio.get(
      'details/json',
      queryParameters: {
        'place_id': placeId,
        'fields': 'geometry',
        'key': apiKey,
        'sessiontoken': sessiontoken,
      },
    );

    return res.data;
  }


}
