import 'package:kasir_cerdas/constant/assets.dart';

class NavItem {
  const NavItem(
    this.image,
    this.label,
  );

  final String image;
  final String label;

  static const list = [
    NavItem(homeIconImage, 'Beranda'),
    NavItem(shopIconImage, 'Barang'),
    NavItem(cashIconImage, 'Penjualan'),
    NavItem(docIconImage, 'Laporan'),
  ];
}
