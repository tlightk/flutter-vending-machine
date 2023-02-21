import 'package:flutter_test/flutter_test.dart';
import 'package:vending_machine/application/vending_machine.dart';
import 'package:vending_machine/infrastructure/data_models/coin_quantity.dart';
import 'package:vending_machine/infrastructure/data_models/product.dart';
import 'package:vending_machine/infrastructure/types/button_types.dart';
import 'package:vending_machine/infrastructure/types/coin_types.dart';
import 'package:vending_machine/infrastructure/types/message_types.dart';

void main() {
  group('VendingMachine', () {
    test('should start with a balance of zero.', () {
      final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
      );
      expect(vendingMachine.balance, 0);
    });

    test('should be able to insert a coin.', () {
      final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
      );
      expect(vendingMachine.balance, 0);

      vendingMachine.insertCoin(CoinTypes.hundred);

      expect(vendingMachine.balance, 100);
    });

    test('should be able to press a button.', () {
      final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
      );
      expect(vendingMachine.userInput, '');

      vendingMachine.selectProduct(ButtonTypes.a);
      expect(vendingMachine.userInput, 'A');
    });

    test('should be able decrease product quantity.', () {
      final vendingMachine = VendingMachine(
          change: CoinQuantity(),
          till: CoinQuantity(
              fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
          products: [
            Product(name: 'Juice', price: 100, quantity: 5, position: 'A1'),
            Product(name: 'Coffee', price: 130, quantity: 10, position: 'A4')
          ]);

      vendingMachine.insertCoin(CoinTypes.hundred);
      vendingMachine.insertCoin(CoinTypes.hundred);

      expect(vendingMachine.balance, 200);

      vendingMachine.selectProduct(ButtonTypes.a);
      vendingMachine.selectProduct(ButtonTypes.four);

      expect(vendingMachine.userInput, 'A4');
      expect(vendingMachine.products[1].quantity, 9);
      expect(vendingMachine.changeAmount, 70);
    });
  });

  test('should return out of stock message when no products.', () {
    final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
        products: []);

    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);

    expect(vendingMachine.balance, 200);

    vendingMachine.selectProduct(ButtonTypes.a);
    vendingMachine.selectProduct(ButtonTypes.four);

    expect(vendingMachine.userInput, 'A4');
    expect(vendingMachine.messageDisplay, MessageTypes.outOfStock);
  });

  test('should return insufficient funds message when low balance.', () {
    final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
        products: [
          Product(name: 'Juice', price: 300, quantity: 5, position: 'A1'),
        ]);

    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);

    expect(vendingMachine.balance, 200);

    vendingMachine.selectProduct(ButtonTypes.a);
    vendingMachine.selectProduct(ButtonTypes.one);

    expect(vendingMachine.userInput, 'A1');
    expect(vendingMachine.messageDisplay, MessageTypes.insufficientFunds);
  });

  test('should return the right amount of change in coins.', () {
    final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
        products: [
          Product(name: 'Juice', price: 150, quantity: 5, position: 'A1'),
          Product(name: 'Coffee', price: 130, quantity: 10, position: 'A4')
        ]);

    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);

    expect(vendingMachine.balance, 300);

    vendingMachine.selectProduct(ButtonTypes.a);
    vendingMachine.selectProduct(ButtonTypes.one);

    expect(vendingMachine.userInput, 'A1');
    expect(vendingMachine.products[0].quantity, 4);
    expect(vendingMachine.changeAmount, 150);
    expect(vendingMachine.change == CoinQuantity(fiftyCoin: 1, hundredCoin: 1),
        true);
  });

  test('should remove the right amount of coins from the till.', () {
    final vendingMachine = VendingMachine(
        change: CoinQuantity(),
        till: CoinQuantity(
            fiftyCoin: 10, fiveHundredCoin: 10, hundredCoin: 10, tenCoin: 10),
        products: [
          Product(name: 'Juice', price: 150, quantity: 5, position: 'A1'),
          Product(name: 'Coffee', price: 130, quantity: 10, position: 'A4')
        ]);

    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);
    vendingMachine.insertCoin(CoinTypes.hundred);

    expect(vendingMachine.balance, 300);

    vendingMachine.selectProduct(ButtonTypes.a);
    vendingMachine.selectProduct(ButtonTypes.one);

    expect(vendingMachine.userInput, 'A1');
    expect(vendingMachine.products[0].quantity, 4);
    expect(vendingMachine.changeAmount, 150);
    expect(vendingMachine.change == CoinQuantity(fiftyCoin: 1, hundredCoin: 1),
        true);

    expect(
        vendingMachine.till ==
            CoinQuantity(
                fiftyCoin: 9,
                fiveHundredCoin: 10,
                hundredCoin: 12,
                tenCoin: 10),
        true);
  });
}
