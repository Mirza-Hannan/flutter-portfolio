import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_signup_auth/custom_widgets/my_toasts.dart';

class AppAuthService {

  static FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signUpUserToApp(String userEmail, String userPassword) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return userCredential.user;
    } on FirebaseAuthException catch (a) {
      if (a.code == "email-already-in-use") {
        showToast(message: "Already in use!");
      } else if (a.code == "weak-password") {
        showToast(message: "Kindly use 6 digit password");
      } else {
        showToast(message: "Authentication failed: ${a.code}");
      }
    } catch (e) {
      print("Exception occurred .........>: $e");
      showToast(message: "something went wrong");
      return null;
    }
    return null;
  }

  Future<User?> loginUserToApp(String userEmail, String userPassword) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (a) {
      if (a.code == "user-not-found") {
        showToast(message: "User not found. Please sign up first.");
      } else if (a.code == "wrong-password") {
        showToast(message: "Incorrect password. Please try again.");
      } else {
        showToast(message: "Login failed: ${a.code}");
      }
    } catch (e) {
      print("Exception occurred .........>: $e");
      showToast(message: "Something went wrong");
    }
    return null;
  }

  static Future<void> logOut()async{
    try{
      await auth.signOut();
      showToast(message: "signOut successfully");
    }catch(e){
      showToast(message: "unable to logout");
    }
  }
}