enum MySqlErrorEnum {
  duplicateEntry('Duplicate Entry', 1062),
  unknownDatabase('Unknown Database', 1049),
  tableDoesNotExist('Table Does Not Exist', 1146),
  foreignKeyConstraintFailsOnDelete(
      'Foreign Key Constraint Fails on Delete', 1451),
  foreignKeyConstraintFailsOnUpdate(
      'Foreign Key Constraint Fails on Update', 1452),
  columnCountMismatch('Column Count Mismatch', 1136),
  syntaxError('Syntax Error', 1064),
  lockWaitTimeout('Lock Wait Timeout', 1205),
  unknown('Unknown Error');

  final int? code;
  final String type;

  const MySqlErrorEnum(this.type, [this.code]);

  static MySqlErrorEnum fromCode(int statusCode) {
    return MySqlErrorEnum.values.firstWhere(
      (element) => element.code == statusCode,
      orElse: () => MySqlErrorEnum.unknown,
    );
  }
}
