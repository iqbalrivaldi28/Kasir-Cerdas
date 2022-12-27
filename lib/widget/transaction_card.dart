import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key? key,
    required this.title,
    this.image,
    this.padding = EdgeInsets.zero,
    this.trailing,
    this.radius = 0,
    this.onTap,
    this.leading,
    this.subtitle,
  }) : super(key: key);

  final String title;

  final String? image;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;
  final double radius;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null) Align(alignment: Alignment.center, child: leading!),
              SizedBox(
                width: 60,
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(radius),
                  child: image != null
                      ? CachedNetworkImage(
                          imageUrl: image!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              image ?? greyBrandImage,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          image ?? greyBrandImage,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (subtitle != null) subtitle!
                    ],
                  ),
                ),
              ),
              if (trailing != null) Align(alignment: Alignment.center, child: trailing!)
            ],
          ),
        ),
      ),
    );
  }
}
