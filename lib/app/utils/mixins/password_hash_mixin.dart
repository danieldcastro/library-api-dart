import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cryptography/cryptography.dart';
import 'package:vania/vania.dart';

import '../extensions/string_extensions.dart';

mixin PasswordHashMixin {
  List<int> _generateSalt() {
    final random = Random.secure();
    final salt = List<int>.generate(32, (_) => random.nextInt(256));
    return salt;
  }

  Future<bool> verifyPassword(
      {required Password hashedPassword, required String password}) async {
    final decodedHashPass = base64Decode(hashedPassword.base64HashPass);

    final providedPass =
        await hashPassword(password, hashedPassword).then((value) {
      return base64Decode(value.base64HashPass);
    });

    return decodedHashPass.equals(providedPass);
  }

  Future<Password> hashPassword(String password,
      [Password? hashedPassword]) async {
    final algorithm = Argon2id(
      memory:
          hashedPassword?.memorySize ?? int.parse(env('ARGON2ID_MEMORY_COST')),
      parallelism:
          hashedPassword?.parallelism ?? int.parse(env('ARGON2ID_PARALLELISM')),
      iterations: hashedPassword?.iterations ??
          int.parse(env(
              'ARGON2ID_ITERATIONS')), // For more security, you should usually raise memory parameter, not iterations.
      hashLength: int.tryParse(env('ARGON2ID_HASH_LENGTH')) ??
          32, // Number of bytes in the returned hash
    );
    final salt = (hashedPassword?.base64Salt.isNullOrEmpty ?? true)
        ? _generateSalt()
        : base64Decode(hashedPassword!.base64Salt);

    final secretKey = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    final secretKeyBytes = await secretKey.extractBytes();

    final base64HashPass = base64Encode(secretKeyBytes);
    final base64Salt = base64Encode(salt);
    return Password(
        base64HashPass: base64HashPass,
        base64Salt: base64Salt,
        parallelism: algorithm.parallelism,
        memorySize: algorithm.memory,
        iterations: algorithm.iterations);
  }
}

class Password {
  final String base64HashPass;
  final String base64Salt;
  final int parallelism;
  final int memorySize;
  final int iterations;

  Password({
    required this.base64HashPass,
    required this.base64Salt,
    required this.parallelism,
    required this.memorySize,
    required this.iterations,
  });
}
