class UserModel {
  bool? isAdmin;
  String? sId;
  String? name;
  String? email;
  String? password;
  int? phone;
  String? city;
  String? registrationDate;
  int? iV;
  String? pushToken;

  UserModel(
      {this.isAdmin,
      this.sId,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.city,
      this.registrationDate,
      this.iV,
      this.pushToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    isAdmin = json['isAdmin'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    city = json['city'];
    registrationDate = json['registrationDate'];
    iV = json['__v'];
    pushToken = json['pushToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAdmin'] = this.isAdmin;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['registrationDate'] = this.registrationDate;
    data['__v'] = this.iV;
    data['pushToken'] = this.pushToken;
    return data;
  }
}
