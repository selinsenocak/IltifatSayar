import 'package:flutter/material.dart';

/// The alt-çizgi (underline-only) text field style used for every input in
/// the prototype — plain background, bottom border only, border color
/// switching to [focusColor] while focused.
class UnderlineField extends StatefulWidget {
  const UnderlineField({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.textColor,
    required this.hintColor,
    required this.borderColor,
    required this.focusColor,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final Color focusColor;
  final bool obscureText;
  final int maxLines;

  @override
  State<UnderlineField> createState() => _UnderlineFieldState();
}

class _UnderlineFieldState extends State<UnderlineField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      style: TextStyle(fontSize: 15, color: widget.textColor),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        hintStyle: TextStyle(color: widget.hintColor),
        border: UnderlineInputBorder(borderSide: BorderSide(color: widget.borderColor, width: 1.5)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.borderColor, width: 1.5)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.focusColor, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
