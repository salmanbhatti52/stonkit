import 'package:flutter/material.dart';

import '../../../resources/constants.dart';
import '../../../utils/utils.dart';

class TermsDialog extends StatefulWidget {
  const TermsDialog({super.key});

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      scrollable: true,
      // actionsOverflowDirection: ScrollableDetails.vertical(),

      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        height: height * 0.83,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Utils.setFocus(context);
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                '1. Clause 1',
                style: kTwentyBoldBlackLato,
              ),
              SizedBox(
                height: 9,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.',
                style: kSixteenRegularGrayLato,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '2. Clause 2',
                style: kTwentyBoldBlackLato,
              ),
              SizedBox(
                height: 9,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem. \n \n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque.',
                style: kSixteenRegularGrayLato,
              ),
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
  }
}
