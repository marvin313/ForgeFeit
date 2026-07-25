import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/core/settings/appearance_settings.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/core/theme/forgefit_ui.dart';
import 'package:forgefit/features/data_tools/presentation/data_management_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.weightUnit,
    required this.onLogout,
  });

  final String userId;
  final String? email;
  final String weightUnit;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceProvider);
    final controller = ref.read(appearanceProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _SettingsSection(
            title: 'Account',
            child: _SettingsRow(
              icon: Icons.person_outline_rounded,
              title: 'Signed in as',
              detail: email ?? 'ForgeFit athlete',
            ),
          ),
          const SizedBox(height: ForgeFitSpace.section),
          _SettingsSection(
            title: 'Appearance',
            child: Column(
              children: [
                _SettingsRow(
                  key: const Key('settings-accent-color'),
                  icon: Icons.palette_outlined,
                  title: 'Accent colour',
                  detail: 'Updates ForgeFit immediately',
                  trailing: DecoratedBox(
                    decoration: BoxDecoration(
                      color: appearance.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: ForgeFitColors.border),
                    ),
                    child: const SizedBox(width: 24, height: 24),
                  ),
                  onTap: () => _openAccentPicker(context, ref, appearance),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  detail: 'Dark',
                ),
                const Divider(height: 1),
                _SettingsRow(
                  key: const Key('settings-haptics'),
                  icon: Icons.vibration_outlined,
                  title: 'Haptics',
                  detail: 'Feedback for important training actions',
                  trailing: Switch.adaptive(
                    value: appearance.hapticsEnabled,
                    onChanged: (enabled) {
                      ForgeFitHaptics.selection(appearance.hapticsEnabled);
                      unawaited(controller.setHapticsEnabled(enabled));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ForgeFitSpace.section),
          _SettingsSection(
            title: 'Training',
            child: _SettingsRow(
              icon: Icons.straighten_rounded,
              title: 'Weight unit',
              detail: weightUnit == 'lb' ? 'Pounds (lb)' : 'Kilograms (kg)',
            ),
          ),
          const SizedBox(height: ForgeFitSpace.section),
          _SettingsSection(
            title: 'Data management',
            child: _SettingsRow(
              key: const Key('settings-data-management'),
              icon: Icons.folder_copy_outlined,
              title: 'Data management',
              detail: 'Sync, backup, restore, and export',
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => DataManagementScreen(userId: userId),
                ),
              ),
            ),
          ),
          const SizedBox(height: ForgeFitSpace.section),
          _SettingsSection(
            title: 'About',
            child: const _SettingsRow(
              icon: Icons.info_outline_rounded,
              title: 'ForgeFit',
              detail: 'Built. Tracked. Progressed.',
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            key: const Key('settings-log-out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ForgeFitColors.danger,
              side: const BorderSide(color: ForgeFitColors.danger),
            ),
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAccentPicker(
    BuildContext context,
    WidgetRef ref,
    ForgeFitAppearance appearance,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _AccentPickerSheet(
        initial: appearance.accent,
        hapticsEnabled: appearance.hapticsEnabled,
        onChanged: (color) {
          unawaited(ref.read(appearanceProvider.notifier).setAccent(color));
        },
        onReset: () {
          unawaited(ref.read(appearanceProvider.notifier).resetAccent());
        },
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: ForgeFitColors.textTertiary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      Card(child: child),
    ],
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
    minVerticalPadding: 10,
    onTap: onTap,
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(
      detail,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: ForgeFitColors.textSecondary),
    ),
    trailing:
        trailing ??
        (onTap == null
            ? null
            : const Icon(
                Icons.chevron_right_rounded,
                color: ForgeFitColors.textTertiary,
              )),
  );
}

class _AccentPickerSheet extends StatefulWidget {
  const _AccentPickerSheet({
    required this.initial,
    required this.hapticsEnabled,
    required this.onChanged,
    required this.onReset,
  });

  final Color initial;
  final bool hapticsEnabled;
  final ValueChanged<Color> onChanged;
  final VoidCallback onReset;

  @override
  State<_AccentPickerSheet> createState() => _AccentPickerSheetState();
}

class _AccentPickerSheetState extends State<_AccentPickerSheet> {
  late HSLColor _hsl;

  static const _presets = [
    ForgeFitAppearance.defaultAccent,
    Color(0xFF6CC5A1),
    Color(0xFF6AA9E8),
    Color(0xFFA78BFA),
    Color(0xFFE98AAB),
    Color(0xFFF1B95E),
  ];

  @override
  void initState() {
    super.initState();
    _hsl = HSLColor.fromColor(widget.initial);
  }

  void _update(HSLColor value) {
    ForgeFitHaptics.selection(widget.hapticsEnabled);
    setState(() => _hsl = value);
    widget.onChanged(value.toColor());
  }

  @override
  Widget build(BuildContext context) {
    final preview = _hsl.toColor();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Accent colour',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose any colour. ForgeFit keeps labels readable in light and dark shades.',
              style: TextStyle(color: ForgeFitColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Container(
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: preview,
                borderRadius: BorderRadius.circular(ForgeFitRadius.control),
              ),
              child: Text(
                'Live preview',
                style: TextStyle(
                  color: ForgeFitAccent.foreground(
                    ForgeFitAccent.resolve(preview),
                  ),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _ColorSlider(
              label: 'Hue',
              value: _hsl.hue,
              max: 360,
              onChanged: (value) => _update(_hsl.withHue(value)),
            ),
            _ColorSlider(
              label: 'Saturation',
              value: _hsl.saturation,
              max: 1,
              onChanged: (value) => _update(_hsl.withSaturation(value)),
            ),
            _ColorSlider(
              label: 'Brightness',
              value: _hsl.lightness,
              min: 0.05,
              max: 0.95,
              onChanged: (value) => _update(_hsl.withLightness(value)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Presets',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final color in _presets)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _update(HSLColor.fromColor(color)),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.toARGB32() == preview.toARGB32()
                              ? Colors.white
                              : ForgeFitColors.border,
                          width: color.toARGB32() == preview.toARGB32()
                              ? 2.5
                              : 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            TextButton.icon(
              key: const Key('reset-accent-color'),
              onPressed: () {
                ForgeFitHaptics.selection(widget.hapticsEnabled);
                setState(
                  () => _hsl = HSLColor.fromColor(
                    ForgeFitAppearance.defaultAccent,
                  ),
                );
                widget.onReset();
              },
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset to default mint'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSlider extends StatelessWidget {
  const _ColorSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    this.min = 0,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      Slider(value: value, min: min, max: max, onChanged: onChanged),
    ],
  );
}
