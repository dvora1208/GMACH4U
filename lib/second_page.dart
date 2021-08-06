// import 'package:flutter/material.dart';
//
// import 'screens/home_screen.dart';
//
// class SecondPage extends StatefulWidget {
//   SecondPage({Key key}) : super(key: key);
//
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         title: Text('Second page'),
//       ),
//       backgroundColor: Colors.white70,
//       body: Container(
//         child: Column(
//
//           children: [
//             FlatButton(
//               child: Text('Home page'),
//               onPressed: (){
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
//               },
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }