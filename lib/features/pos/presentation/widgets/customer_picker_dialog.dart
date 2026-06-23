import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_state.dart';
import 'package:frantend/core/utils/currency_formatter.dart';

class CustomerPickerDialog extends StatelessWidget {
  const CustomerPickerDialog({super.key});

  static Future<CustomerModel?> show(BuildContext context) {
    return showDialog<CustomerModel?>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => sl<CustomerPickerCubit>()..loadInitial(),
        child: const CustomerPickerDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        height: 520,
        child: BlocBuilder<CustomerPickerCubit, CustomerPickerState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Text(
                        'Select Customer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search by name or phone...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: context.read<CustomerPickerCubit>().search,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () =>
                          context.read<CustomerPickerCubit>().showCreateForm(),
                      icon: const Icon(Icons.person_add_outlined, size: 18),
                      label: const Text('Create new customer'),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Walk-in Customer'),
                  onTap: () => Navigator.pop(context, null),
                ),
                const Divider(height: 1),
                if (state.isSearching)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.showCreateForm)
                  Expanded(child: _CreateCustomerForm(query: state.searchQuery))
                else
                  Expanded(
                    child: _CustomerResults(
                      results: state.results,
                      query: state.searchQuery.trim(),
                      error: state.error,
                      onCreateTap: () =>
                          context.read<CustomerPickerCubit>().showCreateForm(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CustomerResults extends StatelessWidget {
  const _CustomerResults({
    required this.results,
    required this.query,
    required this.onCreateTap,
    this.error,
  });

  final List<CustomerModel> results;
  final String query;
  final VoidCallback onCreateTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              if (query.length >= 2) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onCreateTap,
                  icon: const Icon(Icons.add),
                  label: Text('Create "$query" as new customer'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (results.isEmpty && query.length >= 2) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No customer found'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: Text('Create "$query" as new customer'),
            ),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'Type to search customers',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(
            customer.phone ?? customer.email ?? '',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          onTap: () => Navigator.pop(context, customer),
        );
      },
    );
  }
}

class _CreateCustomerForm extends StatefulWidget {
  const _CreateCustomerForm({required this.query});

  final String query;

  @override
  State<_CreateCustomerForm> createState() => _CreateCustomerFormState();
}

class _CreateCustomerFormState extends State<_CreateCustomerForm> {
  late final TextEditingController _nameController;
  final _phoneController = TextEditingController();
  final _creditController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerPickerCubit, CustomerPickerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _creditController,
                decoration: const InputDecoration(
                  labelText: 'Credit Limit',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 8),
                Text(state.error!, style: const TextStyle(color: AppColors.error)),
              ],
              const Spacer(),
              FilledButton(
                onPressed: state.isCreating
                    ? null
                    : () async {
                        final customer = await context
                            .read<CustomerPickerCubit>()
                            .createCustomer(
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              creditLimit: _creditController.text.trim(),
                            );
                        if (customer != null && context.mounted) {
                          Navigator.pop(context, customer);
                        }
                      },
                child: state.isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Customer'),
              ),
            ],
          ),
        );
      },
    );
  }
}
