import '../../models/user.dart';
import 'repository_template.dart';

class UserRepository extends RepositoryTemplate {
  @override
  User createModelInstance() {
    return User();
  }
}
