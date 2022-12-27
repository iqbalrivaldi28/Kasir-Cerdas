import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/page/add_goods_page.dart';
import 'package:kasir_cerdas/page/edit_goods_page.dart';
import 'package:kasir_cerdas/page/scanner_page.dart';
import 'package:kasir_cerdas/widget/goods_card.dart';
import 'package:kasir_cerdas/widget/long_fab.dart';

class GoodsPage extends StatefulWidget {
  const GoodsPage({Key? key}) : super(key: key);

  static const route = '/goods';

  @override
  State<GoodsPage> createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final docTransaction = FirebaseFirestore.instance.collection("transaction").snapshots();
  List<Goods> products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh();
    });
  }

  refresh({String? query}) {
    FirestoreHelper.getProduct().then((value) {
      List<Goods> data = [];
      if (query != null && query.isNotEmpty) {
        data = value.map((e) => Goods.fromJson(e)).toList().where((e) => e.name!.toLowerCase().contains(query.toLowerCase())).toList();
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

  int lenght() {
    int lenght = 0;
    List productsName = [];
    for (var i = 0; i < products.length; i++) {
      if (products[i].userId == userId) {
        productsName.add(products[i].name);
      }
    }
    lenght = productsName.length;
    return lenght;
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (query) => refresh(query: query),
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: 'Cari nama barang',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(borderRadius: mbRadius),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (s) {
                if (s is UserScrollNotification) {
                  if (s.direction == ScrollDirection.forward) {
                    setState(() {
                      isVisible = true;
                    });
                  } else if (s.direction == ScrollDirection.reverse) {
                    setState(() {
                      isVisible = false;
                    });
                  }
                }
                return false;
              },
              child: ListView.builder(
                  itemCount: goods().length,
                  itemBuilder: (_, i) {
                    if (goods().isNotEmpty) {
                      return GoodsCard(
                        onTap: () {
                          Navigator.pushNamed(context, EditGoodsPage.route, arguments: goods()[i]);
                        },
                        data: goods()[i],
                      );
                    } else {
                      return const Text("Data Kosong");
                    }
                  }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: LongFab(
        isVisible: isVisible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Tambah Barang '),
            Icon(Icons.qr_code_2),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            ScannerPage.route,
            arguments: (String code) {
              bool isCheck = false;
              for (var i = 0; i < goods().length; i++) {
                isCheck = (goods()[i].code == code);
              }
              if (isCheck == false) {
                Navigator.pushNamed(
                  context,
                  AddGoodsPage.route,
                  arguments: code,
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
                                  "Barcode sudah ada",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ));
              }
            },
          );
        },
      ),
    );
  }
}
