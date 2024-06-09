import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:system_alert_window/system_alert_window.dart';

class CustomOverlay extends StatefulWidget {
  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  static const String _mainAppPort = 'MainApp';
  SendPort? mainAppPort;
  SendPort? actionPart;
  bool update = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemAlertWindow.overlayListener.listen((event) {
      log("$event in overlay");
      if (event is bool) {
        setState(() {
          update = event;
        });
      }
    });
  }

  Widget overlay() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: (MediaQuery.of(context).size.height) / 3.5,
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Are sure you want to accept Ride?",
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){

                    mainAppPort ??= IsolateNameServer.lookupPortByName(
                      _mainAppPort,
                    );
                    mainAppPort?.send('Date: ${DateTime.now()}');
                    mainAppPort?.send('Close');
                    SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:  EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.close,
                       /* style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                       */
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Text(
              update ? "clicks Disabled" : "Body",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              mainAppPort ??= IsolateNameServer.lookupPortByName(
                _mainAppPort,
              );
              mainAppPort?.send('Date: ${DateTime.now()}');
              mainAppPort?.send('Action');
             // SystemAlertWindow.(prefMode: prefMode);

            },
            child: Container(
              padding: EdgeInsets.all(12),
              height: (MediaQuery.of(context).size.height) / 3.5,
              width: MediaQuery.of(context).size.width / 1.05,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: update ? Colors.grey : Colors.deepOrange),
              child: Center(
                child: Text(
                  "Action",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: overlay(),
    );
  }
}
