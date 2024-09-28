import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/gr_generator.dart';
import 'package:flutter_barcode_scanner/scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QRViewController? controller;
  Barcode? result;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
    super.reassemble();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Blue background color
      body: Center(
        child: Container(
          // margin: EdgeInsets.all(10),
          // width: 350,
          // height: 700,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .4,
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'assets/qr.png', // Replace with actual SVG asset path
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'QR & Barcode Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    MenuButton(iconPath: 'assets/qr.png', label: 'Scanner'),
                    MenuButton(
                        iconPath: 'assets/history.jpeg', label: 'History'),
                    MenuButton(
                        iconPath: 'assets/generate.jpeg', label: 'Generate'),
                    MenuButton(
                        iconPath: 'assets/barcode.png', label: 'Setting'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String iconPath;
  final String label;

  MenuButton({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRGeneratorScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2F2F2),
              ),
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                iconPath,
                height: 60,
                width: 60,
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
