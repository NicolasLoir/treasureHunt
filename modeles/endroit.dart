class Endroit {
  int id;
  String designation;
  double lat;
  double lon;
  String image;
  String indication;

  Endroit(this.id, this.designation, this.lat, this.lon, this.image,
      this.indication);

  Map<String, dynamic> toMap() {
    return {
      'idEndroit': (id == 0) ? null : id,
      'designation': designation,
      'latitude': lat,
      'longitude': lon,
      'image': image,
      'indication': indication
    };
  }
}
