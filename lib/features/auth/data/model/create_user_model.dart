class CreateUserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? password;
  String? confirmPassword;

  CreateUserModel({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.password,
    this.confirmPassword,
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['type'] = 'Patient';
    return data;
  }
}
