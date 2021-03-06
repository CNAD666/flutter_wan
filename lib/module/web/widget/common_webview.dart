import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wan/app/typedef/function.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../state.dart';

class CommonWebView extends StatelessWidget {
  CommonWebView({
    this.data,
    this.onCollect,
    this.onPageEnd,
    this.onPageStart,
  });

  ///数据源
  final WebViewState data;

  ///收藏
  final ParamVoidCallback onCollect;

  ///加载开始
  final ParamVoidCallback onPageStart;

  ///加载结束
  final ParamVoidCallback onPageEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.detail.title),
        actions: data.detail.isCollect == null
            ? null
            : [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: data.detail.isCollect ?? false
                        ? Colors.deepOrangeAccent
                        : Colors.white,
                  ),
                  onPressed: onCollect,
                ),
              ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        // WebView(
        //   initialUrl: data.detail.url,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onPageStarted: (url) {
        //     onPageStart();
        //   },
        //   onPageFinished: (url) {
        //     onPageEnd();
        //   },
        // ),
        InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(data.detail.url)),
          onLoadStart: (controller, url) {
            onPageStart();
          },
          onLoadStop: (controller, url) {
            onPageEnd();
          },
        ),
        //加载动画
        Offstage(
          offstage: !data.isLoading,
          child: Center(
            child: CircularProgressIndicator(), //圆形加载动画
          ),
        )
      ],
    );
  }
}
