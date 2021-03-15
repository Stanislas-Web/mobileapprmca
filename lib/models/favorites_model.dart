class Favorite {
  final int id;
  final String nomEmission;
  final String photoEmission;
  final String description;
  final String streamUrl;
  final String duree;

  Favorite(
      {this.id,
      this.nomEmission,
      this.photoEmission,
      this.description,
      this.streamUrl,
      this.duree});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomEmission': nomEmission,
      'photoEmission': photoEmission,
      'description': description,
      'streamUrl': streamUrl,
      'duree': duree,
    };
  }
}
