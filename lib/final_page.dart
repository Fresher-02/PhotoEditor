// import 'package:app1/main.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:photofilters/photofilters.dart';
// import 'package:image/image.dart' as imageLib;

// class FinalScreen extends StatefulWidget {
//   var txt;
//   FinalScreen({Key? key, this.txt}) : super(key: key);

//   @override
//   _FinalScreenState createState() => _FinalScreenState();
// }

// class _FinalScreenState extends State<FinalScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.backup),
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => MyApp()));
//             },
//           ),
//         ),
//         body: Container(
//           child: Text("$widget.txt"),
//         ));
//   }
// }




























// class FinalPage extends StatelessWidget {
//   const FinalPage({Key? key, required this.imagee, required this.finalphoto})
//       : super(key: key);
//   final imagee;
//   final finalphoto;

//   Future filterImage(context) async {
//     var fileName;
//     File imageFile;
//     imageFile = finalphoto;
//     fileName = imagee.path;
//     var image = imageLib.decodeImage(imageFile.readAsBytesSync());
//     image = imageLib.copyResize(image!, width: 600);
//     Map imagefile = await Navigator.push(
//       context,
//       new MaterialPageRoute(
//         builder: (context) => new PhotoFilterSelector(
//           title: Text("Photo Filter Example"),
//           image: image!,
//           filters: presetFiltersList,
//           filename: fileName,
//           loader: Center(child: CircularProgressIndicator()),
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var imageFile;
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Photo Filter Example'),
//       ),
//       body: Center(
//         child: new Container(child: imageFile),
//       ),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: () => filterImage(context),
//         tooltip: 'Pick Image',
//         child: new Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }
