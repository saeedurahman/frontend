$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

function Write-Stub($path, $content) {
    $full = Join-Path $root $path
    $dir = Split-Path $full -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (!(Test-Path $full)) { Set-Content -Path $full -Value $content -Encoding UTF8 }
}

# Dashboard
Write-Stub "lib/features/dashboard/data/models/dashboard_summary_model.dart" @"
class DashboardSummaryModel {
  const DashboardSummaryModel();
}
"@
Write-Stub "lib/features/dashboard/data/models/sales_trend_model.dart" @"
class SalesTrendModel {
  const SalesTrendModel();
}
"@
Write-Stub "lib/features/dashboard/data/models/kpi_model.dart" @"
class KpiModel {
  const KpiModel();
}
"@
Write-Stub "lib/features/dashboard/data/datasources/dashboard_remote_datasource.dart" @"
abstract class DashboardRemoteDataSource {
  Future<void> fetchSummary();
}
"@
Write-Stub "lib/features/dashboard/data/repositories/dashboard_repository_impl.dart" @"
import 'package:frantend/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {}
"@
Write-Stub "lib/features/dashboard/domain/entities/dashboard_data.dart" @"
class DashboardData {
  const DashboardData();
}
"@
Write-Stub "lib/features/dashboard/domain/repositories/dashboard_repository.dart" @"
abstract class DashboardRepository {}
"@
Write-Stub "lib/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart" @"
class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase();
}
"@
Write-Stub "lib/features/dashboard/domain/usecases/get_sales_trend_usecase.dart" @"
class GetSalesTrendUseCase {
  const GetSalesTrendUseCase();
}
"@
Write-Stub "lib/features/dashboard/domain/usecases/get_today_vs_yesterday_usecase.dart" @"
class GetTodayVsYesterdayUseCase {
  const GetTodayVsYesterdayUseCase();
}
"@
Write-Stub "lib/features/dashboard/presentation/cubit/dashboard_state.dart" @"
sealed class DashboardState {
  const DashboardState();
}
class DashboardInitial extends DashboardState {}
"@
Write-Stub "lib/features/dashboard/presentation/cubit/dashboard_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
}
"@

$widgets = @('kpi_cards_row','sales_trend_chart','payment_donut_chart','top_products_card','recent_transactions_card','alerts_card','branch_performance_card','peak_hours_heatmap')
foreach ($w in $widgets) {
    $class = ($w -split '_' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
    Write-Stub "lib/features/dashboard/presentation/widgets/$w.dart" "import 'package:flutter/material.dart';`nclass $class extends StatelessWidget { const $class({super.key}); @override Widget build(BuildContext context) => const SizedBox(); }`n"
}

# Products
Write-Stub "lib/features/products/data/datasources/products_remote_datasource.dart" "abstract class ProductsRemoteDataSource {}"
Write-Stub "lib/features/products/data/datasources/products_local_datasource.dart" "abstract class ProductsLocalDataSource {}"
Write-Stub "lib/features/products/data/repositories/products_repository_impl.dart" "class ProductsRepositoryImpl {}"
Write-Stub "lib/features/products/domain/entities/product.dart" "class Product { const Product({required this.id, required this.name}); final String id; final String name; }"
Write-Stub "lib/features/products/domain/repositories/products_repository.dart" "abstract class ProductsRepository {}"
Write-Stub "lib/features/products/domain/usecases/get_products_usecase.dart" "class GetProductsUseCase { const GetProductsUseCase(); }"
Write-Stub "lib/features/products/presentation/cubit/products_state.dart" "sealed class ProductsState { const ProductsState(); }"
Write-Stub "lib/features/products/presentation/cubit/products_cubit.dart" "import 'package:flutter_bloc/flutter_bloc.dart'; import 'products_state.dart'; class ProductsCubit extends Cubit<ProductsState> { ProductsCubit() : super(const ProductsState()); }"

# POS
Write-Stub "lib/features/pos/presentation/cubit/cart_state.dart" "sealed class CartState { const CartState(); } class CartInitial extends CartState {}"
Write-Stub "lib/features/pos/presentation/cubit/cart_cubit.dart" "import 'package:flutter_bloc/flutter_bloc.dart'; import 'cart_state.dart'; class CartCubit extends Cubit<CartState> { CartCubit() : super(CartInitial()); }"
foreach ($w in @('product_grid','cart_panel','payment_sheet','receipt_preview')) {
    $class = ($w -split '_' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
    Write-Stub "lib/features/pos/presentation/widgets/$w.dart" "import 'package:flutter/material.dart'; class $class extends StatelessWidget { const $class({super.key}); @override Widget build(BuildContext context) => const SizedBox(); }"
}

# Generic feature stubs
$genericFeatures = @('inventory','sales','customers','suppliers','expenses','register','reports','settings','notifications')
foreach ($f in $genericFeatures) {
    $cap = $f.Substring(0,1).ToUpper() + $f.Substring(1)
    Write-Stub "lib/features/$f/domain/entities/${f}_entity.dart" "class ${cap}Entity { const ${cap}Entity(); }"
    Write-Stub "lib/features/$f/domain/repositories/${f}_repository.dart" "abstract class ${cap}Repository {}"
    Write-Stub "lib/features/$f/data/repositories/${f}_repository_impl.dart" "class ${cap}RepositoryImpl {}"
    Write-Stub "lib/features/$f/presentation/cubit/${f}_state.dart" "sealed class ${cap}State { const ${cap}State(); }"
    Write-Stub "lib/features/$f/presentation/cubit/${f}_cubit.dart" "import 'package:flutter_bloc/flutter_bloc.dart'; import '${f}_state.dart'; class ${cap}Cubit extends Cubit<${cap}State> { ${cap}Cubit() : super(const ${cap}State()); }"
}

Write-Host "Stubs generated"
