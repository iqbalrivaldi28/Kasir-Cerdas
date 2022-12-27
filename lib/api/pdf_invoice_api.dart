import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kasir_cerdas/api/pdf_api.dart';

import 'package:kasir_cerdas/model/profile.dart';
import 'package:kasir_cerdas/model/transaction.dart';
import 'package:kasir_cerdas/provider/operator_provider.dart';

import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/dashline.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate({
    required Profile profile,
    required List<TransactionData> transactionData,
    required int amount,
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
          transactionData,
        ),
        mySeparator(),
        subPrice(transactionData, amount)
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future downloadFile({
    required Profile profile,
    required List<TransactionData> transactionData,
    required int amount,
  }) async {
    OperatorProvider operatorProvider = OperatorProvider();
    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        profileBuild(
          profile: profile,
        ),
        listTransactionBuild(
          transactionData,
        ),
        SizedBox(height: 5),
        subPrice(transactionData, amount)
      ],
    ));

    await PdfApi.downloadDocument(name: 'my_invoice.pdf', pdf: pdf);
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

  // static listTransactionBuild(List<TransactionData> transactionData) {
  static Widget listTransactionBuild(
    List<TransactionData> transactionData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(transactionData.length, (index) {
        final transaction = transactionData[index];

        // Rumus
        int resultTotal = (transaction.totalOrder!) * (transaction.sellPrice!);

        return buildText(
          transaction: transaction,
          resultTotal: resultTotal,
        );
      }),
    );
  }

  static buildText({
    required TransactionData transaction,
    required int resultTotal,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
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
              Text(
                transaction.name!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${transaction.totalOrder} x ${rupiah(transaction.sellPrice!)}',
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

  static subPrice(List<TransactionData> transactionData, int amount) {
    List<int> subPricelList = [];
    int subTotal;

    // /Rumus Subtotal
    for (var i = 0; i < transactionData.length; i++) {
      subPricelList
          .add(transactionData[i].sellPrice! * transactionData[i].totalOrder!);
      print(subPricelList);
    }
    subTotal = subPricelList.reduce((a, b) => a + b);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
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
          Text(
            'Total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            rupiah(subTotal),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bayar(Cash)',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            //amont
            rupiah(amount),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Kembali',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            // rupiah(paymentRefund),
            rupiah(amount - subTotal),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      )
    ]);
  }
}
