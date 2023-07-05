import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/auth_provider.dart';
import 'package:noting/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();

    test("Shouldn't be initialized to begin with", () {
      expect(
        provider.isInitialized,
        false,
      );
    });

    test("Cannot log out if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(
        provider._isInitialized,
        true,
      );
    });

    test("User should be null before init", () {
      expect(
        provider.currentUser,
        null,
      );
    });

    test("Should init in 2 secs", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

     test("Create user should delegate to logIn func", () async {
       await provider.initialize();
      
       final user = await provider.createUser(
         email: "cum",
         password: "in ass",
       );

       expect(
         provider.currentUser,
         user,
       );
       expect(
         user.isEmailVerified,
         false,
       );
     });

    test("Logged user should be able to verify email", () async {
      await provider.initialize();
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log out and log in again", () async {
      await provider.initialize();
      await provider.logOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw NotInitializedException();
    }

    const user = AuthUser(userId: "my_id", isEmailVerified: true, email: "my_mail");
    _user = user;

    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  @override
  AuthUser? get currentUser => _user;
  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) {
      throw NotInitializedException();
    }

    const user = AuthUser(userId: "my_id", isEmailVerified: true, email: "my_mail");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }

    if (_user == null) {
      throw UserNotFoundException();
    }

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw NotInitializedException();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundException();
    }
    _user = const AuthUser(userId: "my_id", isEmailVerified: true, email: "my_mail");
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
  }
}
