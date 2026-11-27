import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:frantend/features/settings/presentation/widgets/offline_settings_section.dart';
import 'package:frantend/features/settings/presentation/widgets/pos_settings_section.dart';
import 'package:frantend/features/settings/presentation/widgets/security_settings_section.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_state.dart';
import 'package:frantend/features/settings/presentation/settings_catalog.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_phone_no_field.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';

/// The hub of Settings: every screen, in groups. Each entry opens its own page
/// (its own route, so deep links and the back button work).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadAll(),
      child: const _SettingsHub(),
    );
  }
}

bool _multiBranch(SettingsState state) {
  if (state is! SettingsLoaded) return false;
  final branchIds = sl<AccessCubit>().state.branchIds;
  final allowed = BranchSelectorCubit.allowedBranches(state.business.branches, branchIds);
  if (branchIds.isNotEmpty) return allowed.isNotEmpty;
  return state.business.branches.length > 1;
}

class _SettingsHub extends StatelessWidget {
  const _SettingsHub();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final groups = SettingsCatalog.visible(
          can: (p) => hasPermission(context, p),
          multiBranch: _multiBranch(state),
        );
        return ListView(
          key: const Key('settings-hub'),
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
          children: [
            Text('Settings', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppDimensions.spacingLg),
            for (final g in groups) ...[
              Text(g.title, key: Key('settings-group-${g.id}'), style: AppTextStyles.titleMedium),
              const SizedBox(height: AppDimensions.spacingSm),
              LayoutBuilder(
                builder: (context, c) {
                  final cols = c.maxWidth >= 900 ? 3 : (c.maxWidth >= 560 ? 2 : 1);
                  final w = (c.maxWidth - 12 * (cols - 1)) / cols;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final e in g.entries) SizedBox(width: w, child: _EntryCard(entry: e)),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ],
        );
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final SettingsEntry entry;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key('settings-entry-${entry.id}'),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(entry.route),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(entry.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(entry.subtitle, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// The screens that used to be tabs (and sections of the Business Profile
/// tab), each on its own page now.
enum SettingsSection { business, taxRates, branchOverrides, security, pos, offline }

class SettingsSectionPage extends StatelessWidget {
  const SettingsSectionPage(this.section, {super.key});

  final SettingsSection section;

  String get _title => switch (section) {
        SettingsSection.business => 'Business Profile',
        SettingsSection.taxRates => 'Tax Rates',
        SettingsSection.branchOverrides => 'Branch Overrides',
        SettingsSection.security => 'Security',
        SettingsSection.pos => 'POS Settings',
        SettingsSection.offline => 'Offline & Sync',
      };

  @override
  Widget build(BuildContext context) {
    final Widget body = switch (section) {
      SettingsSection.security => const _Centered(child: SecuritySettingsSection()),
      SettingsSection.pos => const _Centered(child: PosSettingsSection()),
      SettingsSection.offline => const _Centered(child: OfflineSettingsSection()),
      _ => BlocProvider(
          create: (_) => sl<SettingsCubit>()..loadAll(),
          child: _LoadedSection(section: section),
        ),
    };
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_title),
        leading: BackButton(
          key: const Key('settings-back'),
          onPressed: () => context.canPop() ? context.pop() : context.go(RouteNames.settings),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(AppDimensions.spacingMd), child: body),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _SettingsCard(child: child),
          ),
        ),
      );
}

class _LoadedSection extends StatelessWidget {
  const _LoadedSection({required this.section});

  final SettingsSection section;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
        if (state is SettingsLoaded && state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
          context.read<SettingsCubit>().clearError();
        }
      },
      builder: (context, state) => switch (state) {
        SettingsInitial() || SettingsLoading() => const Center(child: CircularProgressIndicator()),
        SettingsError(:final message) => Center(child: Text(message, style: AppTextStyles.bodyMedium)),
        SettingsLoaded loaded => switch (section) {
            SettingsSection.taxRates => _TaxRatesTab(state: loaded),
            SettingsSection.branchOverrides => _BranchOverridesTab(state: loaded),
            _ => _BusinessProfileTab(state: loaded),
          },
      },
    );
  }
}

class _BusinessProfileTab extends StatefulWidget {
  const _BusinessProfileTab({required this.state});

  final SettingsLoaded state;

  @override
  State<_BusinessProfileTab> createState() => _BusinessProfileTabState();
}

class _BusinessProfileTabState extends State<_BusinessProfileTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _legalNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _addressController;
  late final TextEditingController _logoUrlController;

  @override
  void initState() {
    super.initState();
    final business = widget.state.business;
    _nameController = TextEditingController(text: business.name);
    _legalNameController =
        TextEditingController(text: business.legalName ?? '');
    _emailController = TextEditingController(text: business.email ?? '');
    _cityController = TextEditingController(text: business.city ?? '');
    _phoneController = TextEditingController(text: business.phone ?? '');
    _taxIdController = TextEditingController(text: business.taxId ?? '');
    _addressController =
        TextEditingController(text: business.addressLine1 ?? '');
    _logoUrlController = TextEditingController(text: business.logoUrl ?? '');
  }

  @override
  void didUpdateWidget(covariant _BusinessProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.business != widget.state.business) {
      final business = widget.state.business;
      _nameController.text = business.name;
      _legalNameController.text = business.legalName ?? '';
      _emailController.text = business.email ?? '';
      _cityController.text = business.city ?? '';
      _phoneController.text = business.phone ?? '';
      _taxIdController.text = business.taxId ?? '';
      _addressController.text = business.addressLine1 ?? '';
      _logoUrlController.text = business.logoUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _legalNameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _taxIdController.dispose();
    _addressController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  String? _phoneValidator(PhoneNumber? phone) {
    if (phone == null || phone.number.isEmpty) return null;
    final complete = phone.completeNumber;
    final digits = complete.startsWith('+') ? complete.substring(1) : complete;
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Phone must contain only digits after an optional +';
    }
    if (digits.length < 10 || digits.length > 15) {
      return 'Phone must be between 10 and 15 digits';
    }
    return null;
  }

  void _onPhoneChanged(PhoneNumber phone) {
    context.read<SettingsCubit>().patchBusiness(
          (b) => b.copyWith(
            phone: phone.number.isEmpty ? null : phone.completeNumber,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final business = widget.state.business;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _SettingsCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: 'Business Name *'),
                    onChanged: (v) => cubit.updateBusinessField(name: v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _legalNameController,
                    decoration: const InputDecoration(labelText: 'Legal Name'),
                    onChanged: (v) => cubit.updateBusinessField(legalName: v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (v) => cubit.updateBusinessField(email: v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                    onChanged: (v) => cubit.updateBusinessField(city: v),
                  ),
                  const SizedBox(height: 12),
                  AppPhoneNoField(
                    labelText: 'Business Phone',
                    controller: _phoneController,
                    initialCountryCode: 'PK',
                    initialFullNumber: business.phone,
                    disableLengthCheck: true,
                    validator: _phoneValidator,
                    onChanged: _onPhoneChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4),
                    child: Text(
                      'Shown on invoices and receipts',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('business-ntn-field'),
                    controller: _taxIdController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => ReceiptRules.looksLikeTaxText(v ?? '')
                        ? "That looks like a tax rate, not an NTN. Type your NTN "
                            "number only (for example 1234567-8). Tax rates are set "
                            "in 'Tax & Prices'."
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'NTN / Tax ID',
                      helperText:
                          'Your NTN number only, e.g. 1234567-8. Not a tax rate like "GST 17%".',
                    ),
                    onChanged: (v) => cubit.patchBusiness(
                          (b) => b.copyWith(
                            taxId: v.trim().isEmpty ? null : v.trim(),
                          ),
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Business Address',
                    ),
                    onChanged: (v) => cubit.patchBusiness(
                          (b) => b.copyWith(
                            addressLine1: v.trim().isEmpty ? null : v.trim(),
                          ),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text('Business Logo', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Upload your logo here once. Whether it prints is chosen per receipt '
                    'in Receipt Layouts ("Show logo").',
                    key: const Key('logo-help'),
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  if (business.logoUrl != null &&
                      business.logoUrl!.trim().isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        business.logoUrl!.trim(),
                        height: 64,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: widget.state.isUploadingLogo
                        ? null
                        : () => cubit.pickAndUploadLogo(),
                    icon: widget.state.isUploadingLogo
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file_outlined, size: 18),
                    label: Text(
                      widget.state.isUploadingLogo
                          ? 'Uploading…'
                          : 'Upload Logo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _logoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Or paste logo URL',
                      helperText:
                          'Optional — use upload above or paste a hosted image URL',
                    ),
                    onChanged: (v) => cubit.patchBusiness(
                          (b) => b.copyWith(
                            logoUrl: v.trim().isEmpty ? null : v.trim(),
                          ),
                        ),
                  ),
                  const SizedBox(height: 12),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      helperText: 'Locked at registration',
                    ),
                    child: Text(business.currencyCode),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PermissionGate(
                      permission: Perm.settingsManage,
                      mutating: true,
                      child: PrimaryButton(
                        label: 'Save Changes',
                        isLoading: widget.state.isSavingBusiness,
                        onPressed: widget.state.isSavingBusiness
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() != true) {
                                  return;
                                }
                                final ok = await cubit.saveBusinessProfile();
                                if (ok && context.mounted) {
                                  AppAlerts.showSuccessMessage(
                                    context,
                                    'Business profile saved',
                                  );
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaxRatesTab extends StatelessWidget {
  const _TaxRatesTab({required this.state});

  final SettingsLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final activeRates =
        state.taxRates.where((t) => t.isActive).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Tax Rates', style: AppTextStyles.titleMedium),
            const Spacer(),
            PermissionGate(
              anyOf: [Perm.taxManage, Perm.settingsManage],
              mutating: true,
              child: ElevatedButton.icon(
                onPressed: state.isSavingTaxRate
                    ? null
                    : () => _showAddTaxRateDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Tax Rate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'The starred rate is used for every item that has no tax rate of its own. '
          'You can pick a different rate, or mark an item tax-free, on the item itself.',
          key: Key('tax-rates-help'),
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: activeRates.isEmpty
              ? const Center(child: Text('No tax rates configured'))
              : ListView.separated(
                  itemCount: activeRates.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final rate = activeRates[index];
                    final isDefault = state.defaultTaxRateId == rate.id;
                    final isBusy =
                        state.isSavingTaxRate || state.isSavingDefaultTaxRate;
                    return ListTile(
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              rate.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            _DefaultTaxBadge(),
                          ],
                        ],
                      ),
                      subtitle: Text('${rate.rate}%'),
                      leading: Radio<String>(
                        value: rate.id,
                        groupValue: state.defaultTaxRateId,
                        activeColor: AppColors.primary,
                        onChanged: isBusy
                            ? null
                            : (value) async {
                                if (value == null) return;
                                final ok = await cubit.setDefaultTaxRate(value);
                                if (ok && context.mounted) {
                                  AppAlerts.showSuccessMessage(
                                    context,
                                    'Default tax rate updated',
                                  );
                                }
                              },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDefault)
                            PermissionGate(
                              anyOf: [Perm.taxManage, Perm.settingsManage],
                              mutating: true,
                              child: TextButton(
                                onPressed: isBusy
                                    ? null
                                    : () async {
                                        final ok =
                                            await cubit.clearDefaultTaxRate();
                                        if (ok && context.mounted) {
                                          AppAlerts.showSuccessMessage(
                                            context,
                                            'Default tax rate removed',
                                          );
                                        }
                                      },
                                child: const Text('Remove Default'),
                              ),
                            ),
                          PermissionGate(
                            anyOf: [Perm.taxManage, Perm.settingsManage],
                            mutating: true,
                            child: IconButton(
                              tooltip: 'Deactivate',
                              icon: const Icon(Icons.block, color: AppColors.error),
                              onPressed: isBusy
                                  ? null
                                  : () async {
                                      final ok = await cubit.updateTaxRateActive(
                                        rate.id,
                                        false,
                                      );
                                      if (ok && context.mounted) {
                                        AppAlerts.showSuccessMessage(
                                          context,
                                          'Tax rate deactivated',
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _showAddTaxRateDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final rateController = TextEditingController();
    final cubit = context.read<SettingsCubit>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Tax Rate'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rateController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(labelText: 'Rate %'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      final success = await cubit.createTaxRate(
        name: nameController.text.trim(),
        rate: rateController.text.trim(),
      );
      if (success && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Tax rate created');
      }
    }
    nameController.dispose();
    rateController.dispose();
  }
}

class _BranchOverridesTab extends StatefulWidget {
  const _BranchOverridesTab({required this.state});

  final SettingsLoaded state;

  @override
  State<_BranchOverridesTab> createState() => _BranchOverridesTabState();
}

class _BranchOverridesTabState extends State<_BranchOverridesTab> {
  late final TextEditingController _footerController;

  @override
  void initState() {
    super.initState();
    _footerController =
        TextEditingController(text: widget.state.branchOverrideFooter ?? '');
  }

  @override
  void didUpdateWidget(covariant _BranchOverridesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only when the saved value changed: a rebuild for any other reason must
    // not overwrite (or move the cursor in) what the user is typing.
    final saved = widget.state.branchOverrideFooter ?? '';
    if (oldWidget.state.branchOverrideFooter != widget.state.branchOverrideFooter &&
        _footerController.text != saved) {
      _footerController.value = TextEditingValue(
        text: saved,
        selection: TextSelection.collapsed(offset: saved.length),
      );
    }
  }

  @override
  void dispose() {
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final branchIds = sl<AccessCubit>().state.branchIds;
    final branches = BranchSelectorCubit.allowedBranches(
      widget.state.business.branches,
      branchIds,
    );
    final selectedBranchId = branches.any((b) => b.id == widget.state.branchOverrideId)
        ? widget.state.branchOverrideId
        : null;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String?>(
                  value: selectedBranchId,
                  decoration: const InputDecoration(labelText: 'Branch'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Select branch')),
                    ...branches.map(
                      (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
                    ),
                  ],
                  onChanged: cubit.selectBranchForOverrides,
                ),
                if (widget.state.branchOverrideId != null) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _footerController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Branch Receipt Footer',
                      helperText: widget.state.branchFooterIsOverride
                          ? 'This overrides the business default for this branch'
                          : 'Currently using business default — save to create override',
                    ),
                    onChanged: cubit.updateBranchOverrideFooter,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.state.branchFooterIsOverride)
                        OutlinedButton(
                          onPressed: widget.state.isSavingBranchOverride
                              ? null
                              : () async {
                                  final ok =
                                      await cubit.removeBranchOverride();
                                  if (ok && context.mounted) {
                                    AppAlerts.showSuccessMessage(
                                      context,
                                      'Override removed — reverted to default',
                                    );
                                  }
                                },
                          child: const Text('Remove Override'),
                        ),
                      const Spacer(),
                      PermissionGate(
                        permission: Perm.settingsManage,
                        mutating: true,
                        child: PrimaryButton(
                          label: 'Save Override',
                          isLoading: widget.state.isSavingBranchOverride,
                          onPressed: widget.state.isSavingBranchOverride
                              ? null
                              : () async {
                                  final ok = await cubit.saveBranchOverride();
                                  if (ok && context.mounted) {
                                    AppAlerts.showSuccessMessage(
                                      context,
                                      'Branch override saved',
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultTaxBadge extends StatelessWidget {
  const _DefaultTaxBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 12, color: AppColors.accentDark),
          SizedBox(width: 2),
          Text(
            'Default',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // A Material (not a decorated Container) so list tiles and switches inside
    // can paint their background and ink on it.
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: child,
      ),
    );
  }
}
