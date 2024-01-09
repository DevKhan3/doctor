// components/custom_dropdown_menu.dart
import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  const CustomDropdownMenu({
    Key? key,
    required this.onSelected,
    required this.itemBuilder,
    required this.initialValue,
  }) : super(key: key);

  final ValueChanged<T?> onSelected;
  final List<DropdownMenuItem<T>> Function(BuildContext context) itemBuilder;
  final T initialValue;

  @override
  _CustomDropdownMenuState<T> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: _selectedValue,
      onChanged: (T? value) {
        setState(() {
          _selectedValue = value as T;
          widget.onSelected(value);
        });
      },
      items: widget.itemBuilder(context),
    );
  }
}
