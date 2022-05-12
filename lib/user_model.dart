class UserModel {
  String? uid;
  String? email;
  String? name;
  String? phone;
  String? cardKey;
  String? bin;
  String? endDate;
  double? money;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.phone,
      this.bin,
      this.endDate,
      this.cardKey,
      this.money});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      bin: map['bin'],
      endDate: map['endDate'],
      money: map["money"],
      cardKey: map["cardKey"],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'bin': bin,
      'endDate': endDate,
      "money": money,
      "cardKey": cardKey,
    };
  }
}
