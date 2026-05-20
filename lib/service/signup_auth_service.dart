import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => SignupAuthService());

//Taluq: Yeh ek global card (Provider) hai. Iska maqsad yeh hai ki pure
 //app mein jab bhi kisi ko authentication ka kaam karna ho, woh is card ke
// zariye SignupAuthService tak pahonch sake.


abstract class AuthService { 
  Future<UserCredential> firebaseSignUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  });
}
//Yeh ek Contract (Rule Book) hai jo batati hai
// ki signup function ka naam kya hoga aur use kya parameters chahiye.

class SignupAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> firebaseSignUp({
    required String email,
     required String password,
      required String username,
     required String fullName,}) async {
    // Implementation for signing up a new user
    //final FirebaseAuth _auth = FirebaseAuth.instance;

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );

    // 2. Optional: If you save extra data (username, fullName) to Firestore, 
    // you would call your Firestore service right here using userCredential.user.uid
    
    return userCredential;
  }
}

