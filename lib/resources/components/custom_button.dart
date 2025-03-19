import 'package:flutter/material.dart';

import '../colors.dart';
import '../constants.dart';
import 'asset_image_md.dart';

// import '/Components/asset_image_client.dart';
// import '/Utils/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.textStyle,
    required this.borderColor,
    this.prefixIcon,
    this.postfixIcon,
    this.iconLeftMargin,
    this.margin,
  });

  final String buttonText;
  final double? width;
  final double? height;
  final void Function()? onTap;
  final Color? color;
  final TextStyle? textStyle;
  final Color borderColor;
  final String? prefixIcon;
  final String? postfixIcon;
  final double? iconLeftMargin;
  final EdgeInsetsGeometry? margin;
  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.03).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutExpo,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      // Start the animation
      await _animationController.forward();
      await _animationController.reverse();

      // Trigger the onTap callback after animation
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin,
              height: widget.height ?? 60,
              width: widget.width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.fromBorderSide(
                  widget.borderColor == Colors.transparent
                      ? BorderSide.none
                      : BorderSide(
                          color: widget.borderColor,
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.prefixIcon != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: SvgAssetImageMd(
                              name: widget.prefixIcon ?? '',
                              fit: BoxFit.scaleDown),
                        )
                      : SizedBox(),
                  Text(
                    widget.buttonText,
                    style: widget.textStyle ?? kSixteenMediumWhitePoppins,
                  ),
                  widget.postfixIcon != null
                      ? Container(
                          margin: EdgeInsets.only(
                              left: widget.iconLeftMargin ?? 4.0),
                          child: SvgAssetImageMd(
                              name: widget.postfixIcon ?? '',
                              fit: BoxFit.scaleDown),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
