import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  TextEditingController _textController = TextEditingController();

  GlobalKey globalKey = GlobalKey();
  Future<void> _saveQRCode() async {
    try {
      // Check storage permission
      await Permission.storage.request();
      if (await Permission.storage.request().isGranted) {
        // Convert the QR code to an image and save it
        final boundary = globalKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary?;
        final image = await boundary?.toImage(pixelRatio: 3.0);
        final byteData = await image?.toByteData(format: ImageByteFormat.png);
        final buffer = byteData?.buffer.asUint8List();

        if (buffer != null) {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/qr_code.png');
          await file.writeAsBytes(buffer);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('QR code saved to ${file.path}'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Storage permission denied'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save QR code: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter data to generate QR',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            if (_textController.text.isNotEmpty)
              RepaintBoundary(
                key: globalKey,
                child: QrImageView(
                  data: _textController.text,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            if (_textController.text.isNotEmpty)
              ElevatedButton(
                onPressed: _saveQRCode,
                child: Text('Save QR Code'),
              ),
          ],
        ),
      ),
    );
  }
}
