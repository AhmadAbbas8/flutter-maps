import 'package:dio/dio.dart';
import 'package:flutter_maps/constants/const.dart';

class PlacesWebServices {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/place/autocomplete/json',
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
      '',
      queryParameters: {
        'input': place,
        'type': 'address',
        'components': 'country:eg',
        'key': apiKey,
        'sessiontoken': sessiontoken,
      },
    );
    print(res.data['predictions']);
    print('********************************${res.statusCode}');
    return res.data['predictions'];
  }
}
