


class CreateUserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? password;

  CreateUserModel(
      {this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.password});

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    return data;
  }
}
