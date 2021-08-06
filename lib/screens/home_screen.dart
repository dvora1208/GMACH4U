// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gmach1/screens/login_screen.dart';
// import 'package:gmach1/tab_maneger.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//         actions: [
//           FlatButton(
//             child: Text('logout'),
//             onPressed: (){
//               FirebaseAuth.instance.signOut();
//               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)  => RegisterScreen()));
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)  => LoginScreen()));
//             },
//           )
//         ],
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Text("Hi!!"),
//             FlatButton(
//               child: Text("Go to second page"),
//               onPressed: ()=> goToSecond(context)
//             ),
//           ],
//         ),
//
//       ),
//     );
//   }
//
//   goToSecond(BuildContext context) {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>TabManager()));
//   }
// }
