class DataModel {
  List posts;
  List walls;
  List pros;
  List users;
  List banned;
  List promotes;
  List avatars;
  List reports;
  List testimonies;
  List allActiveUsers;
  List ratings;
  List verificationRequest;
  String terms;

  DataModel.fromJson(Map<String, dynamic> json)
      : posts = json['posts'],
        walls = json['walls'],
        pros = json['pros'],
        terms = json['terms'],
        users = json['users'],
        banned = json['banned'],
        promotes = json['promotes'],
        avatars = json['avatars'],
        reports = json['reports'],
        testimonies = json['testimonies'],
        ratings = json['ratings'],
        allActiveUsers = json['allActiveUsers'],
        verificationRequest = json['verificationRequest'];
}
