import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class TxtFomatMoney extends StatefulWidget {
  final double value;

  const TxtFomatMoney({super.key, required this.value});

  @override
  State<TxtFomatMoney> createState() => _TxtFomatMoneyState();
}

class _TxtFomatMoneyState extends State<TxtFomatMoney> {
  MoneyFormatter fmf = MoneyFormatter(amount: 0);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${fmf.copyWith(amount: widget.value, fractionDigits: 0).output.nonSymbol} vnd',
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }
}
