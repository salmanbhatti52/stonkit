import 'package:flutter/material.dart';

class NetworkImageMd extends StatelessWidget {
  const NetworkImageMd({
    super.key,
    required this.name,
    this.height,
    this.width,
    this.alignment,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  final String name;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;
  final BoxFit? fit;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage(
            placeholder: const AssetImage(
                'assets/images/default-img.jpg'), // Default icon placeholder
            image: NetworkImage(
              name,
            ),
            // color: Colors.red,
            height: height ?? 120,
            width: width ?? 120,
            alignment: alignment ?? Alignment.center,
            fit: fit ?? BoxFit.cover,

            imageErrorBuilder: (context, error, stackTrace) {
              return Center(
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Container(
                    // constraints: BoxConstraints.tightFor(width: 100, height: 100),
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
