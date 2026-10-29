import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart';
import 'package:frantend/features/subscription/presentation/contact_launcher.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:intl/intl.dart';

/// Full-screen page shown while the subscription blocks the app.
///
/// Plain words, big buttons. The only ways out are paying (then "I have paid,
/// refresh") or logging out.
class SubscriptionExpiredPage extends StatefulWidget {
  const SubscriptionExpiredPage({
    super.key,
    this.openUrl = defaultUrlOpener,
    this.onLogout,
  });

  final UrlOpener openUrl;

  /// Defaults to a full sign-out.
  final Future<void> Function()? onLogout;

  @override
  State<SubscriptionExpiredPage> createState() =>
      _SubscriptionExpiredPageState();
}

class _SubscriptionExpiredPageState extends State<SubscriptionExpiredPage> {
  bool _checking = false;

  static String headline(SubscriptionState state) {
    switch (state.block?.code ?? state.status?.status) {
      case SubscriptionFailure.codeSuspended:
      case 'suspended':
        return 'Your account is suspended';
      case SubscriptionFailure.codeCancelled:
      case 'cancelled':
      case 'canceled':
        return 'Your subscription was cancelled';
      default:
        return 'Your subscription has ended';
    }
  }

  Future<void> _open(Uri? uri) async {
    if (uri == null) return;
    var opened = false;
    try {
      opened = await widget.openUrl(uri);
    } catch (_) {}
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  Future<void> _refresh() async {
    final cubit = context.read<SubscriptionCubit>();
    setState(() => _checking = true);
    final usable = await cubit.load();
    if (!mounted) return;
    setState(() => _checking = false);
    if (!usable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We cannot see your payment yet. Please try again in a few '
            'minutes, or call us.',
          ),
        ),
      );
    }
    // When usable, the router guard sends the user back into the app.
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SubscriptionCubit>().state;
    final contact = state.contact;
    final call = ContactLinks.call(contact);
    final whatsapp = ContactLinks.whatsapp(contact);
    final expiredAt = state.expiredAt;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_clock_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  headline(state),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (expiredAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Ended on ${DateFormat('d MMMM yyyy').format(expiredAt.toLocal())}',
                    key: const Key('expired-date'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  state.message,
                  key: const Key('expired-message'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'To keep using the app, please pay your subscription. '
                  'Your data is safe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),
                if (call != null)
                  _BigButton(
                    key: const Key('call-button'),
                    icon: Icons.call,
                    label: 'Call us',
                    onPressed: () => _open(call),
                  ),
                if (whatsapp != null) ...[
                  const SizedBox(height: 12),
                  _BigButton(
                    key: const Key('whatsapp-button'),
                    icon: Icons.chat,
                    label: 'WhatsApp us',
                    onPressed: () => _open(whatsapp),
                  ),
                ],
                if (call == null && whatsapp == null)
                  const Text(
                    'Please contact the support team to renew.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 12),
                _BigButton(
                  key: const Key('refresh-button'),
                  icon: Icons.refresh,
                  label: 'I have paid, refresh',
                  filled: true,
                  busy: _checking,
                  onPressed: _checking ? null : _refresh,
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  key: const Key('logout-button'),
                  onPressed: widget.onLogout ?? () => signOutWithGuard(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 26),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 20)),
      ],
    );
    const padding = EdgeInsets.symmetric(vertical: 20);
    return filled
        ? FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              padding: padding,
              backgroundColor: AppColors.primary,
            ),
            child: child,
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(padding: padding),
            child: child,
          );
  }
}
