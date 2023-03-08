class PhotoModel {
  String? id;
  String? createdAt;
  Map<String, dynamic>? urls;

  PhotoModel({this.id, this.createdAt, this.urls});

  PhotoModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    urls = json['urls'];
  }
}
