import 'package:dio/dio.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:flutter/material.dart';
export 'package:flutter/material.dart';
export 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';

import '../../../../../utils/config/app_navigation.dart';

class BaseHelper {
  static void showCustomDialog(Widget child) {
    showGeneralDialog(
      context: Get.context!,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return child;
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }

  static String mapWordType(String wordType) {
    print(wordType);
    switch (wordType) {
      case 'FW':
      case 'NN':
      case 'NNS':
      case 'NNP':
      case 'NNPS':
        return 'Noun';
      case 'PRP':
      case 'PRP\$':
        return 'Pronoun';
      case 'JJ':
      case 'JJR':
      case 'JJS':
        return 'Adjective';
      case 'VB':
      case 'VBG':
      case 'VBD':
      case 'VBN':
      case 'VBP':
      case 'VBZ':
        return 'Verb';
      case 'RB':
      case 'RBR':
      case 'RBS':
        return 'Adverb';
      case 'EX':
      case 'DT':
      case 'PDT':
      case 'POS':
        return 'Determiner';
      case 'IN':
      case 'RP':
      case 'TO':
        return 'Preposition';
      case 'CC':
      case 'CD':
        return 'Conjunction';
      case 'UH':
        return 'Interjection';
      case 'MD':
        return 'Auxiliary';
      default:
        return 'Noun';
    }
  }

  static void tokenError(DioError error) {
    if (error.response!.statusCode == 401) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: "Không thể xác thực",
        desc: "Phiên đăng nhập của bạn đã hết hạn, đăng nhập lại để tiếp tục sử dụng",
        descTextStyle: AppTextStyle.w600s17(ColorName.black000),
        btnOkText: 'Okay',
        btnOkOnPress: () {},
        onDismissCallback: (_) {
          AppConfig.accountInfo = AccountModel();
          N.toLandingPage();
          N.toLoginPage();
        },
      ).show();
    }
  }

  static List<Vocabulary> selectWordToLearn(List<Vocabulary> vocabularies, {bool isReview = false}) {
    List<Vocabulary> listVocabulary = [];
    List<Vocabulary> listVocabularyNew = vocabularies.where((vocabulary) => vocabulary.progress == 0).toList();
    List<Vocabulary> listVocabularyLearned = vocabularies.where((vocabulary) => vocabulary.progress > 0).toList();
    if (isReview || listVocabularyNew.isEmpty) {
      // print("================================");
      // print(totalWordDifficult(vocabularies));
      // print(totalWordNeedReview(vocabularies));
      // print("================================");

      List<Vocabulary> listVocabularyOld = vocabularies
          .where(
            (vocabulary) =>
                int.parse(vocabulary.lastTimeLearning) <
                    (DateTime.now().toUtc().millisecondsSinceEpoch) - (3 * 3600000) &&
                vocabulary.progress > 0,
          )
          .toList();

      List<Vocabulary> listVocabularyRecent = vocabularies
          .where(
            (vocabulary) =>
                int.parse(vocabulary.lastTimeLearning) >=
                    (DateTime.now().toUtc().millisecondsSinceEpoch) - (3 * 3600000) &&
                vocabulary.progress > 0,
          )
          .toList();

      listVocabularyOld.sort((a, b) => a.lastTimeLearning.compareTo(b.lastTimeLearning));

      if (listVocabularyOld.length >= 5) {
        listVocabulary.addAll(listVocabularyOld.sublist(0, 5));
      } else {
        listVocabulary.addAll(listVocabularyOld);
        listVocabularyRecent.sort((a, b) => a.progress.compareTo(b.progress));

        if (listVocabularyRecent.length >= 5 - listVocabulary.length) {
          listVocabulary.addAll(listVocabularyRecent.sublist(0, 5 - listVocabulary.length));
        } else {
          listVocabulary.addAll(listVocabularyRecent);
        }
      }
    } else {
      if (listVocabularyNew.length >= 3 && listVocabularyLearned.isEmpty) {
        listVocabulary.addAll(listVocabularyNew.sublist(0, 3));
      } else if (listVocabularyNew.length >= 2) {
        listVocabulary.addAll(listVocabularyNew.sublist(0, 2));
      } else if (listVocabularyNew.length == 1) {
        listVocabulary.addAll(listVocabularyNew.sublist(0, 1));
      }

      listVocabularyLearned.sort((a, b) => a.progress.compareTo(b.progress));

      if (listVocabularyLearned.length >= 5 - listVocabulary.length) {
        listVocabulary.addAll(listVocabularyLearned.sublist(0, 5 - listVocabulary.length));
      } else {
        listVocabulary.addAll(listVocabularyLearned);
      }
    }

    return listVocabulary;
  }

  static bool isHasNewWords(List<Vocabulary> vocabularies) {
    return vocabularies.where((vocabulary) => vocabulary.progress == 0).toList().isNotEmpty;
  }

  static int totalWordNeedReview(List<Vocabulary> vocabularies) {
    return vocabularies
        .where(
          (vocabulary) =>
              int.parse(vocabulary.lastTimeLearning) <
                  (DateTime.now().toUtc().millisecondsSinceEpoch) - (3 * 3600000) &&
              vocabulary.progress > 0,
        )
        .toList()
        .length;
  }

  static int totalWordDifficult(List<Vocabulary> vocabularies) {
    return vocabularies.where((vocabulary) => vocabulary.difficult > 0).toList().length;
  }

  static List<Vocabulary> allWordDifficult(List<Vocabulary> vocabularies) {
    return vocabularies.where((vocabulary) => vocabulary.difficult > 0).toList();
  }
}
