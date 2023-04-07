import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController controller;
  //late WebViewController controller;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue.shade900,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExistWarming = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if(isExistWarming){
          final message = 'Appuyez encore pour quitter';
          Fluttertoast.showToast(
              msg: message,
              fontSize: 12,
              backgroundColor: Colors.blue.shade900,
          );
          return false;
        }else{
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: new Center(
            child: new Text(
              "WillMarket",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 24.0,
                //textAlign: TextAlign.center
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 24.0,
            onPressed: () {
              webViewController?.goBack();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                webViewController?.goForward();
              },
            ),
          ],
        ),
        body: IndexedStack(
          //index: position,
          children: <Widget>[
            Container(
              child: SafeArea(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse("https://will.market/")),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest: (controller, origin,
                          resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller,
                          navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![ "http", "https", "file", "chrome",
                          "data", "javascript", "about"].contains(uri.scheme)) {
                          if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url,
                          androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(
                      value: progress,
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    /*Future<bool> onWillPop() async {
      final shouldPop = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              //title: new Center(
                child: new Text(
                  "Quitter",
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 24.0,
                    //textAlign: TextAlign.center
                  ),
                ),
              ),
              content: Text('Voulez-vous vraiment quitter ?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Non'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Oui'),
                ),
              ],
            )
        );
        return shouldPop ?? false;*/
}
