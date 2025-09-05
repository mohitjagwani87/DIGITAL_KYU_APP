import 'package:flutter/material.dart';
import 'package:kycapp/widget/app_themes.dart';

/// This file contains reusable form field widgets that can be used across the app.
/// Centralizing these form elements improves consistency and reduces code duplication.

/// Standard text input field with consistent styling
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final void Function(String)? onChanged;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Dropdown field with consistent styling
class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final AutovalidateMode autovalidateMode;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isExpanded = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: isExpanded,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(hintText: hint),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Date picker field with consistent styling
class AppDatePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime)? onDateSelected;
  final AutovalidateMode autovalidateMode;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      readOnly: true,
      autovalidateMode: autovalidateMode,
      onTap: () async {
        // Hide keyboard
        FocusScope.of(context).requestFocus(FocusNode());

        // Set default dates if not provided
        final initialDateTime = initialDate ?? DateTime.now();
        final firstDateTime = firstDate ?? DateTime(1900);
        final lastDateTime = lastDate ?? DateTime(2100);

        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: firstDateTime,
          lastDate: lastDateTime,
        );

        if (pickedDate != null) {
          final formattedDate =
              '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
          controller.text = formattedDate;

          if (onDateSelected != null) {
            onDateSelected!(pickedDate);
          }
        }
      },
      suffixIcon: const Icon(Icons.calendar_today),
    );
  }
}

/// Checkbox field with label
class AppCheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?)? onChanged;

  const AppCheckboxField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}

/// Radio group with consistent styling
class AppRadioGroup<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<Map<String, dynamic>> options;
  final Function(T?) onChanged;
  final String titleKey;
  final String valueKey;

  const AppRadioGroup({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.titleKey = 'title',
    this.valueKey = 'value',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ...options.map((option) {
          final optionValue = option[valueKey] as T;
          final optionTitle = option[titleKey] as String;

          return RadioListTile<T>(
            title: Text(optionTitle, style: AppTextStyles.bodyMedium),
            value: optionValue,
            groupValue: value,
            onChanged: onChanged,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// File upload field with consistent styling
class AppFileUploadField extends StatelessWidget {
  final String label;
  final String? selectedFileName;
  final VoidCallback onPickFile;
  final VoidCallback? onClearFile;
  final String? helperText;

  const AppFileUploadField({
    super.key,
    required this.label,
    this.selectedFileName,
    required this.onPickFile,
    this.onClearFile,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.upload_file, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFileName ?? 'Choose file',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color:
                          selectedFileName != null
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedFileName != null && onClearFile != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClearFile,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(helperText!, style: AppTextStyles.bodySmall),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Form section header with consistent styling
class FormSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const FormSectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.heading4),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle!, style: AppTextStyles.bodySmall),
          ),
        const Divider(height: 24),
      ],
    );
  }
}
