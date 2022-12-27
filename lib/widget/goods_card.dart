import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';

class GoodsCard extends StatelessWidget {
  const GoodsCard({
    Key? key,
    this.onTap,
    required this.data,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Goods data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.image != null
                ? CachedNetworkImage(
                    imageUrl: data.image!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          greyBrandImage,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      greyBrandImage,
                      fit: BoxFit.cover,
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  left: 8,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data.name!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          data.stock.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.code!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          rupiah(data.sellPrice!),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
