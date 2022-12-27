import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kasir_cerdas/api/pdf_api.dart';
import 'package:kasir_cerdas/api/pdf_invoice_api.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/model/profile.dart';
import 'package:kasir_cerdas/model/transaction.dart';
import 'package:kasir_cerdas/provider/operator_provider.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/dashline.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../api/firestore.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({Key? key}) : super(key: key);

  static const route = '/receiptpreview';

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Profile profile = Profile();
  List transactionList = [];
  fetchDatabaseList() async {
    dynamic resultant = await FirestoreHelper.getTransactionList();

    if (resultant != null) {
      setState(() {
        transactionList = resultant;
      });
    }
  }

  List<TransactionData> transaction() {
    List<TransactionData> transaction = [];
    for (var i = 0; i < transactionList.length; i++) {
      if (transactionList[i]["user_id"] == userId) {
        transaction.add(TransactionData(
          buyPrice: transactionList[i]["buy_price"],
          code: transactionList[i]["code"],
          date: DateTime.parse(transactionList[i]["date"]),
          image: transactionList[i]["image"],
          name: transactionList[i]["name"],
          totalOrder: transactionList[i]["total_order"],
          sellPrice: transactionList[i]["sell_price"],
          stock: transactionList[i]["stock"],
          userId: transactionList[i]["user_id"],
          uuid: transactionList[i]["uuid"],
        ));
      }
    }
    return transaction;
  }

  Future _getdataFromDatabase<Profil>() async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          profile = profile.copyWith(name: snapshot.data()!["name"], email: snapshot.data()!["email"], phone: snapshot.data()!["phone"], address: snapshot.data()!["address"], shopName: snapshot.data()!["shop_name"]);
        });
      } else {}
    });
  }

  @override
  void initState() {
    fetchDatabaseList();
    _getdataFromDatabase();
    super.initState();
  }

  ScreenshotController widgetController = ScreenshotController();
  Uint8List? myImage;

  capturePng() async {
    var image = await widgetController.captureFromWidget(
      ReceiptCard(profile: profile, userId: userId),
    );
    setState(() {
      myImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    OperatorProvider operatorProvider = Provider.of<OperatorProvider>(context);
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text('Lihat Struk'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () async {
              await PdfInvoiceApi.downloadFile(
                amount: operatorProvider.amount!,
                profile: profile,
                transactionData: transaction(),
              ).then((value) {
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
                                  "Laporan berhasil disimpan\n di folder download",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ));
              });
            },
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: () async {
              await PdfInvoiceApi.generate(
                amount: operatorProvider.amount!,
                profile: profile,
                transactionData: transaction(),
              ).then((file) => Share.shareXFiles([XFile(file.path)], text: 'REPORT'));
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: ReceiptCard(profile: profile, userId: userId),
    );
  }
}

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    Key? key,
    required this.profile,
    required this.userId,
  }) : super(key: key);
  final Profile profile;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final docTransaction = FirebaseFirestore.instance.collection("transaction").snapshots();
    OperatorProvider operatorProvider = Provider.of<OperatorProvider>(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...[
              Text(
                profile.shopName.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                profile.address.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                profile.phone.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              const MySeparator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    profile.name.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Text(
                DateFormat('hh:mm:ss').format(DateTime.now()),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
              const Text(
                'No.0-1',
                style: TextStyle(fontSize: 12),
              ),
            ],
            const MySeparator(),
            StreamBuilder(
                stream: docTransaction,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final goodsTransction = snapshot.data!.docs;

                    List<int> subPricelList = [];

                    int? subTotal;
                    for (var i = 0; i < snapshot.data!.docs.length; i++) {
                      if (snapshot.data!.docs[i]["user_id"] == userId) {
                        subPricelList.add(goodsTransction[i]["sell_price"] * goodsTransction[i]["total_order"]);
                        subTotal = subPricelList.reduce((a, b) => a + b);
                      }
                    }
                    int payment = operatorProvider.amount!;
                    int paymentRefund = payment - subTotal!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          children: List.generate(
                            goodsTransction.length,
                            (i) {
                              final receipt = goodsTransction[i];

                              if (goodsTransction[i]["user_id"] == userId) {
                                var sellPrice = receipt["sell_price"];
                                var totalOrder = receipt["total_order"];
                                var resultTotal = totalOrder * sellPrice;
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        receipt["name"],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${receipt["total_order"]} x ${rupiah(receipt["sell_price"])}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            rupiah(resultTotal),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                        const MySeparator(padding: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub Total',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              rupiah(subTotal),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              rupiah(subTotal),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bayar(Cash)',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              rupiah(operatorProvider.amount!),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kembali',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              rupiah(paymentRefund),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Erorr");
                  } else {
                    return const Text("DataKosong");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
