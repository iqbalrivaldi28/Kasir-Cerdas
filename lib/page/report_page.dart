import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/services/session.dart';

import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/report_card.dart';

import '../api/firestore.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  static const route = '/report';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  int getLength(List data) {
    int length = 0;
    for (var element in data) {
      if (element["user_id"] == userId) {
        length++;
      }
    }
    return length;
  }

  int getProfit(List data) {
    int profit = 0;
    for (var element in data) {
      if (element["user_id"] == userId) {
        profit += int.tryParse(element["profit"].toString()) ?? 0;
      }
    }
    return profit;
  }

  int getIncome(List data) {
    int income = 0;
    for (var element in data) {
      if (element['user_id'] == userId) {
        final sellPrice = int.tryParse(element['sell_price'].toString()) ?? 0;
        final totalOrder = int.tryParse(element['total_order'].toString()) ?? 0;
        final omset = sellPrice * totalOrder;
        income += omset;
      }
    }
    return income;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final docReport = FirestoreHelper.getReport();
    return Scaffold(
      body: FutureBuilder<List<dynamic>?>(
          future: docReport,
          builder: (context, snapshot) {
            List data = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Laporan Keuangan',
                    style: titleStyle,
                  ),
                  Text(
                    Session.user.shopName ?? 'TOKO',
                  ),
                  lvDivider,
                  ReportCard(
                    title: getLength(data).toString(),
                    subtitle: 'Jumlah Transaksi',
                  ),
                  mvDivider,
                  ReportCard(
                    title: rupiah(getProfit(data)),
                    subtitle: 'Keuntungan',
                  ),
                  mvDivider,
                  ReportCard(
                    title: rupiah(getIncome(data)),
                    subtitle: 'Pendapatan',
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class MyDropdown extends StatelessWidget {
  const MyDropdown({
    Key? key,
    required this.value,
    this.onChanged,
    required this.items,
  }) : super(key: key);

  final String value;
  final Function(String?)? onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: mbRadius,
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      underline: const SizedBox(),
      isDense: true,
      isExpanded: true,
      onChanged: onChanged,
    );
  }
}
