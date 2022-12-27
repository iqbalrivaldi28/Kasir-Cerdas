import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';

import 'package:kasir_cerdas/api/pdf_report_api.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/model/cart.dart';
import 'package:kasir_cerdas/model/profile.dart';

import 'package:kasir_cerdas/page/goods_page.dart';
import 'package:kasir_cerdas/page/home_page.dart';
import 'package:kasir_cerdas/page/report_page.dart';
import 'package:kasir_cerdas/page/transaction_page.dart';
import 'package:kasir_cerdas/widget/bottom_navbar.dart';
import 'package:share_plus/share_plus.dart';

class MainPage extends StatefulWidget {
  final int? initialPage;
  const MainPage({Key? key, this.initialPage}) : super(key: key);

  static const route = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Profile profile = Profile();
  Future _getdataFromDatabase<Profil>() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          profile = profile.copyWith(
              name: snapshot.data()!["name"],
              email: snapshot.data()!["email"],
              phone: snapshot.data()!["phone"],
              address: snapshot.data()!["address"],
              shopName: snapshot.data()!["shop_name"]);
        });
      } else {}
    });
  }

  List reportAll = [];
  fetchDatabaseList() async {
    dynamic resultant = await FirestoreHelper.getReport();

    if (resultant != null) {
      setState(() {
        reportAll = resultant;
      });
    }
  }

  late final PageController page;
  late int currentIndex;

  List<Cart> transaction() {
    List<Cart> transaction = [];
    for (var i = 0; i < reportAll.length; i++) {
      if (reportAll[i]["user_id"] == userId) {
        transaction.add(
          Cart(
            cash: reportAll[i]["cash"],
            code: reportAll[i]["code"],
            subTotal: reportAll[i]["sub_total"],
            date: DateTime.parse(reportAll[i]["date"]),
            userId: reportAll[i]["user_id"],
            uuid: reportAll[i]["uuid"],
            name: reportAll[i]["name"],
            stock: reportAll[i]["stock"],
            totalOrder: reportAll[i]["total_order"],
            sellPrice: (reportAll[i]["sell_price"]),
            buyPrice: (reportAll[i]["buy_price"]),
            profit: ((reportAll[i]["sell_price"] - reportAll[i]["buy_price"]) *
                reportAll[i]["total_order"]),
          ),
        );
      }
    }

    return transaction;
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    _getdataFromDatabase();

    currentIndex = widget.initialPage ?? 0;
    page = PageController(initialPage: widget.initialPage ?? 0);
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  void navigateTo(int index) {
    page.jumpToPage(index);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(
        currentIndex,
        onTap: () {
          navigateTo(0);
        },
        action: PopupMenuButton(
          shape: mrRadius,
          itemBuilder: (_) {
            return [
              PopupMenuItem(
                value: 'Unduh',
                child: Text('Unduh'),
                onTap: () async {
                  print("Download");
                  print(transaction().length);

                  await PdfInvoiceApiReport.downloadFile(
                    report: transaction(),
                    profile: profile,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
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
              ),
              PopupMenuItem(
                value: 'Bagikan',
                child: Text('Bagikan'),
                onTap: () async {
                  print("Share");
                  await PdfInvoiceApiReport.generateReport(
                    profile: profile,
                    report: transaction(),
                  ).then((file) =>
                      Share.shareXFiles([XFile(file.path)], text: 'REPORT'));
                },
              ),
            ];
          },
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: page,
        children: const [
          HomePage(),
          GoodsPage(),
          TransactionPage(),
          ReportPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onPageChanged: navigateTo,
        currentIndex: currentIndex,
      ),
    );
  }
}

PreferredSizeWidget? makeAppBar(
  int index, {
  required Function() onTap,
  required Widget action,
}) {
  if (index == 0) {
    return null;
  } else {
    return AppBar(
      title: Text(
        index == 1
            ? 'Barang'
            : index == 2
                ? 'Transaksi Penjualan'
                : 'Laporan',
      ),
      leading: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        if (index == 3) action,
      ],
    );
  }
}
