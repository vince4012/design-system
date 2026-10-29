import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vb_design/vb_design.dart';

import 'gallery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final nativeWindow = Platform.isMacOS;
  if (nativeWindow) {
    await NativeWindow.setUp();
    NativeWindow.maximize();
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(GalleryApp(prefs: prefs, nativeWindow: nativeWindow));
}

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key, required this.prefs, required this.nativeWindow});

  final SharedPreferences prefs;
  final bool nativeWindow;

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  late var _mode = ThemeModeStore.read(widget.prefs);

  @override
  Widget build(BuildContext context) => GalleryRoot(
    themeMode: _mode,
    nativeWindow: widget.nativeWindow,
    onThemeModeChanged: (mode) {
      setState(() => _mode = mode);
      ThemeModeStore.write(widget.prefs, mode);
    },
  );
}
