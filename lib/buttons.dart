import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location_picker/app_util.dart';
import 'package:location_picker/plugin_colors.dart';
import 'package:location_picker/text_styles.dart';

Widget cfCircularButton({
  String? text,
  Function? onPressed,
  Color? color,
  Icon? prefixIcon,
  bool? isProgress,
  double? cornerRadius,
}) {
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: isProgress!
          ? SpinKitThreeBounce(
              color: Colors.white,
              size: 20,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefixIcon != null)
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: prefixIcon,
                  ),
                Text(
                  '$text',
                  // style: const TextStyle(
                  //   color: Colors.white,
                  //   fontSize: 16,
                  //   fontWeight: FontWeight.w600,
                  // ),
                  style: CfTextStyles.getTextStyle(
                    TStyle.h5_600,
                    customStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: PluginColors.white,
                        letterSpacing: 0.8),
                  ),
                ),
              ],
            ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(color ?? PluginColors.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius ?? 50),
          ),
        ),
      ),
    ),
  );
}
