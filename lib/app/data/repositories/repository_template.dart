import 'package:vania/vania.dart';

abstract class RepositoryTemplate<T extends Model> {
  Future<Map<String, dynamic>> createAndReturn(Map<String, dynamic> obj) async {
    T model = createModelInstance();
    return await model.query().create(obj);
  }

  T createModelInstance();
}
