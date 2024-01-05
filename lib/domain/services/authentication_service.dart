import '../models/vesta_user.dart';

abstract class AuthenticationService {
  Future<VestaUser?> getCurrentUserOrNull();
  Future<VestaUser> signInWithEmailAndPassword(String email, String password);
  Future<VestaUser> signInWithApple();
  Future<VestaUser> signInWithGoogle();
  Future<VestaUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<VestaUser> signInAnonymously();
  Future<VestaUser> turnAnonymousUserIntoUser(
      VestaUser vestaUser, String password);
  Future<void> signOut();
  Future<VestaUser> updateUser(VestaUser vestaUser);
  Future<bool> changePassword(String oldPassword, String newPassword);

  Future<bool> deleteAccount(String id);
}
