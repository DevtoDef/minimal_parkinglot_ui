// ignore_for_file: public_member_api_docs, sort_constructors_first
class FailureMessage {
  final String message;

  const FailureMessage([this.message = 'Something went wrong']);

  @override
  String toString() => 'FailureMessage(message: $message)';
}
