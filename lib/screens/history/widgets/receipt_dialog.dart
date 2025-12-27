import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/models.dart';
import '../../../utils.dart';
import '../utils/history_theme.dart';
import '../utils/history_helpers.dart';

class ReceiptDialog extends StatefulWidget {
  final Transaction transaction;
  final String storeName;
  final String storeAddress;
  final String storePhone;

  const ReceiptDialog({
    super.key,
    required this.transaction,
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
  });

  @override
  State<ReceiptDialog> createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  final GlobalKey _printKey = GlobalKey();

  Future<void> _captureAndSharePng() async {
    try {
      if (_printKey.currentContext == null) return;

      RenderRepaintBoundary boundary = _printKey.currentContext! 
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData! .buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final File imgFile = File('${directory.path}/nota_transaksi.png');
      await imgFile.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(imgFile.path)],
        text: 'Nota Transaksi TapNota',
      );
    } catch (e) {
      debugPrint("Gagal share:  $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow:  [
            BoxShadow(
              color: Colors.black. withAlpha(26),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: _printKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: _ReceiptContent(
                    transaction: widget.transaction,
                    storeName: widget.storeName,
                    storeAddress: widget.storeAddress,
                    storePhone: widget.storePhone,
                  ),
                ),
              ),
              _ReceiptActions(
                onClose: () => Navigator.pop(context),
                onShare: _captureAndSharePng,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptContent extends StatelessWidget {
  final Transaction transaction;
  final String storeName;
  final String storeAddress;
  final String storePhone;

  const _ReceiptContent({
    required this.transaction,
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Store Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: HistoryTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            size:  32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height:  12),

        // Store Info
        Text(
          storeName. toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: HistoryTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          storeAddress,
          style: GoogleFonts. inter(
            fontSize: 12,
            color: HistoryTheme.textSecondary,
          ),
          textAlign:  TextAlign.center,
        ),
        Text(
          "Telp:  $storePhone",
          style:  GoogleFonts.inter(
            fontSize: 12,
            color: HistoryTheme. textSecondary,
          ),
        ),

        const SizedBox(height:  16),
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: HistoryTheme.primaryGradient,
          ),
        ),
        const SizedBox(height:  16),

        // Transaction Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text(
              "Tgl:  ${DateFormat('dd/MM/yy').format(transaction.date)}",
              style: _notaStyle(),
            ),
            Text(
              "Jam: ${DateFormat('HH:mm').format(transaction.date)}",
              style: _notaStyle(),
            ),
          ],
        ),
        const SizedBox(height:  8),
        Align(
          alignment: Alignment. centerLeft,
          child: Text(
            "Pelanggan: ${transaction.customerName}",
            style: _notaStyle(isBold: true),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ID:  #${transaction.id. substring(0, 8)}",
            style: _notaStyle(color: HistoryTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: HistoryTheme.borderColor,
        ),
        const SizedBox(height: 16),

        // Items
        ... transaction.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: _notaStyle(isBold: true)),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.quantity} ${item.product.unit} x ${formatRupiah(HistoryHelpers.toInt(item.product.price))}",
                      style: _notaStyle(),
                    ),
                    Text(
                      formatRupiah(HistoryHelpers.toInt(item.subtotal)),
                      style: _notaStyle(isBold: true),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height:  16),
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: HistoryTheme. primaryGradient,
          ),
        ),
        const SizedBox(height: 16),

        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TOTAL",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight. bold,
                fontSize: 16,
                color: HistoryTheme.textPrimary,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) =>
                  HistoryTheme.primaryGradient.createShader(bounds),
              child: Text(
                formatRupiah(HistoryHelpers. toInt(transaction.totalAmount)),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("BAYAR", style: _notaStyle()),
            Text(
              formatRupiah(HistoryHelpers. toInt(transaction.paymentAmount)),
              style: _notaStyle(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("KEMBALI", style: _notaStyle()),
            Text(
              formatRupiah(HistoryHelpers.toInt(transaction. changeAmount)),
              style: _notaStyle(),
            ),
          ],
        ),

        const SizedBox(height:  24),
        Text(
          "✨ TERIMA KASIH ✨",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: HistoryTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  TextStyle _notaStyle({
    bool isBold = false,
    Color color = HistoryTheme.textPrimary,
  }) {
    return GoogleFonts. inter(
      fontSize: 13,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
  }
}

class _ReceiptActions extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onShare;

  const _ReceiptActions({
    required this.onClose,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton. icon(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              label: const Text("Tutup"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: HistoryTheme.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: HistoryTheme.primaryGradient,
                borderRadius: BorderRadius. circular(12),
                boxShadow: [
                  BoxShadow(
                    color: HistoryTheme.gradientTeal.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton. icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors. transparent,
                  shadowColor:  Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onShare,
                icon: const Icon(Icons.share_rounded, size: 20),
                label: const Text("Share"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}