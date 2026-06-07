import 'package:extrahub/core/extensions/string_x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isUspEmail', () {
    test('aceita @usp.br e subdomínios', () {
      expect('joao@usp.br'.isUspEmail, isTrue);
      expect('joao@icmc.usp.br'.isUspEmail, isTrue);
      expect('joao@alumni.usp.br'.isUspEmail, isTrue);
      expect('  Joao@USP.br '.isUspEmail, isTrue); // trim + case-insensitive
    });

    test('rejeita não-USP e falsificações', () {
      expect('joao@gmail.com'.isUspEmail, isFalse);
      expect('joao@usp.br.evil.com'.isUspEmail, isFalse);
      expect('joao@naousp.br'.isUspEmail, isFalse);
      expect('joao@uspbr'.isUspEmail, isFalse);
    });
  });

  group('isStrongPassword', () {
    test('exige 8+ chars com letra e número', () {
      expect('abc12345'.isStrongPassword, isTrue);
      expect('curta1'.isStrongPassword, isFalse); // < 8
      expect('semnumeros'.isStrongPassword, isFalse);
      expect('12345678'.isStrongPassword, isFalse); // sem letra
    });
  });

  group('isFullName', () {
    test('exige ao menos nome + sobrenome', () {
      expect('Felipe Maia'.isFullName, isTrue);
      expect('Felipe'.isFullName, isFalse);
      expect('F M'.isFullName, isFalse); // partes < 2 chars
    });
  });
}
