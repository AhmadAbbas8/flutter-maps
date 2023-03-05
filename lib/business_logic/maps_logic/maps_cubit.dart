import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/data/models/place_suggestions%20_model.dart';
import 'package:flutter_maps/data/web_services/places_web_servises.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial());
  List<PlaceSuggestionsModel> suggestions = [];

  static MapsCubit get(context) => BlocProvider.of(context);

  void getSuggestionsCubit(
      {required String place, required String sessiontoken}) async {
    emit(PlacesLoading());
    PlacesWebServices.getSuggestions(place: place, sessiontoken: sessiontoken)
        .then((value) {
      suggestions =
          value.map((e) => PlaceSuggestionsModel.fromJson(e)).toList();
      print('###########################################${suggestions[0].description}');
      emit(PlacesLoadedSuccess(suggestions));
    }).catchError((onError) {
      print(onError.toString());
      emit(PlacesLoadedError(onError.toString()));
    });
  }
}
