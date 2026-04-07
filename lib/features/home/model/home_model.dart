class HomeModel {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  HomeModel({this.userId, this.id, this.title, this.body});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
