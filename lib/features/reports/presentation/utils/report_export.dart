import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_tab_data.dart';

/// The dataset behind a report tab's "Export" button.
typedef ReportExport = ({String dataset, String title, String? permission});

/// What "Export" downloads on [tab]; null when the server has no dataset for
/// what the tab shows.
ReportExport? reportExportFor(ReportsTab tab) => switch (tab) {
      ReportsTab.sales => (dataset: 'sales', title: 'Sales', permission: null),
      ReportsTab.products => (
          dataset: 'top_products',
          title: 'Top products',
          permission: null,
        ),
      ReportsTab.financial => (
          dataset: 'profit_loss',
          title: 'Profit and loss',
          permission: Perm.reportsFinancial,
        ),
      // Peak hours and days are counted from the sales and their times.
      ReportsTab.time => (
          dataset: 'sales',
          title: 'Sales with date and time',
          permission: null,
        ),
      ReportsTab.security => null,
    };

const noReportExportTooltip = 'There is no file export for security alerts';
