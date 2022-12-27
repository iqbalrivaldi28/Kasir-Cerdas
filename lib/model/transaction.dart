class TransactionData {
  TransactionData({
    this.uuid,
    this.image,
    this.name,
    this.userId,
    this.sellPrice,
    this.buyPrice,
    this.code,
    this.stock,
    this.date,
    this.totalOrder,
  });

  final String? uuid;
  final String? image;
  final String? userId;
  final String? name;
  final int? sellPrice;
  final int? buyPrice;
  final String? code;
  final int? stock;
  final DateTime? date;
  final int? totalOrder;

  TransactionData copyWith(
          {String? uuid,
          String? image,
          String? userId,
          String? name,
          int? sellPrice,
          int? buyPrice,
          String? code,
          int? stock,
          DateTime? date,
          int? totalOrder}) =>
      TransactionData(
        uuid: uuid ?? this.uuid,
        image: image ?? this.image,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        sellPrice: sellPrice ?? this.sellPrice,
        buyPrice: buyPrice ?? this.buyPrice,
        code: code ?? this.code,
        stock: stock ?? this.stock,
        date: date ?? this.date,
        totalOrder: totalOrder ?? this.totalOrder,
      );

  static TransactionData fromJson(Map<String?, dynamic> json) =>
      TransactionData(
          uuid: json["uuid"],
          image: json["image"],
          name: json["name"],
          userId: json["user_id"],
          sellPrice: json["sell_price"],
          buyPrice: json["buy_price"],
          code: json["code"],
          stock: json["stock"],
          totalOrder: json["total_order"]);

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "image": image,
        "name": name,
        "user_id": userId,
        "sell_price": sellPrice,
        "buy_price": buyPrice,
        "code": code,
        "stock": stock,
        "date": date.toString(),
        "total_order": totalOrder,
      };
}
