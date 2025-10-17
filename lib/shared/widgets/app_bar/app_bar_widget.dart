import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_text_styles.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? photo;

  const AppBarWidget({super.key, required this.userName, this.photo});

  @override
  Size get preferredSize => const Size.fromHeight(128);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: AppColors.primary,
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: ListTile(
          title: Text.rich(
            TextSpan(
              text: "Olá, ",
              style: TextStyles.titleRegular,
              children: [
                TextSpan(
                  text: userName,
                  style: TextStyles.titleBoldBackground,
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                "Chegou a hora de compartilhar novas imagens",
                style: TextStyles.captionShape,
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
