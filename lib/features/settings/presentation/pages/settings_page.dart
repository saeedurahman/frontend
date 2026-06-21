import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:frantend/features/settings/presentation/cubit/settings_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/app_phone_no_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>()..loadAll(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _tabCount = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  int _tabCountFor(SettingsState state) {
    final branchCount = switch (state) {
      SettingsLoaded(:final business) => business.branches.length,
      _ => 1,
    };
    return branchCount > 1 ? 4 : 3;
  }

  void _syncTabController(int count) {
    if (_tabController != null && _tabCount == count) return;
    _tabController?.dispose();
    _tabCount = count;
    _tabController = TabController(length: count, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        _syncTabController(_tabCountFor(state));
        if (state is SettingsError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
        if (state is SettingsLoaded && state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
          context.read<SettingsCubit>().clearError();
        }
      },
      builder: (context, state) {
        final branchCount = switch (state) {
          SettingsLoaded(:final business) => business.branches.length,
          _ => 0,
        };
        final showBranchTab = branchCount > 1;
        final tabController = _tabController!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Settings', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppDimensions.spacingMd),
            TabBar(
              controller: tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              isScrollable: true,
              tabs: [
                const Tab(text: 'Business Profile'),
                const Tab(text: 'Receipt & Printing'),
                const Tab(text: 'Tax Rates'),
                if (showBranchTab) const Tab(text: 'Branch Overrides'),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                SettingsInitial() || SettingsLoading() =>
                  const Center(child: CircularProgressIndicator()),
                SettingsError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
                SettingsLoaded loaded => TabBarView(
                    controller: tabController,
                    children: [
                      _BusinessProfileTab(state: loaded),
                      _ReceiptSettingsTab(state: loaded),
                      _TaxRatesTab(state: loaded),
                      if (showBranchTab) _BranchOverridesTab(state: loaded),
                    ],
                  ),
              },
            ),
          ],
        );
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
                  TextField(
                    controller: _taxIdController,
                    decoration: const InputDecoration(
                      labelText: 'NTN / Tax ID',
                      helperText:
                          'National Tax Number — shown on invoices for tax compliance',
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
                  TextField(
                    controller: _logoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Logo URL (optional)',
                      helperText:
                          'Paste hosted image URL — upload integration pending',
                    ),
                    onChanged: (v) => cubit.patchBusiness(
                          (b) => b.copyWith(
                            logoUrl: v.trim().isEmpty ? null : v.trim(),
                          ),
                        ),
                  ),
                  if (business.logoUrl != null &&
                      business.logoUrl!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        business.logoUrl!.trim(),
                        height: 64,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptSettingsTab extends StatefulWidget {
  const _ReceiptSettingsTab({required this.state});

  final SettingsLoaded state;

  @override
  State<_ReceiptSettingsTab> createState() => _ReceiptSettingsTabState();
}

class _ReceiptSettingsTabState extends State<_ReceiptSettingsTab> {
  late final TextEditingController _footerController;

  @override
  void initState() {
    super.initState();
    _footerController = TextEditingController(text: widget.state.footerText);
  }

  @override
  void didUpdateWidget(covariant _ReceiptSettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.footerText != widget.state.footerText) {
      _footerController.text = widget.state.footerText;
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

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              _SettingsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _footerController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Receipt Footer Text',
                      ),
                      onChanged: cubit.updateFooterText,
                    ),
                    const SizedBox(height: 16),
                    Text('Paper Size', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: '58mm', label: Text('58mm')),
                        ButtonSegment(value: '80mm', label: Text('80mm')),
                      ],
                      selected: {widget.state.paperSize},
                      onSelectionChanged: (s) {
                        if (s.isNotEmpty) cubit.updatePaperSize(s.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show tax on receipt'),
                      value: widget.state.showTaxOnReceipt,
                      activeThumbColor: AppColors.primary,
                      onChanged: cubit.updateShowTaxOnReceipt,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show logo on receipt'),
                      subtitle: const Text(
                        'Logo is managed in the Business Profile tab',
                      ),
                      value: widget.state.showLogoOnReceipt,
                      activeThumbColor: AppColors.primary,
                      onChanged: cubit.updateShowLogoOnReceipt,
                    ),
                    if (widget.state.business.logoUrl != null &&
                        widget.state.business.logoUrl!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Current logo',
                          helperText:
                              'Edit logo URL in Business Profile → Save there',
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.state.business.logoUrl!,
                                style: AppTextStyles.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                widget.state.business.logoUrl!.trim(),
                                height: 32,
                                width: 32,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PrimaryButton(
                        label: 'Save Changes',
                        isLoading: widget.state.isSavingReceipt,
                        onPressed: widget.state.isSavingReceipt
                            ? null
                            : () async {
                                final ok = await cubit.saveReceiptSettings();
                                if (ok && context.mounted) {
                                  AppAlerts.showSuccessMessage(
                                    context,
                                    'Receipt settings saved',
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ReceiptPreviewCard(
                footerText: widget.state.footerText,
                paperSize: widget.state.paperSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptPreviewCard extends StatelessWidget {
  const _ReceiptPreviewCard({
    required this.footerText,
    required this.paperSize,
  });

  final String footerText;
  final String paperSize;

  @override
  Widget build(BuildContext context) {
    final width = paperSize == '58mm' ? 220.0 : 300.0;
    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Preview', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('PakPOS', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  const Text('Item x 1 ........ Rs. 100'),
                  const Divider(),
                  const Text('TOTAL  Rs. 100',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    footerText.isEmpty ? 'Thank you!' : footerText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
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
            ElevatedButton.icon(
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
          ],
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
                            TextButton(
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
                          IconButton(
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
    _footerController.text = widget.state.branchOverrideFooter ?? '';
  }

  @override
  void dispose() {
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final branches = widget.state.business.branches;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: widget.state.branchOverrideId,
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
                      PrimaryButton(
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
      child: const Text(
        'Default',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.accentDark,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
