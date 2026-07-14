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
    if (_viewModel.sent && mounted) {
      showDialog<void>(
        context: context,
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
        },
      ),
    );
  }
}
