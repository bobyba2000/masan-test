import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? inputController;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final String? label;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final bool? autoFocus;
  final bool? filled;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool required;
  final Widget? leftLabel;
  final TextStyle? textStyle;
  final String? initText;
  final InputBorder? border;
  final TextAlign? textAlign;
  final bool? enabled;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool isAutoSelectAll;

  const TextFieldWidget({
    super.key,
    this.inputController,
    this.onChanged,
    this.textInputType,
    this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.padding,
    this.filled,
    this.fillColor,
    this.prefixIcon,
    this.labelStyle,
    this.readOnly = false,
    this.onTap,
    this.required = false,
    this.leftLabel,
    this.textStyle,
    this.border,
    this.initText,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.suffixIcon,
    this.enabled,
    this.maxLines,
    this.autoFocus = false,
    this.isAutoSelectAll = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;
  late TextEditingController inputController;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    inputController = widget.inputController ?? TextEditingController(text: widget.initText);
    if (widget.isAutoSelectAll && widget.autoFocus!) {
      inputController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: inputController.value.text.length,
      );
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextFieldWidget oldWidget) {
    if (widget.initText != oldWidget.initText) {
      inputController.text = widget.initText ?? inputController.text;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.label != null,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label ?? "",
                  style: widget.labelStyle ??
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                ),
                Visibility(
                  visible: widget.required,
                  child: Text(
                    "*",
                    style: (widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(color: Colors.red),
                  ),
                ),
                const Spacer(),
                widget.leftLabel ?? const SizedBox()
              ],
            ),
          ),
        ),
        TextFormField(
          focusNode: widget.focusNode,
          controller: inputController,
          obscureText: _obscureText,
          onFieldSubmitted: widget.onFieldSubmitted,
          readOnly: widget.readOnly,
          onTap: () {
            widget.onTap?.call();
            if (widget.isAutoSelectAll) {
              inputController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: inputController.value.text.length,
              );
            }
          },
          style: widget.textStyle,
          textAlign: widget.textAlign ?? TextAlign.start,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines ?? 1,
          enabled: widget.enabled,
          autofocus: widget.autoFocus ?? false,
          decoration: InputDecoration(
              filled: widget.filled,
              border: widget.border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
              enabledBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
              focusedBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
              errorBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
              fillColor: widget.fillColor,
              hintText: widget.hintText,
              contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIconConstraints: const BoxConstraints(maxHeight: 24),
              prefixIconConstraints: const BoxConstraints(maxHeight: 24),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : widget.suffixIcon),
          keyboardType: widget.textInputType,
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
