import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import '../state/app_controller.dart';

/// Ayarlar'daki "verilerini indir" eylemi: kullanıcının iltifatlarını +
/// tercihlerini bir .json dosyası olarak native paylaşım sayfasına verir —
/// oradan Dosyalar'a kaydedebilir, AirDrop/Mail ile gönderebilir.
Future<void> shareExportedData(AppController controller) async {
  final bytes = Uint8List.fromList(utf8.encode(controller.exportDataJson()));
  const fileName = 'iltifatsayar-verilerim.json';
  final file = XFile.fromData(bytes, mimeType: 'application/json', name: fileName);
  await Share.shareXFiles(
    [file],
    subject: 'İltifatSayar verilerim',
    // XFile.fromData'nın `name`'i web dışında yok sayılıyor; dosya adını
    // burada açıkça veriyoruz (bkz. share_plus'ın kendi dokümantasyonu).
    fileNameOverrides: [fileName],
  );
}
