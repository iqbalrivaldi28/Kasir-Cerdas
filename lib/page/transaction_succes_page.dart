import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/page/receipt_preview_page.dart';
import 'package:kasir_cerdas/widget/long_fab.dart';

class TransactionSuccesPage extends StatefulWidget {
  const TransactionSuccesPage({Key? key}) : super(key: key);

  static const route = '/transactionsucces';

  @override
  State<TransactionSuccesPage> createState() => _TransactionSuccesPageState();
}

class _TransactionSuccesPageState extends State<TransactionSuccesPage> {
  List transactionList = [];
  final userId = FirebaseAuth.instance.currentUser!.uid;
  fetchDatabaseList() async {
    dynamic resultant = await FirestoreHelper.getTransactionList();

    if (resultant != null) {
      setState(() {
        transactionList = resultant;
      });
    }
  }

  Future<bool> submit() async {
    for (var i = 0; i < transactionList.length; i++) {
      if (transactionList[i]["user_id"] == userId) {
        FirestoreHelper.createLaporan(
          income: (transactionList[i]["sell_price"] *
                  transactionList[i]["total_order"])
              .toString(),
          totalTransaction: transactionList.length.toString(),
          name: transactionList[i]["name"],
          totalOrder: transactionList[i]["total_order"].toString(),
          profit: ((transactionList[i]["sell_price"] -
                      transactionList[i]["buy_price"]) *
                  transactionList[i]["total_order"])
              .toString(),
        );
        FirestoreHelper.delete(
                collectionName: 'transaction',
                documentID: transactionList[i]["uuid"])
            .then((value) => Navigator.pushNamed(context, MainPage.route));
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: submit,
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Transaksi Berhasil!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Icon(
                      Icons.check_box,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () {
                        Navigator.pushNamed(context, ReceiptPreviewPage.route);
                      },
                      child: const Text('Lihat Struk'),
                    ),
                  ),
                  svDivider,
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         shape: const StadiumBorder()),
                  //     onPressed: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (_) {
                  //           return AlertDialog(
                  //             contentPadding: const EdgeInsets.all(8),
                  //             content: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 const Text(
                  //                   'Pilih Printer',
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //                 mvDivider,
                  //                 Container(
                  //                   padding: const EdgeInsets.all(8),
                  //                   decoration: BoxDecoration(
                  //                     border: Border.all(),
                  //                     borderRadius: mbRadius,
                  //                   ),
                  //                   child: DropdownButton<String>(
                  //                     value: 'bluetooth',
                  //                     items: const [
                  //                       DropdownMenuItem(
                  //                         value: 'bluetooth',
                  //                         child: Text('bluetooth'),
                  //                       ),
                  //                     ],
                  //                     underline: const SizedBox(),
                  //                     isDense: true,
                  //                     isExpanded: true,
                  //                     onChanged: (_) {},
                  //                   ),
                  //                 ),
                  //                 mvDivider,
                  //                 ElevatedButton(
                  //                   style: ElevatedButton.styleFrom(
                  //                     shape: mrRadius,
                  //                   ),
                  //                   onPressed: () {},
                  //                   child: const Text('Cetak'),
                  //                 )
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     },
                  //     child: const Text('Cetak Struk'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LongFab(
          onTap: submit,
          child: const Text('Selesai'),
        ),
      ),
    );
  }
}
