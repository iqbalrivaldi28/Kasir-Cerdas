class Cart {
  Cart({
    this.profit,
    this.subTotal,
    this.cash,
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
    this.idTransacation,
  });
  final int? profit;
  final String? uuid;
  final String? image;
  final String? userId;
  final String? name;
  final int? sellPrice;
  final int? buyPrice;
  final int? subTotal;
  final int? cash;
  final String? code;
  final int? stock;
  final DateTime? date;
  final int? totalOrder;
  final String? idTransacation;

  Cart copyWith(
          {int? profit,
          String? uuid,
          String? image,
          String? userId,
          String? name,
          int? sellPrice,
          int? buyPrice,
          int? cash,
          String? code,
          int? stock,
          DateTime? date,
          int? totalOrder,
          int? subTotal,
          String? idTransacation}) =>
      Cart(
        cash: cash ?? this.cash,
        profit: profit ?? this.profit,
        subTotal: subTotal ?? this.subTotal,
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
        idTransacation: idTransacation ?? this.idTransacation,
      );

  static Cart fromJson(Map<String?, dynamic> json) => Cart(
      uuid: json["uuid"],
      image: json["image"],
      name: json["name"],
      userId: json["user_id"],
      sellPrice: json["sell_price"],
      buyPrice: json["buy_price"],
      code: json["code"],
      stock: json["stock"],
      totalOrder: json["total_order"],
      cash: json["cash"],
      date: DateTime.parse(json["date"]),
      profit: json["profit"],
      subTotal: json["sub_total"],
      idTransacation: json["id_transaction"]);

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
        "cash": cash,
        "profit": profit,
        "sub_total": subTotal,
        "id_transaction": idTransacation,
      };
}
