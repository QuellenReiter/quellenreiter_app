import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// This holds all [TextEditingController] to create and edit a [Fact].
class FactController {
  /// [TextEditingController] for [Fact.factText].
  late TextEditingController factController;

  /// [TextEditingController] for [Fact.factYear].
  late TextEditingController yearController;

  /// [TextEditingController] for [Fact.factMonth].
  late TextEditingController monthController;

  /// [TextEditingController] for [Fact.factDay].
  late TextEditingController dayController;

  /// [TextEditingController] for [Fact.factLink].
  late TextEditingController linkController;

  /// [TextEditingController] for [Fact.factArchivedLink].
  late TextEditingController archivedLinkController;

  /// [TextEditingController] for [Fact.factAuthor].
  late TextEditingController authorController;

  /// [TextEditingController] for [Fact.factMedia].
  late TextEditingController mediaController;

  /// [TextEditingController] for [Fact.factLanguage].
  late TextEditingController languageController;

  /// Construct a [FactController] given a [Map] containing all fields of a
  /// [Fact].
  FactController.fromMap(Map<String, dynamic> fact) {
    factController = TextEditingController(text: fact["text"]);
    yearController = TextEditingController(text: fact["year"]);
    monthController = TextEditingController(text: fact["month"]);
    dayController = TextEditingController(text: fact["day"]);
    linkController = TextEditingController(text: fact["factLink"]);
    archivedLinkController =
        TextEditingController(text: fact["factArchivedLink"]);
    authorController = TextEditingController(text: fact["author"]);
    mediaController = TextEditingController(text: fact["medium"]);
  }

  /// Construct a [FactController] given a [Fact].
  FactController(Fact fact) {
    factController = TextEditingController(text: fact.factText);
    factController.addListener(() {
      fact.factText = factController.text;
    });
    yearController = TextEditingController(text: fact.factYear.toString());
    yearController.addListener(() {
      fact.factYear =
          yearController.text == "" ? 0 : int.parse(yearController.text);
    });
    monthController = TextEditingController(text: fact.factMonth.toString());
    monthController.addListener(() {
      fact.factMonth =
          monthController.text == "" ? 0 : int.parse(monthController.text);
    });
    dayController = TextEditingController(text: fact.factDay.toString());
    dayController.addListener(() {
      fact.factDay =
          dayController.text == "" ? 0 : int.parse(dayController.text);
    });
    linkController = TextEditingController(text: fact.factLink);
    linkController.addListener(() {
      fact.factLink = linkController.text;
    });
    archivedLinkController = TextEditingController(text: fact.factArchivedLink);
    archivedLinkController.addListener(() {
      fact.factArchivedLink = archivedLinkController.text;
    });
    authorController = TextEditingController(text: fact.factAuthor);
    authorController.addListener(() {
      fact.factAuthor = authorController.text;
    });
    mediaController = TextEditingController(text: fact.factMedia);
    mediaController.addListener(() {
      fact.factMedia = mediaController.text;
    });
    languageController = TextEditingController(text: fact.factLanguage);
    languageController.addListener(() {
      fact.factLanguage = languageController.text;
    });
  }

  /// Dispose all [TextEditingController] at once.
  void dispose() {
    factController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    linkController.dispose();
    archivedLinkController.dispose();
    authorController.dispose();
    mediaController.dispose();
  }
}

/// A class containing a [List] of [FactController].
class FactControllers {
  /// The [List] of [FactController].
  List<FactController> controllers = [];

  /// Call dispose funktion of all [FactController].
  void dispose() {
    for (FactController c in controllers) {
      c.dispose();
    }
  }

  /// Construct [FactControllers] from [Facts].
  FactControllers(Facts facts) {
    for (Fact fact in facts.facts) {
      controllers.add(FactController(fact));
    }
    //add empty fact controller, if no facts given
    if (facts.facts.isEmpty) {
      controllers.add(FactController(Fact.empty()));
    }
  }
}

/// A class to hold information of a Factcheck.
class Fact {
  /// The summary of the factcheck.
  late String factText;

  /// The year of publication.
  late int factYear;

  /// The month of publication.

  late int factMonth;

  /// The day of publication.

  late int factDay;

  /// The language of the factcheck article.

  late String factLanguage;

  /// The link to the factcheck.

  late String factLink;

  /// An archived version of the link to the factcheck.
  String? factArchivedLink;

  /// The author.
  late String factAuthor;

  /// The media publishing the factcheck.
  late String factMedia;

  /// The ID of the factcheck in the database.
  String? objectId;

  /// Default constructor.
  Fact(
      this.factText,
      this.factAuthor,
      this.factYear,
      this.factMonth,
      this.factDay,
      this.factLanguage,
      this.factLink,
      this.factMedia,
      this.objectId,
      this.factArchivedLink);

  /// Construct a [Fact] from a [Map] containing all fields of the [Fact].
  Fact.fromMap(Map<String, dynamic>? map)
      : factText = map?[DbFields.factText],
        factAuthor = map?[DbFields.factAuthor],
        factMedia = map?[DbFields.factMedia],
        factYear = map?[DbFields.factYear],
        factMonth = map?[DbFields.factMonth],
        factDay = map?[DbFields.factDay],
        factLink = map?[DbFields.factLink],
        factLanguage = map?[DbFields.factLanguage],
        objectId = map?["objectId"],
        factArchivedLink = map?[DbFields.factArchivedLink] ?? "";

  /// Construct an empty [Fact].
  Fact.empty() {
    factText = "";
    factAuthor = "";
    factMedia = "";
    factYear = 0;
    factMonth = 0;
    factDay = 0;
    factLink = "";
    factArchivedLink = "";
    factLanguage = "";
  }

  /// Convert a [Fact] back to its [Map] representation.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> vars = {
      DbFields.factText: factText,
      DbFields.factLanguage: factLanguage,
      DbFields.factYear: factYear,
      DbFields.factMonth: factMonth,
      DbFields.factDay: factDay,
      DbFields.factLink: factLink,
      DbFields.factAuthor: factAuthor,
      DbFields.factArchivedLink: factArchivedLink,
      DbFields.factMedia: factMedia
    };
    return vars;
  }

  /// Return the [Fact.factDay], [Fact.factMonth] and [Fact.factYear] as
  /// [String] like so dd/mm/yyyy.
  ///
  /// If no [Fact.factDay] and/or no [Fact.factMonth] is given, the returned
  /// [String] ommits these fields like so mm/yyyy or yyyy.
  String dateAsString() {
    String ret = "";
    if (factDay != 0) {
      ret += factDay.toString().padLeft(2, "0") + '/';
    }
    if (factMonth != 0) {
      ret += factMonth.toString().padLeft(2, "0") + '/';
    }
    if (factYear != 0) {
      ret += factYear.toString();
    }
    return ret;
  }
}

/// A class containing a [List] of [Fact].
class Facts {
  /// The [List] of [Fact].
  List<Fact> facts = [];

  /// Construct [Facts] from a [Map] containing all fields for a number of
  /// [Fact].
  Facts.fromMap(Map<String, dynamic>? map) {
    for (Map<String, dynamic>? fact in map?["edges"]) {
      facts.add(Fact.fromMap(fact?["node"]));
    }
  }

  /// Construct [Facts] with only one empty [Fact].
  Facts() {
    facts.add(Fact.empty());
  }

  /// Convert the [Facts] back to a [Map] containing all fields.
  List<Map<String, dynamic>> toMap() {
    List<Map<String, dynamic>> ret = [];
    for (var fact in facts) {
      ret.add(fact.toMap());
    }
    return ret;
  }
}
