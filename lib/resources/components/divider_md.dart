import 'package:flutter/material.dart';

import '../colors.dart';

class DividerMd extends StatelessWidget {
  const DividerMd({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: color ?? AppColors.lightGray,
    );
  }
}
