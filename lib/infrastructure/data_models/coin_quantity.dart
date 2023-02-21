class CoinQuantity {
  CoinQuantity({
    this.tenCoin = 0,
    this.fiftyCoin = 0,
    this.hundredCoin = 0,
    this.fiveHundredCoin = 0,
  });

  int tenCoin;
  int fiftyCoin;
  int hundredCoin;
  int fiveHundredCoin;

  @override
  bool operator ==(Object other) {
    return other is CoinQuantity;
  }

  @override
  int get hashCode => 42;
}
