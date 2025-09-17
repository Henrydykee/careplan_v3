


class LoginResponseModel {
  String? message;
  String? access;
  String? refresh;

  LoginResponseModel({this.message, this.access, this.refresh});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    access = json['access'];
    refresh = json['refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access'] = this.access;
    data['refresh'] = this.refresh;
    return data;
  }
}
