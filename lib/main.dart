import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/screens/customer/home/customer_tab_maneger.dart';
import 'package:gmach1/screens/gmach%20screen/tab_maneger.dart';
import 'package:gmach1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmach1/screens/gmach screen/tab_maneger.dart';
import 'package:gmach1/screens/gmach screen/add_product_screen.dart';
// import 'file:///C:/Users/dvora%20naouri/Desktop/GMACH4U/gmachApp/lib/screens/gmach%20screen/tab_maneger.dart';

import 'package:splashscreen/splashscreen.dart';

import 'utils/location_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Gmach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _locationBuilder(context),
    );
  }

  FutureBuilder _locationBuilder(BuildContext context){
    return FutureBuilder<List<City>>(
        future: LocationHelper.loadCountriesJson(context),
        builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            LocationHelper().init(snapshot.data);
            return _authBuilder();
          }
          return Container(color: Colors.white);
        }
    );
  }

  // cheak if the user is olraedy login
  Widget _authBuilder() {
    if (FirebaseAuth.instance.currentUser == null) {
      return LoginScreen();
    }
    //return HomeScreen();
    // return TabManager();
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if(snapshot.hasError){
            return LoginScreen();
          }

          final prefs = snapshot.data;
          final isGmach = prefs.getBool('isGmach') ?? false;

          return isGmach ? TabManager() : CustomerTabManager();

    });
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
//class that made opening screen with our logo
class _MyAppState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),// after the opening screen the app will open
        title: new Text(
          'Welcome To GMACH4U',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),

        image: Image.asset("assets/images/gmach_image1.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        // onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.green);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}
