// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'YMusic';

  @override
  String get actionSearch => 'Tìm kiếm';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionDelete => 'Xóa';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionClose => 'Đóng';

  @override
  String get actionPlay => 'Phát';

  @override
  String get actionPause => 'Tạm dừng';

  @override
  String get errorNetwork => 'Lỗi mạng. Vui lòng kiểm tra kết nối của bạn.';

  @override
  String get errorUnknown => 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';

  @override
  String get errorUnauthorized => 'Bạn không có quyền truy cập. Vui lòng đăng nhập lại.';

  @override
  String get errorNotFound => 'Không tìm thấy tài nguyên yêu cầu.';

  @override
  String get errorTimeout => 'Yêu cầu đã hết thời gian. Vui lòng thử lại.';

  @override
  String get labelLoading => 'Đang tải...';

  @override
  String get labelNoResults => 'Không tìm thấy kết quả.';

  @override
  String get labelNoInternet => 'Không có kết nối internet.';
}
