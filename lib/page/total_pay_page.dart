import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/page/pay_page.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/transaction_card.dart';

class TotalPayPage extends StatefulWidget {
  const TotalPayPage({Key? key}) : super(key: key);

  static const route = '/totalpay';

  @override
  State<TotalPayPage> createState() => _TotalPayPageState();
}

class _TotalPayPageState extends State<TotalPayPage> {
  final docTransaction = FirebaseFirestore.instance.collection("transaction").snapshots();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  List<Goods> products = [];
  List uuidTransaction = [];

  int profit = 0;
  int omset = 0;

  Stream<int> setProfit(int value) {
    return Stream.value(profit += value);
  }

  Stream<int> getProfit() {
    return Stream.value(profit);
  }

  Stream<int> getOmset() {
    return Stream.value(profit);
  }

  Stream<int> setOmset(int value) {
    return Stream.value(omset += value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Bayar'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: docTransaction,
          builder: (context, snapshot) {
            products = [];
            profit = 0;
            omset = 0;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                for (var element in snapshot.data!.docs) {
                  if (element["user_id"] == userId) {
                    products.add(Goods.fromJson(element.data()));
                  }
                }
                return products.isEmpty
                    ? const Center(child: Text("Tidak ada transaksi"))
                    : Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (_, i) {
                                  var item = products[i];

                                  setProfit((item.sellPrice! - item.buyPrice!) * item.totalOrder!);
                                  setOmset(item.sellPrice! * item.totalOrder!);

                                  return TransactionCard(
                                    image: item.image,
                                    leading: SizedBox(width: 40, child: Text((i + 1).toString())),
                                    title: item.name!,
                                    subtitle: Text(
                                      '${item.totalOrder} x ${rupiah(item.sellPrice!)} = ${rupiah(item.totalOrder! * item.sellPrice!)}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        FirestoreHelper.delete(collectionName: 'transaction', documentID: item.uuid!);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: StreamBuilder<int>(
                                    stream: getProfit(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        'Keuntungan : ${rupiah(profit)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: primaryColor,
                                        ),
                                      );
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: StreamBuilder<int>(
                                    stream: getOmset(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        'Total Bayar : ${rupiah(omset)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                              child: MaterialButton(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
                                padding: const EdgeInsets.all(18),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PayPage(total: omset)));
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Lanjut',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
              }
            }
            return const Center(
              child: Text("Silahkan Tambah Pesanan"),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
