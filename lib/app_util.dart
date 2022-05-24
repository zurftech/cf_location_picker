import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PluginUtil {
  static BuildContext? buildContext;
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  static void setBuildContext({ required BuildContext? context}) {
    buildContext= context!;
  }

  static BuildContext getBuildContext() {
    return buildContext!;
  }


  static void printAppLog({required String logValue})
  {
    print(logValue);
  }

}
