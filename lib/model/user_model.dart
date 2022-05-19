class UserModel {
  String? uid;
  String? email;
  String? name;
  String? phone;
  String? cardKey;
  String? bin;
  String? endDate;
  bool? block;
  double? money;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.phone,
      this.bin,
      this.endDate,
      this.cardKey,
      this.block,
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
        block: map["block"]);
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
      "block": block,
    };
  }

  UserModel.update(UserModel u) {
    uid = u.uid;
    name = u.name;
    email = u.email;
    phone = u.phone;
    bin = u.bin;
    endDate = u.endDate;
    money = u.money;
    cardKey = u.cardKey;
    block = u.block;
  }
}

class Frinds {
  String? uid;
  String? email;
  String? name;
  String? cardKey;
  Frinds({this.name, this.cardKey, this.email, this.uid});
  factory Frinds.fromMap(map, {String? name}) {
    return Frinds(
      uid: map['uid'],
      email: map['email'],
      name: name ?? map['name'],
      cardKey: map["cardKey"],
    );
  }
  Map<String, dynamic> toMap({String? namee}) {
    return {
      'uid': uid,
      'email': email,
      'name': namee ?? name,
      "cardKey": cardKey,
    };
  }
}

class Invoice {
  String? uid;
  String? name;
  String? money;
  String? date;
  String? cardKey;
  String? state;
  Invoice(
      {this.uid, this.name, this.money, this.date, this.state, this.cardKey});
  factory Invoice.fromMap(map) {
    return Invoice(
      uid: map["uid"],
      name: map["name"],
      money: map["money"],
      date: map["date"],
      state: map["state"],
      cardKey: map["cardKey"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'money': money,
      'name': name,
      "date": date,
      "state": state,
      "cardKey": cardKey,
    };
  }
}
