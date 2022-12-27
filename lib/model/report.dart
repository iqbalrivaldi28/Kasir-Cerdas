class Report {
  Report({
    this.uuid,
    this.userId,
    this.totalTransaction,
    this.profit,
    this.income,
    this.date,
  });
  final String? uuid;
  final String? userId;
  final int? totalTransaction;
  final int? profit;
  final int? income;
  final DateTime? date;

  Report copyWith({
    String? uuid,
    String? userId,
    int? totalTransaction,
    int? profit,
    int? income,
    DateTime? date,
  }) =>
      Report(
        uuid: uuid ?? this.uuid,
        userId: userId ?? this.userId,
        totalTransaction: totalTransaction ?? this.totalTransaction,
        profit: profit ?? this.totalTransaction,
        income: income ?? this.income,
        date: date ?? this.date,
      );

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        uuid: json["uuid"],
        userId: json["user_id"],
        totalTransaction: json["total_transaction"],
        profit: json["profit"],
        income: json["income"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "user_id": userId,
        "total_transaction": totalTransaction,
        "profit": profit,
        "income": income,
        "date": date,
      };
}
