import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/subscription/presentation/contact_launcher.dart';
import 'package:frantend/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:intl/intl.dart';

/// Settings > Subscription: where the business stands and how to renew.
class SubscriptionSettingsPage extends StatefulWidget {
  const SubscriptionSettingsPage({super.key, this.openUrl = defaultUrlOpener});

  final UrlOpener openUrl;

  @override
  State<SubscriptionSettingsPage> createState() =>
      _SubscriptionSettingsPageState();
}

class _SubscriptionSettingsPageState extends State<SubscriptionSettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().load();
  }

  static String statusLabel(SubscriptionState state) {
    if (state.isBlocked) return 'Not active';
    if (state.isGraceReadOnly) return 'Read-only (renew to continue)';
    switch (state.status?.status) {
      case 'trial':
      case 'trialing':
        return 'Free trial';
      case 'active':
        return 'Active';
      case null:
      case '':
        return 'Unknown';
      default:
        final s = state.status!.status;
        return s[0].toUpperCase() + s.substring(1);
    }
  }

  static String _date(DateTime? value) =>
      value == null ? '-' : DateFormat('d MMMM yyyy').format(value.toLocal());

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SubscriptionCubit>().state;
    final status = state.status;
    final contact = state.contact;
    final call = ContactLinks.call(contact);
    final whatsapp = ContactLinks.whatsapp(contact);
    final mail = ContactLinks.email(contact);

    Future<void> open(Uri uri) async {
      try {
        await widget.openUrl(uri);
      } catch (_) {}
    }

    return ListView(
      children: [
        _Card(
          title: 'Your subscription',
          children: [
            _Row('Status', statusLabel(state), key: const Key('sub-status')),
            _Row('Plan', status?.planName ?? '-'),
            if (status?.trialEndsAt != null)
              _Row('Trial ends', _date(status!.trialEndsAt)),
            _Row('Subscription ends', _date(status?.subscriptionEndsAt)),
            if (state.daysLeft != null)
              _Row(
                'Days left',
                state.daysLeft! < 0 ? '0' : '${state.daysLeft}',
                key: const Key('sub-days-left'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _Card(
          title: 'How to renew',
          children: [
            const Text(
              '1. Contact us using the details below.\n'
              '2. Pay as we tell you and send us the payment receipt.\n'
              '3. When we confirm, open this page and tap Refresh.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (contact.isEmpty)
              const Text('Please contact the support team.')
            else ...[
              if (contact.phone != null) _Row('Phone', contact.phone!),
              if (contact.whatsapp != null)
                _Row('WhatsApp', contact.whatsapp!),
              if (contact.email != null) _Row('Email', contact.email!),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (call != null)
                  OutlinedButton.icon(
                    onPressed: () => open(call),
                    icon: const Icon(Icons.call),
                    label: const Text('Call'),
                  ),
                if (whatsapp != null)
                  OutlinedButton.icon(
                    onPressed: () => open(whatsapp),
                    icon: const Icon(Icons.chat),
                    label: const Text('WhatsApp'),
                  ),
                if (mail != null)
                  OutlinedButton.icon(
                    onPressed: () => open(mail),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Email'),
                  ),
                FilledButton.icon(
                  key: const Key('sub-refresh'),
                  onPressed: state.isLoading
                      ? null
                      : () => context.read<SubscriptionCubit>().load(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
