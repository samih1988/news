import 'package:flutter/material.dart';
import 'package:news/utils/app_routes.dart';
import 'package:news/widgets/custom_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewScreen extends StatefulWidget {
  final String url;
  final String sourceTitle;

  const MyWebViewScreen({
    super.key,
    required this.url,
    required this.sourceTitle,
  });

  @override
  State<MyWebViewScreen> createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    String formattedUrl = widget.url.trim();
    if (formattedUrl.isEmpty) {
      formattedUrl = 'https://google.com';
    } else if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    final Uri? targetUri = Uri.tryParse(formattedUrl);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            // إظهار واجهة الخطأ فقط إذا كان الفشل في الصفحة الرئيسية نفسها (Main Frame)
            // وتجاهل الأخطاء الفرعية للإعلانات وسكربتات التتبع (مثل ERR_BLOCKED_BY_ORB)
            if (error.isForMainFrame == true) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
            }
            debugPrint(
              "WebView Error: ${error.description} (MainFrame: ${error.isForMainFrame})",
            );
          },
        ),
      );

    if (targetUri != null && targetUri.hasAbsolutePath) {
      _controller.loadRequest(targetUri);
    } else {
      _controller.loadRequest(Uri.parse('https://google.com'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sourceTitle)),
      drawer: CustomDrawer(
        onGoToHomeClicked: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.homeRouteName,
            (route) =>
                false, // 👈 السطر ده بيمسح كل الشاشات القديمة بأمان ويخلي الـ Home هي الشاشة الوحيدة المفتوحة
          );
        },
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading) const Center(child: CircularProgressIndicator()),

          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('تعذر تحميل الصفحة'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                      _controller.reload();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
