import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../providers/transaction_provider.dart';
import '../../../../utils.dart';
import '../../utils/cashier_theme.dart';
import '../../utils/currency_formatter.dart';

class PaymentDialog extends StatefulWidget {
  final CartProvider cart;
  final Function(String) onSuccess;

  const PaymentDialog({
    super.key,
    required this.cart,
    required this. onSuccess,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _uangController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  int _kembalian = 0;
  int _uangMasuk = 0;
  bool _isTunai = true;

  @override
  void initState() {
    super.initState();
    _kembalian = 0 - widget.cart.totalAmount;
  }

  @override
  void dispose() {
    _uangController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  void _hitungKembalian(String val) {
    String cleanVal = val.replaceAll(RegExp(r'[^0-9]'), '');
    _uangMasuk = int.tryParse(cleanVal) ?? 0;
    setState(() {
      _kembalian = _uangMasuk - widget.cart.totalAmount;
    });
  }

  void _handlePaymentConfirmation() {
    showDialog(
      context: context,
      builder: (confirmCtx) => _PaymentConfirmationDialog(
        cart: widget.cart,
        isTunai: _isTunai,
        uangMasuk: _uangMasuk,
        kembalian: _kembalian,
        customerName: _namaController.text. isEmpty ? "Umum" : _namaController. text,
        onConfirm: () {
          _processPayment(confirmCtx);
        },
      ),
    );
  }

  void _processPayment(BuildContext confirmCtx) {
    HapticFeedback.heavyImpact();
    final trxProvider = Provider.of<TransactionProvider>(context, listen: false);

    widget.cart.checkout(
      trxProvider,
      customerName: _namaController.text.isEmpty ? "Umum" : _namaController.text,
      payAmount: _isTunai ? _uangMasuk : widget.cart.totalAmount,
      changeAmount: _isTunai ?  _kembalian : 0,
    );

    Navigator.pop(confirmCtx);
    Navigator.pop(context);

    widget.onSuccess("Transaksi Berhasil!   🎉");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaymentHeader(),
              const SizedBox(height: 24),
              Text(
                "Pembayaran",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: CashierTheme.textPrimary,
                ),
              ),
              const SizedBox(height:  16),
              _TotalAmountCard(totalAmount: widget.cart.totalAmount),
              const SizedBox(height: 24),
              _InputField(
                controller: _namaController,
                label: "Nama Pelanggan",
                hint: "Opsional",
                icon: Icons.person_rounded,
                textCapitalization: TextCapitalization. words,
              ),
              const SizedBox(height: 20),
              _PaymentMethodToggle(
                isTunai: _isTunai,
                onTunaiTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isTunai = true);
                },
                onQrisTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isTunai = false);
                },
              ),
              const SizedBox(height:  20),
              if (_isTunai) ...[
                _InputField(
                  controller: _uangController,
                  label: "Uang Diterima",
                  prefix: "Rp ",
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType. number,
                  autofocus: true,
                  onChanged: _hitungKembalian,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  isBold: true,
                ),
                const SizedBox(height: 16),
                _ChangeIndicator(kembalian: _kembalian),
              ] else ...[
                _QrisPlaceholder(),
              ],
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: CashierTheme.borderLight,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius. circular(16),
                        ),
                      ),
                      child: Text(
                        "Batal",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: CashierTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _ProcessButton(
                      enabled: ! (_isTunai && _kembalian < 0),
                      onPressed: _handlePaymentConfirmation,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: CashierTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CashierTheme.tealFresh.withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.payments_rounded,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}

class _TotalAmountCard extends StatelessWidget {
  final int totalAmount;

  const _TotalAmountCard({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [
            CashierTheme.tealFresh.withAlpha(26),
            CashierTheme.deepIndigo.withAlpha(13),
          ],
          begin:  Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:  BorderRadius.circular(20),
        border: Border.all(
          color: CashierTheme.tealFresh.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Total Belanja",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: CashierTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatRupiah(totalAmount),
            style: GoogleFonts.poppins(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: CashierTheme.tealFresh,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String?  hint;
  final String? prefix;
  final IconData icon;
  final TextInputType?  keyboardType;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool isBold;

  const _InputField({
    required this.controller,
    required this.label,
    this.hint,
    this.prefix,
    required this.icon,
    this. keyboardType,
    this. autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.inputFormatters,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      textCapitalization:  textCapitalization,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: GoogleFonts.inter(
        fontSize: isBold ? 20 : 15,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        color: CashierTheme.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        prefixStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CashierTheme.textPrimary,
        ),
        prefixIcon: Icon(icon, color: CashierTheme.tealFresh),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CashierTheme.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CashierTheme.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CashierTheme.tealFresh,
            width:  2,
          ),
        ),
        filled: true,
        fillColor: CashierTheme. surfaceLight,
      ),
    );
  }
}

class _PaymentMethodToggle extends StatelessWidget {
  final bool isTunai;
  final VoidCallback onTunaiTap;
  final VoidCallback onQrisTap;

  const _PaymentMethodToggle({
    required this.isTunai,
    required this.onTunaiTap,
    required this.onQrisTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CashierTheme.surfaceLight,
        borderRadius:  BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.borderLight, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MethodOption(
              isSelected: isTunai,
              icon: Icons.account_balance_wallet_rounded,
              label: "Tunai",
              onTap:  onTunaiTap,
            ),
          ),
          Expanded(
            child: _MethodOption(
              isSelected:  !isTunai,
              icon: Icons.qr_code_2_rounded,
              label: "QRIS",
              onTap: onQrisTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodOption extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MethodOption({
    required this.isSelected,
    required this.icon,
    required this. label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected ?  CashierTheme.buttonGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CashierTheme.tealFresh.withAlpha(77),
                    blurRadius:  10,
                    offset:  const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ?  Colors.white : CashierTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ?  Colors.white : CashierTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeIndicator extends StatelessWidget {
  final int kembalian;

  const _ChangeIndicator({required this.kembalian});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = kembalian >= 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPositive
            ? CashierTheme. accentSuccess. withAlpha(26)
            : CashierTheme.accentError.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPositive
              ? CashierTheme.accentSuccess. withAlpha(77)
              : CashierTheme.accentError.withAlpha(77),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Row(
            children: [
              Icon(
                isPositive ?  Icons.check_circle_rounded : Icons.error_rounded,
                color: isPositive
                    ? CashierTheme.accentSuccess
                    : CashierTheme.accentError,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                isPositive ? "Kembalian" : "Kurang",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isPositive
                      ? CashierTheme.accentSuccess
                      : CashierTheme. accentError,
                ),
              ),
            ],
          ),
          Text(
            formatRupiah(kembalian. abs()),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isPositive
                  ? CashierTheme.accentSuccess
                  : CashierTheme.accentError,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrisPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: CashierTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CashierTheme.borderLight,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CashierTheme.tealFresh.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_2_rounded,
              size: 64,
              color: CashierTheme.tealFresh. withAlpha(153),
            ),
          ),
          const SizedBox(height:  16),
          Text(
            "Scan QRIS untuk Bayar",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CashierTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tampilkan QR Code kepada pelanggan",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: CashierTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ProcessButton({
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: enabled ? CashierTheme.buttonGradient : null,
        color: enabled ? null : CashierTheme.borderLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: CashierTheme.tealFresh.withAlpha(102),
                  blurRadius:  12,
                  offset: const Offset(0, 4),
                ),
              ]
            :  [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: CashierTheme.textMuted,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Proses Pembayaran",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _PaymentConfirmationDialog extends StatelessWidget {
  final CartProvider cart;
  final bool isTunai;
  final int uangMasuk;
  final int kembalian;
  final String customerName;
  final VoidCallback onConfirm;

  const _PaymentConfirmationDialog({
    required this.cart,
    required this. isTunai,
    required this.uangMasuk,
    required this.kembalian,
    required this.customerName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(24),
      ),
      icon: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: CashierTheme.buttonGradient,
          shape:  BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: CashierTheme.tealFresh.withAlpha(77),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      title: Text(
        "Konfirmasi Pembayaran",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CashierTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ConfirmationRow(
              label: "Total",
              value: formatRupiah(cart.totalAmount),
              isBold: true,
            ),
            if (isTunai) ...[
              const SizedBox(height: 8),
              _ConfirmationRow(
                label: "Bayar",
                value: formatRupiah(uangMasuk),
              ),
              const SizedBox(height: 8),
              _ConfirmationRow(
                label: "Kembalian",
                value: formatRupiah(kembalian),
                valueColor: CashierTheme. accentSuccess,
                isBold: true,
              ),
            ],
            if (!isTunai) ...[
              const SizedBox(height: 8),
              _ConfirmationRow(
                label: "Metode",
                value: "QRIS",
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Batal",
            style:  GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: CashierTheme.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: CashierTheme.tealFresh,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Ya, Proses",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationRow extends StatelessWidget {
  final String label;
  final String value;
  final Color?  valueColor;
  final bool isBold;

  const _ConfirmationRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: CashierTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ??  CashierTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}