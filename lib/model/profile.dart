class Profile {
  Profile({
    this.id,
    this.name,
    this.password,
    this.phone,
    this.email,
    this.image,
    this.address,
    this.shopName,
  });

  final String? id;
  final String? name;
  final String? password;
  final String? phone;
  final String? email;
  final String? image;
  final String? address;
  final String? shopName;

  Profile copyWith({
    String? id,
    String? name,
    String? password,
    String? phone,
    String? email,
    String? image,
    String? address,
    String? shopName,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        image: image ?? this.image,
        address: address ?? this.address,
        shopName: shopName ?? this.shopName,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        address: json["address"],
        shopName: json["shop_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "phone": phone,
        "email": email,
        "image": image,
        "address": address,
        "shop_name": shopName,
      };
}
