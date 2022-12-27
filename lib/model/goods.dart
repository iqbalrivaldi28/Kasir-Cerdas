class Goods {
  Goods({
    this.uuid,
    this.image,
    this.name,
    this.userId,
    this.sellPrice,
    this.buyPrice,
    this.code,
    this.stock,
    this.totalOrder,
    this.date,
    this.profit,
  });
  final int? profit;
  final String? uuid;
  final String? image;
  final String? userId;
  final String? name;
  final int? sellPrice;
  final int? buyPrice;
  final String? code;
  final int? stock;
  final int? totalOrder;
  final DateTime? date;

  Goods copyWith({
    int? profit,
    String? uuid,
    String? image,
    String? userId,
    String? name,
    int? sellPrice,
    int? buyPrice,
    String? code,
    int? stock,
    int? totalOrder,
    DateTime? date,
  }) =>
      Goods(
        profit: profit ?? this.profit,
        uuid: uuid ?? this.uuid,
        image: image ?? this.image,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        sellPrice: sellPrice ?? this.sellPrice,
        buyPrice: buyPrice ?? this.buyPrice,
        code: code ?? this.code,
        stock: stock ?? this.stock,
        totalOrder: totalOrder ?? this.totalOrder,
        date: date ?? this.date,
      );

  factory Goods.fromJson(Map<String?, dynamic> json) => Goods(
        profit: json["profit"],
        uuid: json["uuid"],
        image: json["image"],
        name: json["name"],
        userId: json["user_id"],
        sellPrice: json["sell_price"],
        buyPrice: json["buy_price"],
        code: json["code"],
        stock: json["stock"],
        totalOrder: json["total_order"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "profit": profit,
        "uuid": uuid,
        "image": image,
        "name": name,
        "user_id": userId,
        "sell_price": sellPrice,
        "buy_price": buyPrice,
        "code": code,
        "stock": stock,
        "total_order": totalOrder,
        "date": date.toString(),
      };
}
