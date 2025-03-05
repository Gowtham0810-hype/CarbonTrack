// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:portal/pages/additem.dart';
import 'package:portal/utils/item.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  File? _image;
  bool _imageCropped = false;
  late EmType emType = EmType(name: '', measurement: '', metrics: '');
  String _geminiResponse = "";

  Future<void> getimage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      final croppedimage = await ImageCropper().cropImage(
        sourcePath: image!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          )
        ],
      );

      if (croppedimage == null) return;
      final imagetemp = await savefileperm(croppedimage.path);

      setState(() {
        _image = imagetemp;
        _imageCropped = true;
      });
      final downloadUrl = await uploadImageToFirebase(imagetemp);
      if (downloadUrl != null) {
        print('Image uploaded successfully. Download URL: $downloadUrl');
      }
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  Future<File> savefileperm(String imagePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${dir.path}/$name');
    return File(imagePath).copy(image.path);
  }

  final user = FirebaseAuth.instance.currentUser;

  Future<String?> uploadImageToFirebase(File image) async {
    try {
      String fileName = basename(image.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Item createItemFromCommaSeparatedString(String output) {
    // Split the string by commas and trim any extra spaces
    List<String> parts = output.split(',').map((part) => part.trim()).toList();

    if (parts.length != 5) {
      throw Exception('Invalid input format');
    }

    String name = parts[0]; // The first part is the item name
    double emission = double.parse(
        parts[1]); // The second part is the emission, converted to double

    emType.name = parts[2];
    emType.measurement = parts[4];
    emType.metrics = parts[3];

// The third part is the emType, mapped to EmType object

    // Create and return the Item object
    return Item(name: name, emission: emission, emType: emType);
  }

// Example usage with the output as a comma-separated string

  Future<void> sendImage(BuildContext context, File img) async {
    String apiKey = 'AIzaSyCxbFB6l71d3H_ocYt6dpxx4ZVcxiBDUDA';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final msg = '''
    Here is a database of items along with their carbon footprint emission types (EmType). Each item has an emission value and is associated with an EmType, which describes how the emissions are measured (e.g., by quantity, distance, etc.).

EmType examples:
1. Purchase: measured by quantity (item(s)).
2. Transport: measured by distance (km(s)).
3. Meal: measured by quantity (meal(s)).
4. Streaming: measured by duration (hour(s)).
5. Fashion: measured by quantity (item(s)).
6. Food: measured by quantity (g).

Here is a list of items and their emissions:

**Purchase Items:**
- SmartPhone: 80
- Laptop: 210
- Tablet: 87
- Computer: 588
- Television: 500
- Electric Car: 8800
- Hybrid Car: 6500

**Transport Items:**
- Train: 0.084 (per km)
- Car: 38.55 (per km)
- Bus: 15.45 (per km)
- Plane: 453.77 (per km)
- MotorBike: 16.2 (per km)

**Meal Items:**
- High Meat: 2.16 (per meal)
- Medium Meat: 1.69 (per meal)
- Vegan: 0.867 (per meal)

**Fashion Items:**
- Coat: 51 (per item)
- Dress: 54.33 (per item)
- T-Shirt: 7.67 (per item)

**Food Items:**
- Meat: 3.5 (per g)
- Coffee: 0.628 (per g)
- Chocolate: 0.974 (per g)
- Milk: 0.38 (per g)

**Streaming Items:**
- Audio-MP3: 0.033 (per hour)
- Video-Full HD: 0.135 (per hour)

Your task is to identify which item is in the given image based on this database.
 If the item appears in the database, return its details in the format: item name,value,EmType,measuerdby,metric used. If the item is not listed in the database, create a new item with a reasonable emission value and assign it an appropriate EmType from the list.

''';
    final content = Content.text(msg);
    Uint8List bytes = await img.readAsBytes();
    String mimeType = lookupMimeType(img.path) ?? 'application/octet-stream';
    final imageContent = Content.data(mimeType, bytes);
    final response = await model.generateContent([content, imageContent]);
    print("response from gemini: ${(response.text)}");
    setState(() {
      _geminiResponse = response.text ?? " ";
    });
    Item newItem = createItemFromCommaSeparatedString(_geminiResponse);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Additem(
                item_: newItem,
              )),
    );
  }

  void signout() {
    FirebaseAuth.instance.signOut();
  }

  void cancelSelection() {
    setState(() {
      _image = null;
      _imageCropped = false;
      _geminiResponse = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Image Input'),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "lib/images/image_select.jpg",
                    height: 275,
                  ),
            SizedBox(
              height: 20,
            ),
            if (!_imageCropped) ...[
              ElevatedButton(
                onPressed: () => getimage(ImageSource.gallery),
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.green)),
                child: Text("Upload from Device"),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => getimage(ImageSource.camera),
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.green)),
                child: Text("Upload from Camera"),
              ),
            ] else ...[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: cancelSelection,
                      style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(Colors.red)),
                      child: Text("Cancel"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () => sendImage(context, _image!),
                      style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(Colors.green)),
                      child: Text("Generator"),
                    ),
                  ],
                ),
              ),
            ],
            if (_geminiResponse.isNotEmpty) ...[
              SizedBox(
                height: 20,
              ),
              Text(
                _geminiResponse,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
