import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void main() => runApp(new MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _photo;
  File? imageFile;
  List<Filter> filters = presetFiltersList;
  var imagee;

  Future getPhoto(bool fromCamera) async {
    if (fromCamera) {
      imagee = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      imagee = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if (imagee != null) {
        _photo = File(imagee.path);
      } else {
        _photo = null;
      }
    });
  }

  Future cropImage() async {
    File? _cropped = await ImageCropper.cropImage(
        sourcePath: _photo!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (_cropped != null) {
      setState(() {
        _photo = _cropped;
      });
    } else {
      setState(() {
        _photo = _photo;
      });
    }
  }

  Future filterImage(context) async {
    imageFile = _photo;
    var fileName = basename(imageFile!.path);
    var image = imageLib.decodeImage(imageFile!.readAsBytesSync());

    Map? imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          appBarColor: Colors.deepPurple,
          title: Text("Photo Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(
              child: CircularProgressIndicator(
            color: Colors.purple,
          )),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        _photo = imagefile['image_filtered'];
      });
      print(imageFile!.path);
    } else {
      setState(() {
        _photo = _photo;
      });
    }
  }

  saveImagee(File _image) async {
    final result = await ImageGallerySaver.saveImage(_image.readAsBytesSync());
    setState(() {
      _photo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: null,
          icon: Icon(Icons.ac_unit),
        ),
        title: Text("PHOTOSHOP"),
        centerTitle: true,
        actions: [
          Row(children: [
            Container(
              child: IconButton(
                onPressed: () {
                  getPhoto(true);
                },
                icon: Icon(Icons.photo_camera),
                tooltip: "chose_from_camera",
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: IconButton(
                tooltip: "chose_from_gallery",
                onPressed: () {
                  getPhoto(false);
                },
                icon: Icon(Icons.photo),
              ),
            ),
          ])
        ],
      ),
      body: Center(
        child: _photo != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  _photo!,
                ),
              )
            : Container(
                child: Text("Image not selected"),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Text("save"),
        onPressed: () {
          if (_photo != null) {
            saveImagee(_photo!);
            final snackBar = SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("Image is saved in gallery"))
                ],
              ),
              duration: Duration(milliseconds: 1000),
              elevation: 6.0,
              behavior: SnackBarBehavior.floating,
            );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  if (imagee != null) {
                    cropImage();
                  } else {
                    final snackBar2 = SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text("Please select image before editing"))
                        ],
                      ),
                      duration: Duration(milliseconds: 1000),
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                  }
                },
                icon: Icon(Icons.crop)),
            label: 'Crop',
            tooltip: "please select image before editing",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  if (imagee != null) {
                    filterImage(context);
                  } else {
                    final snackBar2 = SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text("Please select image before editing"))
                        ],
                      ),
                      duration: Duration(milliseconds: 500),
                      elevation: 10.0,
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                  }
                },
                icon: Icon(Icons.photo_filter_sharp)),
            label: 'Filters',
            tooltip: "please select image before editing",
          ),
        ],
      ),
    );
  }
}
