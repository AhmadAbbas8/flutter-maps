class PlaceSuggestionsModel {
  late String placeId;
  late String description;

  PlaceSuggestionsModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    description = json['description'];
  }
}
