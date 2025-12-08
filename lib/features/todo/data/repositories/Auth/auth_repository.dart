import 'package:firebase_auth/firebase_auth.dart';
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
}
