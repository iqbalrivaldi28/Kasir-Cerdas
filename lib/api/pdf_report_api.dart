import 'dart:io';

import 'package:intl/intl.dart';
import 'package:kasir_cerdas/api/pdf_api.dart';
import 'package:kasir_cerdas/model/cart.dart';

import 'package:kasir_cerdas/model/profile.dart';

import 'package:kasir_cerdas/provider/operator_provider.dart';

import 'package:kasir_cerdas/utility/rupiah.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';

class PdfInvoiceApiReport {
  static Future<File> generateReport({
    required Profile profile,
    required List<Cart> report,
  }) async {
    OperatorProvider operatorProvider = OperatorProvider();
    final pdf = Document();
    // final userId = FirebaseAuth.instance.currentUser!.uid;
    pdf.addPage(MultiPage(
      build: (context) => [
        profileBuild(
          profile: profile,
        ),
        mySeparator(),
        listTransactionBuild(
          report,
        ),
        mySeparator(),
        subPrice(
          report,
        )
      ],
    ));

    return PdfApi.saveDocument(name: 'my_report.pdf', pdf: pdf);
  }

  static Future downloadFile({
    required List<Cart> report,
    required Profile profile,
  }) async {
    OperatorProvider operatorProvider = OperatorProvider();
    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        profileBuild(
          profile: profile,
        ),
        listTransactionBuild(
          report,
        ),
        SizedBox(height: 5),
        subPrice(report),
      ],
    ));

    await PdfApi.downloadDocument(name: 'my_report.pdf', pdf: pdf);
  }

  static profileBuild(
      {Profile? profile, List? transactionData, String? userId, int? amount}) {
    return DefaultTextStyle(
      style: const TextStyle(color: PdfColor.fromInt(0xFF000000)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...[
            Text(
              profile!.shopName.toString(),
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
            // const MySeparator(),
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
            Text(
              'No.0-1',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  static Widget listTransactionBuild(
    List<Cart> report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(report.length, (index) {
        final transaction = report[index];

        return buildText(
          transaction: transaction,
          i: index,
        );
      }),
    );
  }

  static buildText({
    required Cart transaction,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
    required int i,
  }) {
    return Column(
      children: [
        Container(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text("${i + 1}. "),
                Text(
                  transaction.name!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  ${transaction.totalOrder} x ${rupiah(transaction.sellPrice!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    rupiah((transaction.totalOrder!) * (transaction.sellPrice!))
                        .toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static mySeparator({
    final double height = 1,
    final double width = 5,
    final double padding = 8,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints!.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * width)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: SizedBox(
                width: width,
                height: dashHeight,
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  static subPrice(
    List<Cart> transactionData,
  ) {
    List<int> subPricelList = [];
    List<int> cashAll = [];
    List<int> profitAll = [];
    int? profit;
    int? cash;
    int income;

    // /Rumus Subtotal
    for (var i = 0; i < transactionData.length; i++) {
      subPricelList
          .add(transactionData[i].sellPrice! * transactionData[i].totalOrder!);
      print(subPricelList);
      cashAll.add(transactionData[i].cash!);
      profitAll.add(transactionData[i].profit!);
    }
    print(profit);

    cash = cashAll.reduce((a, b) => a + b);
    profit = profitAll.reduce((a, b) => a + b);

    income = subPricelList.reduce((a, b) => a + b);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jumlah Transaksi',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              transactionData.length.toString(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Keuntungan',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              //amont
              rupiah(profit),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pendapatan',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              rupiah(income),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
