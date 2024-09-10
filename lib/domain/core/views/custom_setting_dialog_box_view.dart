import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../infrastructure/dal/daos/session_management.dart';
import '../../../infrastructure/dal/services/localization_service.dart';
import '../../../infrastructure/theme/app_themes.dart';

class CustomSettingDialogBoxView extends GetView {
  CustomSettingDialogBoxView({super.key});

  final RxBool isDarkMode = false.obs;
  final RxString language = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'setting'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const SizedBox();
                  } else if (snapshot.hasData) {
                    isDarkMode.value = snapshot.data as bool;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('darkMode'.tr),
                        Obx(() {
                          return Switch.adaptive(
                            value: isDarkMode.value,
                            onChanged: (bool value) {
                              isDarkMode.toggle();
                            },
                          );
                        }),
                      ],
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: SessionManagement.isDarkMode(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('language'.tr),
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const SizedBox();
                      } else if (snapshot.hasData) {
                        language.value = snapshot.data as String;
                        return PopupMenuButton<String>(
                            child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                    width: 1.0, // Outline width
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 8, top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Obx(() {
                                        return Text(
                                          language.value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 12,
                                              ),
                                        );
                                      }),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )),
                            onSelected: (value) {
                              language.value = value;
                              // Handle status change
                            },
                            itemBuilder: (context) =>
                                LocalizationService.langs.map((section) {
                                  return PopupMenuItem<String>(
                                    value: section,
                                    child: Text(section),
                                  );
                                }).toList());
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  future: SessionManagement.getLanguage(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8), // Padding
                  ),
                  onPressed: () {
                    SessionManagement.setSettings(
                        language: language.value, isDarkMode: isDarkMode.value);
                    LocalizationService()
                        .changeLocale(language.value); // Change language
                    Get.changeTheme(isDarkMode.value
                        ? AppThemes.dark(context)
                        : AppThemes.light(context));
                    Get.back();
                  },
                  child: const Text("Confirm"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
