import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/model/product_model.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _name = ""; //product name
  String _description = ""; //product desepcion
  int _count = 0; //coun of product
  File _imageFile; //the image of product
  bool _isValid = false; // if we have product name , count , description
  bool _isLoading = false; //the image *?*
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new item")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (val) {
                    _name = val;
                    _checkValid();
                  },
                  onSaved: (val) => _name = val,
                  decoration: InputDecoration(hintText: "Product name"),
                  validator: (val) {
                    if (val.length < 3) return "Too short name";
                    return null;
                  },
                ),
                TextFormField(
                  onChanged: (val) {
                    _description = val;
                    _checkValid();
                  },
                  decoration: InputDecoration(hintText: "Description"),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                ),
                TextFormField(
                  onChanged: (val) {
                    _count = int.parse(val);
                    _checkValid();
                  },
                  decoration: InputDecoration(hintText: "Count"),
                ),
                SizedBox(height: 8),
                if (_isLoading) ...[
                  CircularProgressIndicator(),
                ],
                SizedBox(height: 8),
                if (_imageFile != null) ...[
                  const SizedBox(height: 24),
                  Center(
                      child: Image.file(
                    _imageFile,
                    width: 180,
                    height: 180,
                  )),
                ],
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_photo_alternate),
                    label: Text("Add Image"),
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
                    child: Text("Add item"),
                    onPressed: _isValid ? _addItemToDb : null,
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
  void _addItemToDb() async {
    //0. save form
    final form = _formKey.currentState;
    form.save();

    if (!form.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // 1. add data of new item to Firestore
    var newProductRef =
        await FirebaseFirestore.instance.collection("products").add(
          ProductModel(
            name: _name,
            description: _description,
            count: _count,
            gid: FirebaseAuth.instance.currentUser.uid,
          ).toMap()
        );

    //         {
    //   'name': _name,
    //   'description': _description,
    //   'count': _count,
    // });
    final String newId = newProductRef.id;

    // 2. if image taken to storage
    if (_imageFile != null) {
      final uploadRef =
          FirebaseStorage.instance.ref("images/products/$newId/image.png");
      final task = await uploadRef.putFile(_imageFile);

      // 2.1 after upload completed, take DownloadURL
      // add to the document another field of 'image'
      String downloadURL = await task.ref.getDownloadURL();
      FirebaseFirestore.instance.doc('products/$newId').update({
        'image': downloadURL,
      });
    }

    // 3. add his id to 'myProducts' list on his gmach document
    await FirebaseFirestore.instance
        .doc("gmachs/${FirebaseAuth.instance.currentUser.uid}")
        .update({
      'myProducts': FieldValue.arrayUnion([newId]),
    });
    //
    Navigator.pop(context);
    //
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
