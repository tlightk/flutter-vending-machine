enum MessageTypes {
  outOfStock('Sorry, we are out of stock.'),
  empty(''),
  insufficientFunds('Insufficient funds.');

  final String message;
  const MessageTypes(this.message);
}
