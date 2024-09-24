import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtension on num {
  Widget get hSpace => SizedBox(
        height: toDouble(),
      );
  Widget get wSpace => SizedBox(
        width: toDouble(),
      );

  double get hMax => (h > this ? h : this).toDouble();
  double get wMax => (w > this ? w : this).toDouble();
}
