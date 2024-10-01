import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  File? qrCodeImageFile; // Holds the saved QR code image file
  GlobalKey globalKey = GlobalKey();

  Future<void> _saveQRCode() async {
    try {
      // Check storage permission
      // if (await Permission.storage.request().isGranted) {
      // Convert the QR code to an image and save it
      final boundary = globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary?;
      final image = await boundary?.toImage(pixelRatio: 3.0);
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final buffer = byteData?.buffer.asUint8List();

      if (buffer != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/qr_code.png';
        final file = File(filePath);
        await file.writeAsBytes(buffer);
        setState(() {
          qrCodeImageFile = file; // Save the file reference
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('QR code saved to ${file.path}'),
        ));
      }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Storage permission denied'),
      //   ));
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save QR code: $e'),
      ));
    }
  }

  Future<void> _shareQRCode() async {
    if (qrCodeImageFile != null) {
      // Share the saved QR code image
      XFile xFile = XFile(qrCodeImageFile!.path);
      await Share.shareXFiles([xFile], text: 'Check out this QR code!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please generate and save the QR code first'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter data to generate QR',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Generate QR Code'),
                ),
              ),
              const SizedBox(height: 20),
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
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveQRCode,
                          child: const Text('Save QR Code'),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _shareQRCode,
                          child: const Text('Share QR Code'),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
