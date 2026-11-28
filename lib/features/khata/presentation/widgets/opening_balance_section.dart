import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/cubit/opening_balance_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/opening_balance_fields.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';

/// [OpeningBalanceFields] on a create form: disabled with a notice offline,
/// unless the party can be saved on this device.
class OpeningBalanceSection extends StatelessWidget {
  const OpeningBalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OpeningBalanceCubit>();
    return OfflineAwareBuilder(
      builder: (context, offline) =>
          BlocBuilder<OpeningBalanceCubit, OpeningBalanceState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (offline && !cubit.worksOffline) ...[
              const OnlineOnlyBanner(message: EntryText.openingNeedsInternet),
              const SizedBox(height: AppDimensions.spacing12),
            ],
            OpeningBalanceFields(
              type: cubit.type,
              value: state.draft,
              amountError: state.amountError,
              enabled:
                  (!offline || cubit.worksOffline) && !state.submitting,
              onChanged: cubit.update,
            ),
          ],
        ),
      ),
    );
  }
}
