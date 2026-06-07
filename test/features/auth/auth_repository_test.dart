import 'package:extrahub/features/auth/data/auth_repository.dart';
import 'package:extrahub/features/auth/domain/auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late _MockFirebaseAuth auth;
  late AuthRepository repo;

  setUp(() {
    auth = _MockFirebaseAuth();
    repo = AuthRepository(auth);
  });

  group('validação @usp.br antes de tocar no FirebaseAuth', () {
    test('signIn rejeita e-mail não @usp.br', () async {
      await expectLater(
        repo.signIn(email: 'joao@gmail.com', password: 'abc12345'),
        throwsA(isA<NotUspEmail>()),
      );
      verifyNever(() => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('signUp rejeita e-mail não @usp.br', () async {
      await expectLater(
        repo.signUp(
          email: 'joao@hotmail.com',
          password: 'abc12345',
          displayName: 'Joao Silva',
        ),
        throwsA(isA<NotUspEmail>()),
      );
    });

    test('sendPasswordResetEmail rejeita e-mail não @usp.br', () async {
      await expectLater(
        repo.sendPasswordResetEmail('joao@yahoo.com'),
        throwsA(isA<NotUspEmail>()),
      );
    });
  });
}
