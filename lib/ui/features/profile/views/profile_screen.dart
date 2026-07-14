import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/user.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../features/auth/view_models/auth_view_model.dart';
import '../view_models/profile_view_model.dart';

/// Экран профиля водителя.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProfileViewModel>();
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = _viewModel.user;
          if (user == null) {
            return _Center(text: _viewModel.errorMessage ?? 'Профиль недоступен');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AvatarHeader(user: user, onPick: _viewModel.uploadAvatar),
              const SizedBox(height: 20),
              _FieldRow(label: 'ФИО', value: user.fullName),
              _FieldRow(label: 'Паспорт', value: user.login),
              _FieldRow(
                label: 'Телефон',
                value: user.formattedPhone,
                onTap: () => _callPhone(user.phone),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/main/profile/edit'),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Редактировать профиль'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/main/profile/password'),
                icon: const Icon(Icons.lock_outline),
                label: const Text('Сменить пароль'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => context.push('/main/profile/feedback'),
                icon: const Icon(Icons.feedback_outlined),
                label: const Text('Обратная связь'),
              ),
              const SizedBox(height: 20),
              _LogoutButton(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _callPhone(String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:+7$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

Future<void> _showAvatarSource(
  BuildContext context,
  void Function(String path) onPick,
) async {
  final picker = ImagePicker();
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Камера'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('Галерея'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return;
  final xFile = await picker.pickImage(source: source, imageQuality: 80);
  if (xFile == null) return;
  onPick(xFile.path);
}

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({required this.user, required this.onPick});
  final User user;
  final void Function(String path) onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarSource(context, onPick),
          child: UserAvatar(
            avatar: user.avatar,
            initials: user.initials,
            radius: 48,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Нажмите на аватар, чтобы изменить',
          style: AppTextStyles.caption.copyWith(color: BrandColors.grayMid),
        ),
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.caption
                          .copyWith(color: BrandColors.grayMid)),
                  Text(value, style: AppTextStyles.bodyLarge),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.phone_in_talk_outlined,
                  color: BrandColors.primary),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _confirmLogout(context),
      icon: const Icon(Icons.logout_rounded, color: BrandColors.error),
      label: Text('Выйти из аккаунта',
          style: AppTextStyles.titleMedium.copyWith(color: BrandColors.error)),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BrandColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await getIt<AuthViewModel>().logout();
    }
  }
}

class _Center extends StatelessWidget {
  const _Center({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text,
            textAlign: TextAlign.center,
            style:
                AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayMid)),
      ),
    );
  }
}
