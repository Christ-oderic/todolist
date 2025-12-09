import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist/features/todo/data/datasources/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // INSCRIPTION EMAIL ET MOT DE PASSE
  Future<UserModel> signUpWithEmail(String email, String password) async {
    final user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user!;
    return UserModel(uid: user.uid, email: user.email);
  }

  // CONNEXION EMAIL ET MOT DE PASSE
  Future<UserModel> logInWithEmail(String email, String password) async {
    final userCredential = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ));
    final user = userCredential.user!;
    return UserModel(uid: user.uid, email: user.email);
  }

  // INSCRIPTION ET CONNEXION PAR GOOGLE
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      final String webClientId =
          "380215595868-pls5gr7vjnhjuu49fvgnq46s5et76l99.apps.googleusercontent.com";
      // Configuration obligatoire pour v7.x
      await googleSignIn.initialize(clientId: webClientId);
      // Nouvelle API GoogleSignIn v7.x
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Google sign-in failed: $e");
    }
  }

  // INSCRIPTION ET CONNEXION FACEBOOK
  Future<UserModel> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ["email", "public_profile"],
    );
    if (result.status != LoginStatus.success) {
      throw Exception("Facebook login failed");
    }

    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  // DECONEXION
  Future<void> signOut() async => await _auth.signOut();
}
