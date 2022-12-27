import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/model/profile.dart';
import 'package:kasir_cerdas/model/transaction.dart';
import 'package:kasir_cerdas/page/profile_page.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Profile profile = Profile();
  TransactionData transactionData = TransactionData();

  @override
  void initState() {
    super.initState();
    _getdataFromDatabase();
  }

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
            image: snapshot.data()!["image"],
            phone: snapshot.data()!["phone"],
            address: snapshot.data()!["address"],
          );
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionData> transactionData = [];

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docCart = FirestoreHelper.getReport();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kasir Cerdas Proyek Mandiri',
                    style: largeTitleStyle.copyWith(fontSize: 20),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProfilePage.route)
                            .then((_) {
                          setState(() {});
                        });
                      },
                      child: profile.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: profile.image!,
                                height: 32,
                                width: 32,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return const CircleAvatar(
                                    radius: 18,
                                    child: Icon(Icons.person),
                                  );
                                },
                              ),
                            )
                          : const CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.person),
                            )),
                ],
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 16),
                shape: mrRadius,
                color: Colors.blue,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Aplikasi Kasir Cerdas Proyek Mandiri Mahasiswa, Akan membantu transaksi kamu..',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: Text(
                  'Transaksi baru-baru ini',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: docCart,
                    initialData: const [],
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (_, i) {
                          final transaction = Goods.fromJson(data[i].data());
                          return (transaction.userId == userId)
                              ? Column(
                                  children: [
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    TransactionCard(
                                      image: transaction.image,
                                      title: '${transaction.name}',
                                      subtitle: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Profit ${rupiah(transaction.profit ?? 0)} ',
                                              style: const TextStyle(
                                                  color: primaryColor),
                                            ),
                                            TextSpan(
                                                text:
                                                    ' - Order ${transaction.totalOrder} barang'),
                                            TextSpan(
                                              text: ' - ${transaction.date!}',
                                            )
                                          ],
                                        ),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      radius: 8,
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
