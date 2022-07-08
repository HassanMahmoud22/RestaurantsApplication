class Stores {
  final String? id;
  final String? storeName;
  final String? description;
  final String? photo;
  final String? latitude;
  final String? longitude;

  Stores({this.id, this.storeName, this.description, this.photo, this.latitude, this.longitude});

  Stores.fromJson(Map<String, dynamic> json):
    id = json["id"],
    storeName = json["storeName"],
    description = json["description"],
    photo = json["photo"],
    latitude = json["latitude"],
    longitude = json["longitude"]; 
}
