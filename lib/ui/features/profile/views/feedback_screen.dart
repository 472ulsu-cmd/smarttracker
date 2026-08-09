import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/repositories/feedback_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../view_models/feedback_view_model.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final FeedbackViewModel _viewModel;
  final _controller = TextEditingController();
  bool _didShowSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    _viewModel = FeedbackViewModel(getIt<FeedbackRepository>());
    _viewModel.addListener(_onChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_didShowSuccessDialog && _viewModel.sent && mounted) {
      _didShowSuccessDialog = true;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Сообщение отправлено'),
          content: const Text('Спасибо за обратную связь. Мы ответим вам в ближайшее время.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (context.mounted) context.pop();
              },
              child: const Text('Закрыть'),
            ),
          ],
        ),
      );
    }
    if (!_viewModel.sent) {
      _didShowSuccessDialog = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Обратная связь')),
      resizeToAvoidBottomInset: true,
      body: ListView(
        // Нижний safe-area: кнопка «Отправить» не под home-indicator.
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          Text(
            'Опишите замечание или предложение:',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ваше сообщение',
            ),
          ),
          if (_viewModel.errorMessage != null) ...[
            const SizedBox(height: 8),
            // Live-region: скринридер анонсирует ошибку отправки.
            // errorText (#B3261E) вместо error (#D32F2F) — AA-контраст для
            // читаемого текста; см. комментарий в brand_colors.dart:43-45.
            Semantics(
              container: true,
              liveRegion: true,
              label: 'Ошибка. ${_viewModel.errorMessage}',
              child: Text(
                _viewModel.errorMessage!,
                style: AppTextStyles.caption
                    .copyWith(color: BrandColors.errorText),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _viewModel.isSending
                  ? null
                  : () => _viewModel.send(_controller.text),
              child: _viewModel.isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Отправить'),
            ),
          ),
        ],
      ),
    );
  }
}
