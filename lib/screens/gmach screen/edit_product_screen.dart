import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/model/product_model.dart';
import 'package:gmach1/screens/gmach%20screen/product_screen.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel productModel;
  final String productId;

  const EditProductScreen(
      {Key key, @required this.productModel, @required this.productId})
      : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String _name = ""; //product name
  String _description = ""; //product desepcion
  int _count = 0; //coun of product
  File _imageFile; //the image of product
  bool _isValid = false; // if we have product name , count , description
  bool _isLoading = false; //the image *?*
  final _formKey = GlobalKey<FormState>();

  String _oldImageUrl;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    _name = widget.productModel.name ?? '';
    _description = widget.productModel.description ?? '';
    _count = widget.productModel.count ?? 0;
    _oldImageUrl = widget.productModel.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: _name,
                  onChanged: (val) {
                    _name = val;
                    _checkValid();
                  },
                  onSaved: (val) => _name = val,
                  decoration: InputDecoration(labelText: "Product name"),
                  validator: (val) {
                    if (val.length < 3) return "Too short name";
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  onChanged: (val) {
                    _description = val;
                    _checkValid();
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextFormField(
                  initialValue: "$_count",
                  onChanged: (val) {
                    _count = int.parse(val);
                    _checkValid();
                  },
                  decoration: InputDecoration(labelText: "Count"),
                ),
                SizedBox(height: 8),
                if (_isLoading) ...[
                  CircularProgressIndicator(),
                ],
                SizedBox(height: 8),
                const SizedBox(height: 24),

                _imageFile == null
                    ? CachedNetworkImage(
                        imageUrl: _oldImageUrl,
                        width: 180,
                        height: 180,
                      )
                    : Image.file(_imageFile, width: 180, height: 180),

                // if (_imageFile != null) ...[
                //   const SizedBox(height: 24),
                //   Center(
                //       child: Image.file(
                //         _imageFile,
                //         width: 180,
                //         height: 180,
                //       )),
                // ],
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_photo_alternate),
                    label: Text("Update Image"),
                    onPressed: () {
                      final dialog = AlertDialog(
                        title: Text("Choose source"),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          )
                        ],
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("Camera"),
                              leading: Icon(Icons.camera),
                              onTap: () => _pickImage(ImageSource.camera),
                            ),
                            ListTile(
                              title: Text("Gallery"),
                              leading: Icon(Icons.photo),
                              onTap: () => _pickImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      );

                      showDialog(
                          context: context,
                          builder: (_) => dialog,
                          useRootNavigator: false);
                    },
                  ),
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    child: Text("Update item"),
                    onPressed: _isValid ? _updateItemToDb : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //at the finall of the proces the item will added to the database
  void _updateItemToDb() async {
    //0. save form
    final form = _formKey.currentState;
    form.save();

    if (!form.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // 1. add data of new item to Firestore
    await FirebaseFirestore.instance.collection("products").doc(widget.productId).update({
      'name': _name,
      'description': _description,
      'count': _count,
    });


    // 2. if image taken to storage
    if (_imageFile != null) {
      final uploadRef =
          FirebaseStorage.instance.ref("images/products/${widget.productId}/image.png");
      final task = await uploadRef.putFile(_imageFile);

      // 2.1 after upload completed, take DownloadURL
      // add to the document another field of 'image'
      String downloadURL = await task.ref.getDownloadURL();
      FirebaseFirestore.instance.doc('products/${widget.productId}').update({
        'image': downloadURL,
      });
    }

    Navigator.pop(context);
   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)  => ProductScreen()));


  }

  //chack if all the filed are corect
  void _checkValid() {
    bool isValid = _name.isNotEmpty && _description.isNotEmpty && _count > 0;
    setState(() {
      _isValid = isValid;
    });
  }

  //the user upload  image to the galery
  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
  }
}
