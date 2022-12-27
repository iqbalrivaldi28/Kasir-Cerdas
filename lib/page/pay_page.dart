import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/model/transaction.dart';
import 'package:kasir_cerdas/page/transaction_succes_page.dart';
import 'package:kasir_cerdas/provider/operator_provider.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/circle_button.dart';
import 'package:kasir_cerdas/widget/long_fab.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  final int total;
  const PayPage({Key? key, this.total = 0}) : super(key: key);

  static const route = '/pay';

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List transactionList = [];
  List reportList = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await FirestoreHelper.getTransactionList();
    dynamic cart = await FirestoreHelper.getReport();

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        transactionList = resultant;
        reportList = cart;
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

  String amount = '';
  List profit = [];
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    OperatorProvider result = Provider.of<OperatorProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bayar'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              mvDivider,
              Text(
                rupiah(amount.isEmpty ? 0 : int.parse(amount)),
                style: largeTitleStyle.copyWith(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleTextButton(
                    '9',
                    onTap: () {
                      setState(() {
                        amount += '9';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '8',
                    onTap: () {
                      setState(() {
                        amount += '8';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '7',
                    onTap: () {
                      setState(() {
                        amount += '7';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    'C',
                    color: primaryColor,
                    onTap: () {
                      setState(() {
                        amount = '';
                      });
                    },
                  ),
                ],
              ),
              mvDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleTextButton(
                    '6',
                    onTap: () {
                      setState(() {
                        amount += '6';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '5',
                    onTap: () {
                      setState(() {
                        amount += '5';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '4',
                    onTap: () {
                      setState(() {
                        amount += '4';
                      });
                    },
                  ),
                  shDivider,
                  CircleIconButton(
                    Icons.backspace_outlined,
                    color: primaryColor,
                    onTap: () {
                      if (amount.isNotEmpty) {
                        setState(() {
                          var c = amount.split('');
                          c.removeLast();
                          amount = c.join();
                        });
                      }
                    },
                  ),
                ],
              ),
              mvDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleTextButton(
                    '1',
                    onTap: () {
                      setState(() {
                        amount += '1';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '2',
                    onTap: () {
                      setState(() {
                        amount += '2';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '3',
                    onTap: () {
                      setState(() {
                        amount += '3';
                      });
                    },
                  ),
                  shDivider,
                  const CircleTextButton('', color: Colors.transparent),
                ],
              ),
              mvDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleExtendedButton(
                    onTap: () {
                      setState(() {
                        amount += '0';
                      });
                    },
                  ),
                  shDivider,
                  CircleTextButton(
                    '.',
                    onTap: () {},
                  ),
                  shDivider,
                  const CircleTextButton('', color: Colors.transparent),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LongFab(
            child: const Text('Bayar'),
            onTap: () async {
              List name = [];
              List sellPrice = [];
              List buyPrice = [];
              List code = [];
              List stock = [];
              List image = [];
              List totalOrder = [];
              List<int> subPricelList = [];
              int subTotal;

              // /Rumus Subtotal

              for (var i = 0; i < transaction().length; i++) {
                subPricelList.add((transaction()[i].sellPrice!) *
                    transaction()[i].totalOrder!);
                name.add(
                    "${transaction()[i].name} (${transaction()[i].totalOrder})");
                sellPrice.add(transaction()[i].sellPrice);
                buyPrice.add(transaction()[i].buyPrice);
                code.add(transaction()[i].code);
                stock.add(transaction()[i].stock);
                image.add(transaction()[i].image);
                totalOrder.add(transaction()[i].totalOrder);
              }
              subTotal = subPricelList.reduce((a, b) => a + b);

              //nama
              String nameTotal = "${name.reduce((a, b) => '$a ' ',$b')}";
              String codeTotal = "${code.reduce((a, b) => '$a' ',$b')}";
              String imageTotal = "${image.reduce((a, b) => '$a' ',$b')}";

              print(imageTotal);
              String orderTotal = "${totalOrder.reduce((a, b) => a + b)}";
              String stockTotal = "${stock.reduce((a, b) => a + b)}";
              // harga belanja

              String buyPriceTotalOperator =
                  "${buyPrice.reduce((a, b) => a + b)}";
              // total belanja
              String sellPriceOperator =
                  (" ${sellPrice.reduce((a, b) => a + b)}");
              //profit
              String profitTotal =
                  ("${(sellPrice.reduce((a, b) => a + b) - buyPrice.reduce((a, b) => a + b)) * totalOrder.reduce((a, b) => a + b)} ");
              //cash

              String retrun =
                  ('${int.parse(amount) - sellPrice.reduce((a, b) => a + b)}');

              if ((int.tryParse(amount) ?? 0) < widget.total) {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(.2),
                    builder: (_) => Dialog(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          child: SizedBox(
                            height: 120,
                            width: 80,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                child: Text(
                                  "Total pembayaran adalah ${rupiah(widget.total)}. masukan nominal lebih dari atau sama dengan ${rupiah(widget.total)}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ));
              } else if (reportList.isEmpty) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.transparent,
                    builder: (_) => const Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ));
                result.amount = (int.tryParse(amount) ?? 0);

                FirestoreHelper.createCart(
                  cash: amount,
                  subTotal: subTotal.toString(),
                  stock: stockTotal,
                  name: nameTotal,
                  sellPrice: sellPriceOperator,
                  buyPrice: buyPriceTotalOperator,
                  code: codeTotal,
                  image: imageTotal,
                  totalOrder: orderTotal,
                  profit: profitTotal,
                ).then((value) =>
                    Navigator.pushNamed(context, TransactionSuccesPage.route));
              } else {
                result.amount = (int.tryParse(amount) ?? 0);
                FirestoreHelper.createCart(
                  cash: amount,
                  subTotal: subTotal.toString(),
                  stock: stockTotal,
                  name: nameTotal,
                  sellPrice: sellPriceOperator,
                  buyPrice: buyPriceTotalOperator,
                  code: codeTotal,
                  image: imageTotal,
                  totalOrder: orderTotal,
                  profit: profitTotal,
                ).then((value) =>
                    Navigator.pushNamed(context, TransactionSuccesPage.route));
              }
            }));
  }
}
