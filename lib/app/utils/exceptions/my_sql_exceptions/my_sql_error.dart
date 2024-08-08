import '../../enums/my_sql_error_enum.dart';

class MySqlError {
  final String message;
  final int? code;
  final String type;

  MySqlError._(this.message, this.code, this.type);

  factory MySqlError.handleError(String responseMessage,
      [String? errorMessage]) {
    final int? errorCode = int.tryParse(
        responseMessage.split('[')[1].split(']')[0].split(':')[0].trim());

    return MySqlError.fromCode(errorCode ?? 0, errorMessage);
  }

  factory MySqlError.fromCode(int code, [String? message]) {
    final error = MySqlErrorEnum.fromCode(code);
    switch (error) {
      case MySqlErrorEnum.duplicateEntry:
        return MySqlError.duplicateEntry(message);
      case MySqlErrorEnum.unknownDatabase:
        return MySqlError.unknownDatabase(message);
      case MySqlErrorEnum.tableDoesNotExist:
        return MySqlError.tableDoesNotExist(message);
      case MySqlErrorEnum.foreignKeyConstraintFailsOnDelete:
        return MySqlError.foreignKeyConstraintFailsOnDelete(message);
      case MySqlErrorEnum.foreignKeyConstraintFailsOnUpdate:
        return MySqlError.foreignKeyConstraintFailsOnUpdate(message);
      case MySqlErrorEnum.columnCountMismatch:
        return MySqlError.columnCountMismatch(message);
      case MySqlErrorEnum.syntaxError:
        return MySqlError.syntaxError(message);
      case MySqlErrorEnum.lockWaitTimeout:
        return MySqlError.lockWaitTimeout(message);
      default:
        return MySqlError.unknownError(message);
    }
  }

  factory MySqlError.duplicateEntry([String? message]) {
    return MySqlError._(
        message ??
            'O valor fornecido já está em uso. Por favor, escolha outro.',
        MySqlErrorEnum.duplicateEntry.code,
        MySqlErrorEnum.duplicateEntry.type);
  }

  factory MySqlError.unknownDatabase([String? message]) {
    return MySqlError._(
        message ??
            'Ocorreu um problema técnico. Por favor, tente novamente mais tarde.',
        MySqlErrorEnum.unknownDatabase.code,
        MySqlErrorEnum.unknownDatabase.type);
  }

  factory MySqlError.tableDoesNotExist([String? message]) {
    return MySqlError._(
        message ??
            'Ocorreu um problema técnico. Por favor, tente novamente mais tarde.',
        MySqlErrorEnum.tableDoesNotExist.code,
        MySqlErrorEnum.tableDoesNotExist.type);
  }

  factory MySqlError.foreignKeyConstraintFailsOnDelete([String? message]) {
    return MySqlError._(
        message ??
            'Não é possível excluir este item porque ele está em uso por outros registros.',
        MySqlErrorEnum.foreignKeyConstraintFailsOnDelete.code,
        MySqlErrorEnum.foreignKeyConstraintFailsOnDelete.type);
  }

  factory MySqlError.foreignKeyConstraintFailsOnUpdate([String? message]) {
    return MySqlError._(
        message ??
            'Os dados fornecidos são inválidos. Por favor, verifique e tente novamente.',
        MySqlErrorEnum.foreignKeyConstraintFailsOnUpdate.code,
        MySqlErrorEnum.foreignKeyConstraintFailsOnUpdate.type);
  }

  factory MySqlError.columnCountMismatch([String? message]) {
    return MySqlError._(
        message ??
            'Ocorreu um erro ao processar seus dados. Por favor, verifique e tente novamente.',
        MySqlErrorEnum.columnCountMismatch.code,
        MySqlErrorEnum.columnCountMismatch.type);
  }

  factory MySqlError.syntaxError([String? message]) {
    return MySqlError._(
        message ??
            'Ocorreu um problema técnico. Por favor, tente novamente mais tarde.',
        MySqlErrorEnum.syntaxError.code,
        MySqlErrorEnum.syntaxError.type);
  }

  factory MySqlError.lockWaitTimeout([String? message]) {
    return MySqlError._(
        message ??
            'A operação demorou muito tempo para ser concluída. Por favor, tente novamente.',
        MySqlErrorEnum.lockWaitTimeout.code,
        MySqlErrorEnum.lockWaitTimeout.type);
  }

  factory MySqlError.unknownError([String? message]) {
    return MySqlError._(
        message ??
            'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.',
        null,
        MySqlErrorEnum.unknown.type);
  }

  @override
  String toString() {
    return 'Error Type: $type, Code: ${code ?? "N/A"}, Message: $message';
  }
}
