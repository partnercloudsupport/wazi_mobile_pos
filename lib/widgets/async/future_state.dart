import 'package:flutter/material.dart';
import 'dart:async';

class FutureState<T extends StatefulWidget> extends State<T> {
  bool _isInitialized;

  @override
  initState() {
    super.initState();
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CustomState(${T.toString()}).build executed");
    return new FutureBuilder(
        future: loadWidget(context, _isInitialized),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              _isInitialized = false;
              return customBuild(context);
            }
          } else {
            return new CircularProgressIndicator();
          }
        });
  }

  // Inherited class should create widget here instead of from the build method
  @protected
  Widget customBuild(BuildContext context) {
    debugPrint("CustomState(${T.toString()}).customBuild executed");
    return null;
  }

  // The following procedure is used for widget startup loading, remember to use await when calling any async call.
  @protected
  Future<bool> loadWidget(BuildContext context, bool isInit) async {
    debugPrint("CustomState(${T.toString()}).loadWidget executed " +
        (isInit ? "for the first time" : "again"));
    return true;
  }
}
