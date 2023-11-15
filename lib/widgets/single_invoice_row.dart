import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/styles.dart';

class SingleInvoiceRow extends StatelessWidget {
  const SingleInvoiceRow({Key? key, required this.lTitle, required this.rTitle}) : super(key: key);
  final String lTitle;
  final String rTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
        [
         Text(lTitle, style: Style.alltext_default_balck,),
         Text(rTitle, style: Style.alltext_default_balck,),
        ]
    );
  }
}
