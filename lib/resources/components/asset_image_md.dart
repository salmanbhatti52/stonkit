import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetsImageMd extends StatelessWidget {
  const AssetsImageMd(
      {super.key,
      required this.name,
      this.height,
      this.width,
      this.alignment,
      this.fit,
      this.onTap,
      this.color});
  final String name;
  final double? height;
  final double? width;
  final Alignment? alignment;
  final BoxFit? fit;
  final void Function()? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        name,
        fit: fit,
        color: color,
        height: height,
        width: width,
        alignment: alignment ?? Alignment.centerLeft,
      ),
    );
  }
}

class SvgAssetImageMd extends StatelessWidget {
  const SvgAssetImageMd(
      {super.key,
      required this.name,
      this.height,
      this.width,
      this.alignment,
      this.fit,
      this.onTap,
      this.colorFilter});

  final String name;
  final double? height;
  final double? width;
  final Alignment? alignment;
  final BoxFit? fit;
  final void Function()? onTap;
  final ColorFilter? colorFilter;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        name,
        fit: fit ?? BoxFit.none,
        height: height,
        width: width,
        colorFilter: colorFilter,
        alignment: alignment ?? Alignment.centerLeft,
      ),
    );
  }
}
