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
