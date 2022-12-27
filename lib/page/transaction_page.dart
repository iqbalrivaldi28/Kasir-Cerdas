import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/page/scanner_page.dart';
import 'package:kasir_cerdas/page/total_pay_page.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/add_goods_dialog.dart';
import 'package:kasir_cerdas/widget/long_fab.dart';
import 'package:kasir_cerdas/widget/transaction_card.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({
    Key? key,
  }) : super(key: key);

  static const route = '/transaction';

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final docTransaction = FirebaseFirestore.instance.collection("transaction").snapshots();
  @override
  void initState() {
    codeController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshCode();
    });
  }

  refresh({String? query, String? qrCode}) {
    FirestoreHelper.getProduct().then((value) {
      List<Goods> data = [];
      if (query != null && query.isNotEmpty) {
        data = value.map((e) => Goods.fromJson(e)).toList().where((e) => e.name!.toLowerCase().contains(query.toLowerCase())).toList();
      } else if (qrCode != null && qrCode.isNotEmpty) {
        data = value.map((e) => Goods.fromJson(e)).toList().where((e) => e.code!.toLowerCase().contains(qrCode.toLowerCase())).toList();
      } else {
        data = value.map((e) => Goods.fromJson(e)).toList();
      }
      setState(() {
        products = data;
      });
    });
  }

  refreshCode({String? query}) {
    FirestoreHelper.getProduct().then((value) {
      List<Goods> data = [];
      if (query != null && query.isNotEmpty) {
        data = value.map((e) => Goods.fromJson(e)).toList().where((e) => e.code!.toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        data = value.map((e) => Goods.fromJson(e)).toList();
      }
      setState(() {
        products = data;
      });
    });
  }

  List<Goods> goods() {
    List<Goods> goods = [];
    for (var i = 0; i < products.length; i++) {
      if (products[i].userId == userId) {
        goods.add(Goods(
          buyPrice: products[i].buyPrice,
          code: products[i].code,
          date: products[i].date,
          image: products[i].image,
          name: products[i].name,
          sellPrice: products[i].sellPrice,
          stock: products[i].stock,
          userId: products[i].userId,
          uuid: products[i].uuid,
        ));
      }
    }
    return goods;
  }

  late final TextEditingController codeController;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  bool isVisible = true;
  List<Goods> products = [];
  List getLength() {
    List length = [];
    for (var i = 0; i < products.length; i++) {
      if (products[i].userId == userId) {
        length.add(products[i].userId);
      }
    }
    return length;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  bottom: 16,
                  right: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: codeController,
                        onChanged: (query) {
                          refresh(query: query);
                        },
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'Cari nama atau kode barang',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ScannerPage.route, arguments: (String v) {}).then((code) {
                          refresh(qrCode: code.toString());
                        });
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      splashRadius: 25,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: goods().length,
                itemBuilder: (_, i) {
                  var data = goods()[i];
                  if (goods().isNotEmpty) {
                    return TransactionCard(
                      title: data.name!,
                      image: data.image,
                      onTap: () {
                        if (data.stock! > 0) {
                          showDialog(
                            context: context,
                            builder: (_) => AddGoodsDialog(uuid: data.uuid),
                          );
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(.2),
                              builder: (_) => const Dialog(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    child: SizedBox(
                                      height: 120,
                                      width: 80,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                          child: Text(
                                            "Stok kosong!",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                        }
                      },
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sisa ${data.stock} - ${rupiah(data.sellPrice!)}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'code ${data.code}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                        ),
                        child: Text(
                          data.stock.toString(),
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: docTransaction,
                    builder: (context, snapshot) {
                      var length = 0;
                      snapshot.data?.docs.forEach((element) {
                        if (element['user_id'] == userId) {
                          length += int.tryParse(element['total_order'].toString()) ?? 0;
                        }
                      });
                      return Text(
                        'Total: $length Barang',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LongFab(
          child: const Text('Selesai'),
          onTap: () {
            Navigator.pushNamed(
              context,
              TotalPayPage.route,
            );
          },
        ));
  }
}
