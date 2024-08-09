import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../domain/models/vesta_exception.dart';
import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import 'firebase_vestausers_service.dart';

class FirebaseAuthenticationService extends AuthenticationService {
  //stream to listen to auth changes
  @override
  Stream<bool> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges().map(
        (user) {
          if (user == null) {
            return false;
          }
          return true;
        },
      );

  @override
  Future<VestaUser> createUserWithEmailAndPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(username);
      return VestaUser(
        id: user.uid,
        username: username,
        email: user.email ?? '',
        photoURL: user.photoURL ?? '',
        isAnonymous: user.isAnonymous,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('email-already-in-use');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VestaUser?> getCurrentUserOrNull() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    //do a call to firestore to get the user data form the vesta_users collection
    FirebaseVestaUsersService usersService = FirebaseVestaUsersService();
    VestaUser? vestaUser = await usersService.read(user.uid);
    log("User data from firestore: $vestaUser.toString()");
    return VestaUser(
      id: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
      isAnonymous: user.isAnonymous,
      gender: vestaUser?.gender,
      age: vestaUser?.age,
      weight: vestaUser?.weight,
      height: vestaUser?.height,
      address: vestaUser?.address,
      contacts: vestaUser?.contacts,
      emergencyResponseEnabled: vestaUser?.emergencyResponseEnabled,
      hasFinishedOnboarding:true
    );
    // vestaUser?.hasFinishedOnboarding,
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<VestaUser> signInAnonymously() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    User? user = userCredential.user;
    return VestaUser(
      id: user!.uid,
      username: user.displayName ?? 'Guest',
      email: user.email ?? '',
      photoURL: user.photoURL ?? '',
      isAnonymous: user.isAnonymous,
    );
  }

  @override
  Future<VestaUser> turnAnonymousUserIntoUser(
      VestaUser vestaUser, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'auth/operation-not-allowed',
            message: 'Anonymous sign-in not enabled');
      }
      UserCredential userCredential = await user.linkWithCredential(
        EmailAuthProvider.credential(
          email: vestaUser.email,
          password: password,
        ),
      );
      await user.updateDisplayName(vestaUser.username);
      user = userCredential.user;

      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        log("New user created with Google Sign-In.");
      } else {
        log("Existing user logged in with Google Sign-In.");
      }

      return VestaUser(
        id: user!.uid,
        username: user.displayName ?? 'Guest',
        email: user.email ?? '',
        photoURL: user.photoURL ?? '',
        isAnonymous: user.isAnonymous,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/credential-already-in-use' ||
          e.code == 'provider-already-linked') {
        // Credential already in use, perform a login instead
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(
          EmailAuthProvider.credential(
            email: vestaUser.email,
            password: password,
          ),
        );
        User user = userCredential.user!;
        return VestaUser(
          id: user.uid,
          username: user.displayName ?? 'Guest',
          email: user.email ?? '',
          photoURL: user.photoURL ?? '',
          isAnonymous: user.isAnonymous,
        );
      } else if (e.code == 'auth/operation-not-allowed') {
        // Anonymous sign-in not enabled, create a new credential
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: vestaUser.email,
          password: password,
        );
        User user = userCredential.user!;
        return VestaUser(
          id: user.uid,
          username: user.displayName ?? 'Guest',
          email: user.email ?? '',
          photoURL: user.photoURL ?? '',
          isAnonymous: user.isAnonymous,
        );
      } else {
        rethrow; // Rethrow any other exceptions
      }
    }
  }

  @override
  Future<VestaUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      UserCredential? userCredential;
      if (currentUser != null && currentUser.isAnonymous) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        userCredential = await currentUser.linkWithCredential(credential);
      } else {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }

      return VestaUser(
        id: userCredential.user!.uid,
        username: userCredential.user?.displayName ?? 'Guest',
        email: userCredential.user?.email ?? '',
        photoURL: userCredential.user?.photoURL ?? '',
        isAnonymous: userCredential.user?.isAnonymous ?? true,
      );
    } on FirebaseAuthException catch (e) {
      throw VestaException(
        message: e.code,
        code: e.code,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VestaUser> signInWithGoogle() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      UserCredential? userCredential;
      if (currentUser != null && currentUser.isAnonymous) {
        // Handle the sign-in and linking with the anonymous account
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential = await currentUser.linkWithCredential(credential);
      } else {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        log("New user created with Google Sign-In.");
      } else {
        log("Existing user logged in with Google Sign-In.");
      }

      return VestaUser(
        id: userCredential.user!.uid,
        username: userCredential.user?.displayName ?? 'Guest',
        email: userCredential.user?.email ?? '',
        photoURL: userCredential.user?.photoURL ?? '',
        isAnonymous: userCredential.user?.isAnonymous ?? false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw Exception('credential-already-in-use');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VestaUser> signInWithApple() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      UserCredential? userCredential;
      if (currentUser != null && currentUser.isAnonymous) {
        // Handle the sign-in and linking with the anonymous account
        AuthorizationCredentialAppleID appleCredential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ],
        );
        OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final credentialFirebase = oAuthProvider.credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
        userCredential =
            await currentUser.linkWithCredential(credentialFirebase);
        // ... handle the userCredential and return a StashUser
      } else {
        AuthorizationCredentialAppleID credential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        //User apple credential to do a log in
        OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final credentialFirebase = oAuthProvider.credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        userCredential = await FirebaseAuth.instance
            .signInWithCredential(credentialFirebase);
      }

      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        log("New user created with Google Sign-In.");
      } else {
        log("Existing user logged in with Google Sign-In.");
      }

      return VestaUser(
        id: userCredential.user!.uid,
        username: userCredential.user?.displayName ?? 'Guest',
        email: userCredential.user?.email ?? '',
        photoURL: userCredential.user?.photoURL ?? '',
        isAnonymous: userCredential.user?.isAnonymous ?? false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw Exception('credential-already-in-use');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VestaUser> updateUser(VestaUser vestaUser) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.updateDisplayName(vestaUser.username);
      await user.updatePhotoURL(vestaUser.photoURL);

      //update email if needed
      if (user.email != vestaUser.email) {
        await user.updateEmail(vestaUser.email);
      }

      return VestaUser(
        id: user.uid,
        username: user.displayName ?? 'Guest',
        email: user.email ?? '',
        photoURL: user.photoURL ?? '',
        isAnonymous: user.isAnonymous,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteAccount(String id) async {
    try {
      const url =
          'https://us-central1-stashed-app.cloudfunctions.net/deleteUserData';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': id,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        log("User data deleted successfully.");
        return true;
      } else {
        log("Failed to delete user data: ${response.body}");
      }
    } catch (e) {
      log("Failed to delete user data due to an exception");
    }
    return false;
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
