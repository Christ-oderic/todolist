import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist/features/todo/data/datasources/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signUpWithEmail(String email, String password) async {
    final user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user!;
    return UserModel(uid: user.uid, email: user.email);
  }

  Future<UserModel> logInWithEmail(String email, String password) async {
    final userCredential = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ));
    final user = userCredential.user!;
    return UserModel(uid: user.uid, email: user.email);
  }

  Future<void> signOut() async => await _auth.signOut();

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
}
