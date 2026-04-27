import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Chip pequeno de skill/interesse (`.skill-tag` no protótipo).
///
/// Versão "estática" (apenas exibição) e versão "removível" via [onRemove].
class SkillTag extends StatelessWidget {
  const SkillTag({
    super.key,
    required this.label,
    this.onRemove,
  });

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        10,
        4,
        onRemove != null ? 4 : 10,
        4,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.txtPrimary,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(999),
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: AppColors.txtTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Wrapper que renderiza uma lista de [SkillTag] usando [Wrap].
class SkillTagList extends StatelessWidget {
  const SkillTagList({
    super.key,
    required this.tags,
    this.onRemove,
    this.spacing = 6,
    this.runSpacing = 6,
  });

  final List<String> tags;
  final void Function(String tag)? onRemove;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return Text(
        'Nenhum',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: tags
          .map((t) => SkillTag(
                label: t,
                onRemove: onRemove == null ? null : () => onRemove!(t),
              ))
          .toList(growable: false),
    );
  }
}
