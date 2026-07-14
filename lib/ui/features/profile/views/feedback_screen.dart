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
          title: const Text('Спасибо'),
          content: const Text('Ваше сообщение отправлено.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (context.mounted) context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Обратная связь')),
      resizeToAvoidBottomInset: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
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
              border: OutlineInputBorder(),
            ),
          ),
          if (_viewModel.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _viewModel.errorMessage!,
              style: AppTextStyles.caption
                  .copyWith(color: BrandColors.error),
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
