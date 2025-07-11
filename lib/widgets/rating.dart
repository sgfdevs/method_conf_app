import 'package:flutter/material.dart';
import 'package:method_conf_app/theme.dart';

class Rating extends StatelessWidget {
  final RatingSelectedCallback onSelected;
  final int? currentValue;

  const Rating({
    super.key,
    required this.onSelected,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildButton(1),
        _buildButton(2),
        _buildButton(3),
        _buildButton(4),
        _buildButton(5),
      ],
    );
  }

  Widget _buildButton(int value) {
    var selected = currentValue == value;

    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      padding: const EdgeInsets.all(20),
      elevation: 0,
      shape: const CircleBorder(),
      fillColor: selected ? AppColors.primaryDark : AppColors.neutralExtraLight,
      child: Text(
        value.toString(),
        style: TextStyle(
          color: selected ? Colors.white : AppColors.primary,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        onSelected(value);
      },
    );
  }
}

typedef RatingSelectedCallback = void Function(int value);
