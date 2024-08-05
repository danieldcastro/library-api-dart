sealed class Either<L, R> {}

class Left<L, R> extends Either<L, R> {
  final L left;
  Left(this.left);
}

class Right<L, R> extends Either<L, R> {
  final R right;
  Right(this.right);
}

extension EitherFold<L, R> on Either<L, R> {
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (this is Left<L, R>) {
      return onLeft((this as Left<L, R>).left);
    } else {
      return onRight((this as Right<L, R>).right);
    }
  }
}
