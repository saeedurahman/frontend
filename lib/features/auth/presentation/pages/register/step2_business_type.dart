import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/presentation/cubit/register_cubit.dart';
import 'package:frantend/features/register/presentation/cubit/register_state.dart';
import 'package:frantend/features/register/presentation/widgets/business_type_card.dart';
import 'package:frantend/features/register/presentation/widgets/register_scaffold.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/utils/responsive/responsive.dart';
import 'package:go_router/go_router.dart';

class Step2BusinessTypePage extends StatelessWidget {
  const Step2BusinessTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final crossCount = context.responsiveValue(compact: 2, medium: 3, expanded: 4);

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final selected = cubit.data.businessType;

        return RegisterScaffold(
          currentStep: 2,
          showHeaderActions: true,
          maxWidth: 960,
          title: 'Select your business niche',
          subtitle:
              "We'll pre-configure your PakPOS modules based on your selection.",
          bottomNavigation: RegisterBottomNav(
            stepLabel: 'Step 2 of 4',
            onBack: () => context.go(RouteNames.registerStep1),
            onNext: () {
              final businessType = cubit.data.businessType;
              if (businessType == null) {
                AppAlerts.showErrorMessage(
                  context,
                  'Please select a business type',
                );
                return;
              }
              context.go(RouteNames.registerStep3);
            },
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: context.isMobile ? 0.85 : 1.05,
            ),
            itemCount: kBusinessTypes.length,
            itemBuilder: (context, index) {
              final option = kBusinessTypes[index];
              return BusinessTypeCard(
                option: option,
                isSelected: selected == option.id,
                onTap: () => cubit.setBusinessType(option.id),
              );
            },
          ),
        );
      },
    );
  }
}
