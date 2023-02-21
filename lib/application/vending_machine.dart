import 'package:vending_machine/infrastructure/data_models/coin_quantity.dart';
import 'package:vending_machine/infrastructure/data_models/product.dart';
import 'package:vending_machine/infrastructure/types/button_types.dart';

import 'package:vending_machine/infrastructure/types/message_types.dart';
import 'package:vending_machine/infrastructure/types/coin_types.dart';

class VendingMachine {
  VendingMachine({
    required this.change,
    required this.till,
    this.balance = 0,
    this.changeAmount = 0,
    this.messageDisplay = MessageTypes.empty,
    this.products = const [],
    this.userInput = '',
    this.selectedItem,
  });

  int balance;
  CoinQuantity change;
  final CoinQuantity till;
  int changeAmount;
  List<Product> products;
  MessageTypes messageDisplay;
  String userInput;
  Product? selectedItem;

  void increaseTill(CoinTypes coin) {
    switch (coin) {
      case CoinTypes.ten:
        till.tenCoin++;
        break;
      case CoinTypes.fifty:
        till.fiftyCoin++;
        break;
      case CoinTypes.hundred:
        till.hundredCoin++;
        break;
      case CoinTypes.fiveHundred:
        till.fiveHundredCoin++;
        break;
    }
  }

  void insertCoin(CoinTypes coin) {
    increaseTill(coin);
    changeAmount = 0;
    balance += coin.value;
  }

  void displayInsufficientFundsMessage() {
    messageDisplay = MessageTypes.insufficientFunds;
  }

  void displayNoInventoryMessage() {
    messageDisplay = MessageTypes.outOfStock;
  }

  void returnChange() {
    changeAmount = balance - selectedItem!.price;
    int currentChange = changeAmount;

    if (currentChange >= 100) {
      double moduloHundred = (currentChange - (currentChange % 100)) / 100;
      for (int i = 0; i < moduloHundred; i++) {
        change.hundredCoin++;
        till.hundredCoin--;
      }
      currentChange -= 100 * moduloHundred.toInt();
    }
    if (currentChange >= 50) {
      double moduloFifty = (currentChange - (currentChange % 50)) / 50;
      for (int i = 0; i < moduloFifty; i++) {
        change.fiftyCoin++;
        till.fiftyCoin--;
      }
      currentChange -= 50 * moduloFifty.toInt();
    }
    if (currentChange >= 10) {
      double moduloTen = (currentChange - (currentChange % 10)) / 10;
      for (int i = 0; i < moduloTen; i++) {
        change.tenCoin++;
        till.tenCoin--;
      }
      currentChange -= 10 * moduloTen.toInt();
    }
  }

  void selectProduct(ButtonTypes button) {
    assert(userInput.length < 2);
    userInput += button.value;

    if (userInput.length == 2) {
      if (products.isNotEmpty) {
        selectedItem =
            products.firstWhere((product) => product.position == userInput);
        if (balance >= selectedItem!.price) {
          selectedItem!.decreaseQuantity();
          returnChange();
        } else {
          messageDisplay = MessageTypes.insufficientFunds;
        }
      } else {
        messageDisplay = MessageTypes.outOfStock;
      }
    }
  }
}
