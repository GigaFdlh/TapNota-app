import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/settings_theme.dart';

class InfoDialogs {
  static void showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Versi Aplikasi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "TapNota v1.0.0\n\nAplikasi kasir modern untuk UMKM Indonesia",
          textAlign: TextAlign.center,
          style: GoogleFonts. inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Tutup",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showAboutInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius. circular(24)),
        title: Text(
          "Tentang TapNota",
          style:  GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "TapNota adalah aplikasi kasir modern yang dirancang khusus untuk membantu UMKM Indonesia dalam mengelola transaksi dengan mudah dan efisien.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Tutup",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static void showFeedback(BuildContext context, Function(String) onSuccess) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius. circular(24)),
        title: Text(
          "Kirim Feedback",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "Kritik & Saran",
            hintText: "Tulis feedback Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:  BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: SettingsTheme.tealFresh,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Batal",
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed:  () {
              Navigator.pop(ctx);
              onSuccess("Terima kasih atas feedback Anda!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SettingsTheme.tealFresh,
              foregroundColor: Colors. white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius. circular(12),
              ),
            ),
            child: Text(
              "Kirim",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static void showResetConfirm(BuildContext context, Function(String) onSuccess) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SettingsTheme. accentError. withAlpha(26),
            shape: BoxShape. circle,
          ),
          child: const Icon(
            Icons. warning_rounded,
            color: SettingsTheme.accentError,
            size: 40,
          ),
        ),
        title: Text(
          "Reset Data? ",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Semua data transaksi dan produk akan dihapus permanen. Aksi ini tidak dapat dibatalkan.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Batal",
              style: GoogleFonts. inter(fontWeight: FontWeight. w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onSuccess("Data berhasil di-reset (Dummy)");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SettingsTheme.accentError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Hapus Semua",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}