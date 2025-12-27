import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import 'utils/settings_theme.dart';
import 'widgets/premium_header.dart';
import 'widgets/glass_profile_card.dart';
import 'widgets/settings_section_group.dart';
import 'widgets/setting_item.dart';
import 'widgets/switch_item.dart';
import 'widgets/settings_footer.dart';
import 'widgets/dialogs/edit_store_dialog.dart';
import 'widgets/dialogs/single_field_dialog.dart';
import 'widgets/dialogs/option_dialog.dart';
import 'widgets/dialogs/info_dialogs.dart';

// ============================================
// SETTINGS SCREEN
// ============================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:  const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent:  _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white. withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child:  const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width:  12),
            Expanded(
              child: Text(
                message,
                style:  const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: SettingsTheme.accentSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showEditStoreDialog() {
    showDialog(
      context: context,
      builder: (ctx) => EditStoreDialog(onSuccess: _showSuccessSnackbar),
    );
  }

  void _showEditStoreName() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final controller = TextEditingController(text: settings.storeName);

    showDialog(
      context:  context,
      builder: (ctx) => SingleFieldDialog(
        title: "Ubah Nama Toko",
        label: "Nama Toko",
        icon: Icons. store_rounded,
        controller: controller,
        onSave: () async {
          if (controller.text.isNotEmpty) {
            await settings.updateStoreName(controller. text);
            _showSuccessSnackbar("Nama toko berhasil diubah!");
          }
        },
      ),
    );
  }

  void _showEditStoreAddress() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final controller = TextEditingController(text: settings.storeAddress);

    showDialog(
      context: context,
      builder: (ctx) => SingleFieldDialog(
        title: "Ubah Alamat Toko",
        label: "Alamat Toko",
        icon: Icons. location_on_rounded,
        controller: controller,
        maxLines: 3,
        onSave: () async {
          if (controller. text.isNotEmpty) {
            await settings.updateStoreAddress(controller.text);
            _showSuccessSnackbar("Alamat toko berhasil diubah!");
          }
        },
      ),
    );
  }

  void _showEditStorePhone() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final controller = TextEditingController(text: settings.storePhone);

    showDialog(
      context: context,
      builder: (ctx) => SingleFieldDialog(
        title: "Ubah Nomor Telepon",
        label: "Nomor Telepon",
        icon: Icons.phone_rounded,
        controller: controller,
        keyboardType: TextInputType.phone,
        onSave: () async {
          if (controller. text.isNotEmpty) {
            await settings.updateStorePhone(controller.text);
            _showSuccessSnackbar("Nomor telepon berhasil diubah!");
          }
        },
      ),
    );
  }

  void _showLanguageDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder:  (ctx) => OptionDialog(
        title: "Pilih Bahasa",
        options: const [
          ("🇮🇩 Indonesia", "Indonesia"),
          ("🇬🇧 English", "English"),
        ],
        currentValue: settings. language,
        onSelect: (value) async {
          await settings.updateLanguage(value);
        },
      ),
    );
  }

  void _showCurrencyDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder:  (ctx) => OptionDialog(
        title: "Pilih Mata Uang",
        options: const [
          ("💵 IDR - Rupiah", "IDR"),
          ("💲 USD - Dollar", "USD"),
        ],
        currentValue: settings. currency,
        onSelect: (value) async {
          await settings.updateCurrency(value);
        },
      ),
    );
  }

  void _showThemeColorDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context:  context,
      builder: (ctx) => OptionDialog(
        title: "Pilih Warna Tema",
        options:  const [
          ("🟣 Ungu (Default)", "Ungu (Default)"),
          ("🔵 Biru", "Biru"),
          ("🟢 Hijau", "Hijau"),
        ],
        currentValue: settings. themeColor,
        onSelect: (value) async {
          await settings.updateThemeColor(value);
        },
      ),
    );
  }

  void _showReceiptFormatDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => OptionDialog(
        title: "Format Nota",
        options: const [
          ("📄 Standar (80mm)", "80mm"),
          ("📄 Kecil (58mm)", "58mm"),
        ],
        currentValue: settings. receiptFormat,
        onSelect: (value) async {
          await settings.updateReceiptFormat(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SettingsTheme.softGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity:  _fadeAnimation,
            child:  CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const PremiumHeader(),
                GlassProfileCard(onEditTap: _showEditStoreDialog),
                _buildSettingsSections(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSections() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: SettingsTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSectionGroup(
                title: "Profil Toko",
                icon: Icons.store_rounded,
                iconColor: SettingsTheme. tealFresh,
                index: 0,
                items: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.store_rounded,
                      title: "Nama Toko",
                      subtitle: settings.storeName,
                      onTap: _showEditStoreName,
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder:  (context, settings, _) => SettingItem(
                      icon: Icons.location_on_rounded,
                      title: "Alamat Toko",
                      subtitle: settings.storeAddress,
                      onTap: _showEditStoreAddress,
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.phone_rounded,
                      title: "Nomor Telepon",
                      subtitle: settings.storePhone,
                      onTap: _showEditStorePhone,
                      isLast: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSectionGroup(
                title: "Preferensi Umum",
                icon: Icons. tune_rounded,
                iconColor:  SettingsTheme.accentInfo,
                index: 1,
                items: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.language_rounded,
                      title:  "Bahasa",
                      subtitle: settings.language,
                      onTap: _showLanguageDialog,
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.attach_money_rounded,
                      title: "Mata Uang",
                      subtitle: settings. currency == "IDR"
                          ? "Rupiah (IDR)"
                          : settings.currency,
                      onTap: _showCurrencyDialog,
                      isLast: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSectionGroup(
                title: "Tampilan",
                icon: Icons. palette_rounded,
                iconColor:  const Color(0xFFEC4899),
                index: 2,
                items: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SwitchItem(
                      icon: Icons.dark_mode_rounded,
                      title: "Mode Gelap",
                      subtitle: "Aktifkan tema gelap",
                      value:  settings.isDarkMode,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        settings. toggleDarkMode(val);
                      },
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.color_lens_rounded,
                      title: "Warna Tema",
                      subtitle: settings.themeColor,
                      onTap: _showThemeColorDialog,
                      isLast: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSectionGroup(
                title: "Transaksi",
                icon: Icons.receipt_long_rounded,
                iconColor:  SettingsTheme.accentWarning,
                index: 3,
                items: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SettingItem(
                      icon: Icons.receipt_rounded,
                      title:  "Format Nota",
                      subtitle: "Standar (${settings.receiptFormat})",
                      onTap: _showReceiptFormatDialog,
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) => SwitchItem(
                      icon: Icons.history_rounded,
                      title:  "Simpan Riwayat Otomatis",
                      subtitle:  "Backup transaksi berkala",
                      value: settings.autoSaveHistory,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        settings.toggleAutoSaveHistory(val);
                      },
                    ),
                  ),
                  SettingItem(
                    icon: Icons.delete_forever_rounded,
                    title:  "Reset Data",
                    subtitle: "Hapus semua data",
                    onTap: () => InfoDialogs.showResetConfirm(
                      context,
                      _showSuccessSnackbar,
                    ),
                    textColor: SettingsTheme. accentError,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSectionGroup(
                title: "Tentang",
                icon: Icons.info_rounded,
                iconColor: const Color(0xFF8B5CF6),
                index: 4,
                items: [
                  SettingItem(
                    icon: Icons.info_outline_rounded,
                    title:  "Versi Aplikasi",
                    subtitle: "TapNota v1.0.0",
                    onTap: () => InfoDialogs.showAboutApp(context),
                  ),
                  SettingItem(
                    icon: Icons.description_rounded,
                    title:  "Tentang TapNota",
                    subtitle: "Informasi aplikasi",
                    onTap: () => InfoDialogs.showAboutInfo(context),
                  ),
                  SettingItem(
                    icon: Icons.feedback_rounded,
                    title:  "Kirim Feedback",
                    subtitle: "Bantu kami berkembang",
                    onTap: () => InfoDialogs.showFeedback(
                      context,
                      _showSuccessSnackbar,
                    ),
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const SettingsFooter(),
            ],
          ),
        ),
      ),
    );
  }
}