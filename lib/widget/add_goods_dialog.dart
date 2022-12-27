import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';

class AddGoodsDialog extends StatefulWidget {
  final String? uuid;
  const AddGoodsDialog({Key? key, required this.uuid}) : super(key: key);

  @override
  State<AddGoodsDialog> createState() => _AddGoodsDialogState();
}

class _AddGoodsDialogState extends State<AddGoodsDialog> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  pickImage({bool withCamera = false}) async {
    try {
      image = await _picker.pickImage(
        source: withCamera ? ImageSource.camera : ImageSource.gallery,
      );
      setState(() {});
    } catch (e) {
      print('gagal dah');
    }
  }

  Goods goods = Goods();
  Future _getTransaction<Goods>() async {
    await FirebaseFirestore.instance.collection("products").doc(widget.uuid).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          goods = goods.copyWith(
            name: snapshot.data()!["name"],
            sellPrice: snapshot.data()!["sell_price"],
            code: snapshot.data()!["code"],
            buyPrice: snapshot.data()!["buy_price"],
            image: snapshot.data()!["image"],
            stock: snapshot.data()!["stock"],
            userId: snapshot.data()!["user_id"],
            uuid: snapshot.data()!["uuid"],
          );
        });
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    _getTransaction();
  }

  int result = 1;
  @override
  Widget build(BuildContext context) {
    return (goods.name == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (goods.image != null)
                        CachedNetworkImage(
                          imageUrl: goods.image!,
                          width: 40,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              profileImage,
                              width: 40,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      else
                        Image.asset(
                          profileImage,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goods.name.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              goods.code.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        rupiah(goods.sellPrice!),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                mvDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: InkWell(
                        child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (result < 1) {
                                      result = 0;
                                    } else {
                                      result--;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove))),
                      ),
                    ),
                    Text(result.toString(), style: largeTitleStyle),
                    Card(
                      shape: mrRadius,
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.all(4),
                            child: IconButton(
                                onPressed: () {
                                  if (goods.stock! <= result) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierColor: Colors.black.withOpacity(.2),
                                        builder: (_) => Dialog(
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Center(
                                                  child: Text(
                                                    "Stock adalah ${goods.stock}",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ));
                                    setState(() {
                                      result = goods.stock!;
                                    });
                                  } else {
                                    setState(() {
                                      result++;
                                    });
                                  }
                                },
                                icon: Icon(Icons.add))),
                      ),
                    )
                  ],
                ),
                mvDivider,
                ElevatedButton(
                  onPressed: () async {
                    if (result == 0) {
                      Navigator.pop(context);
                    } else {
                      // get data
                      Map<String, dynamic>? a = await FirestoreHelper.getProductByID(goods.uuid!);
                      if (a != null) {
                        Goods newProduct = Goods.fromJson(a);
                        newProduct = newProduct.copyWith(stock: newProduct.stock! - result);
                        await FirestoreHelper.update(
                          collection: 'products',
                          data: newProduct.toJson(),
                          uuid: goods.uuid!,
                        ).then((_) {
                          FirestoreHelper.createTransaction(
                            name: goods.name!,
                            sellPrice: goods.sellPrice.toString(),
                            buyPrice: goods.buyPrice.toString(),
                            code: goods.code.toString(),
                            stock: goods.stock.toString(),
                            image: goods.image,
                            totalOrder: result,
                          ).then((_) {
                            Navigator.pop(context);
                          });
                        });
                      } else {
                        FirestoreHelper.createTransaction(
                          name: goods.name!,
                          sellPrice: goods.sellPrice.toString(),
                          buyPrice: goods.buyPrice.toString(),
                          code: goods.code.toString(),
                          stock: goods.stock.toString(),
                          image: goods.image,
                          totalOrder: result,
                        ).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
  }
}
