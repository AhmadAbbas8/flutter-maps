part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}
class PlacesLoading extends MapsState{}
class PlacesLoadedSuccess extends MapsState{
 final List<PlaceSuggestionsModel> suggestions ;

  PlacesLoadedSuccess(this.suggestions);
}
class PlacesLoadedError extends MapsState{
  final String error;

  PlacesLoadedError(this.error);
}


class PlacesLocationLoading extends MapsState{}
class PlacesLocationLoadedSuccess extends MapsState{
 final Place place ;

  PlacesLocationLoadedSuccess(this.place);
}
class PlacesLocationLoadedError extends MapsState{
  final String error;

  PlacesLocationLoadedError(this.error);
}


class GetPlacesDirectionsLoading extends MapsState{}
class GetPlacesDirectionsSuccess extends MapsState{
 final PlaceDirections readyDirection;
  GetPlacesDirectionsSuccess(this.readyDirection);

}
class GetPlacesDirectionsError extends MapsState{
  final String error;

  GetPlacesDirectionsError(this.error);
}
