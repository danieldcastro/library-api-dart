import 'package:books_api/app/data/repositories/user_repository.dart';
import 'package:test/test.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = UserRepository();
    });

    test('Register a user', () async {
      // Arrange
      final user = {
        'name': 'John Doe',
        'email': 'teste@teste.com',
        'password': 'blabla'
      };

      // Act
      final result = await userRepository.createAndReturn(user);

      // Assert
      expect(result, user);
    });
  });
}
