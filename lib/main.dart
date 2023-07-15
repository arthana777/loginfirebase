import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginfirebase/profilescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  // Initialize firebase app
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          }
          // Show a loading indicator while initializing Firebase
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found with that email");
      }
      // Handle other FirebaseAuthException cases here
      return null;
    } catch (e) {
      // Handle other exceptions here
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // create textediting controller
    TextEditingController _emailcontroller=TextEditingController();
    TextEditingController _passwordcontroller=TextEditingController();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('my app title',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              fontSize: 28,
            ),),
            Text('Login to Your App',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 44,
              fontWeight: FontWeight.bold),),
            SizedBox(height: 44,),
            TextField(
              controller: _emailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'user email',
                prefixIcon: Icon(Icons.email,
                color: Colors.black54,),
              ),
            ),
            SizedBox(height: 26,),
            TextField(
              controller: _passwordcontroller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
                prefixIcon: Icon(Icons.security,color: Colors.black54,)
              ),
            ),
            TextButton(onPressed: (){},
                child: Text('forgot password ?')),
            SizedBox(height: 88,),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.blue,
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: ()async{
                  User? user=await loginUsingEmailPassword(
                      email: _emailcontroller.text, password: _passwordcontroller.text);
                  print(user);
                  if(user!=null){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  }
                },
                child: Text('Login',
                style: TextStyle(color: Colors.white,
                fontSize: 18.0),),
              ),
            )
          ],
        ),
      ),
    );
  }
}



