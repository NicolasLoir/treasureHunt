import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp6_carte_aux_tresors/modeles/endroit.dart';

const String reqCreerTableEndroits =
    'CREATE TABLE endroits (idEndroit INTEGER PRIMARY KEY, designation TEXT, ' +
        'latitude DOUBLE, longitude DOUBLE, image TEXT, indication TEXT)';

class GestionBdD {
  static const int numVersion = 2;
  static late Database bdd;

  static Future creationBD() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tresors.db');
    await deleteDatabase(path);

    print("suppression puis creation bd");

    bdd = await openDatabase(path, version: numVersion,
        onCreate: (Database db, int version) async {
      await db.execute("DROP TABLE IF EXISTS endroits");
      await db.execute(reqCreerTableEndroits);
    });

    return bdd;
  }

  static Future<Database> ouvrirBdD() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tresors.db');

    bdd = await openDatabase(path, version: numVersion);

    return bdd;
  }

  static const String reqCreerEndroit1 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (1, 'Couloir logement', 43.69886692874461, 7.2773409633178785, '', 'Aller dans le coulour' )";
  static const String reqCreerEndroit2 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (2, 'Rue logement', 43.698933830611864, 7.277135774334417, '', 'Aller dans la rue'  )";
  static const String reqCreerEndroit3 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (3, '', 43.69655715019139, 7.276774873311901, '', 'Heureux mélange de l embleme de Nice et de ta gourmandise: direction l ouverture des papilles'  )";
  static const String reqCreerEndroit4 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (4, '', 43.69640417566095, 7.276581754351302, '', 'Après avoir assouvi un des 7 péchés capitaux va te repentir'  )";
  static const String reqCreerEndroit5 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (5, '', 43.69603316292604, 7.275299299852371, '', 'Il te faudra suivre les bruits animés de la ville. Achète cette fleur: rouge elle sera et ne te pique pas les doigts'  )";
  static const String reqCreerEndroit6 =
      "INSERT INTO endroits (idEndroit, designation, latitude, longitude, image, indication) " +
          "VALUES (6, '', 43.696531971327914, 7.270622859751841, '', 'Il faudra te prendre en photo devant un homme nu, posé sur l eau et dos à la mer'  )";

  static const String reqLireEndroits = "SELECT * FROM endroits";

  static Future chargerEndroits() async {
    final pref = await SharedPreferences.getInstance();
    // final premierConnexion = pref.getInt('premiereConnexion');
    final premierConnexion = null;
    if (premierConnexion == null) {
      //creation de la bd si premier lancement de l'appli
      print("premiere connexion");
      bdd = await creationBD();

      await bdd.execute(reqCreerEndroit1);
      await bdd.execute(reqCreerEndroit2);
      await bdd.execute(reqCreerEndroit3);
      await bdd.execute(reqCreerEndroit4);
      await bdd.execute(reqCreerEndroit5);
      await bdd.execute(reqCreerEndroit6);

      List endroits = await bdd.rawQuery(reqLireEndroits);
      // print(endroits[0].toString());
      // print(endroits[1].toString());
      // print(endroits[2].toString());
      // print(endroits[3].toString());
      // print(endroits[4].toString());
      // print(endroits[5].toString());

      bdd.close();

      //initialiser sharedPref pour empecher de recreer la BD
      await pref.setInt('premiereConnexion', 1);
      await pref.setInt('nombreMarker', 1);
    } else {
      print("Deuxieme lancement de l'appli ou plus");
    }
  }

  static Future<List<Endroit>> lireEndroits() async {
    bdd = await ouvrirBdD();

    List<Endroit> endroits = [];
    final List<Map<String, dynamic>> maps = await bdd.query('endroits');

    endroits = List.generate(maps.length, (i) {
      return Endroit(
        maps[i]['idEndroit'],
        maps[i]['designation'],
        maps[i]['latitude'],
        maps[i]['longitude'],
        maps[i]['image'],
        maps[i]['indication'],
      );
    });

    bdd.close();
    return endroits;
  }

  static Future<List<Endroit>> lireEndroitsMap() async {
    List<Endroit> endroits = await lireEndroits();
    final pref = await SharedPreferences.getInstance();
    int nbMarker = pref.getInt('nombreMarker')!.toInt();

    endroits.removeRange(nbMarker - 1, endroits.length);

    return endroits;
  }

  static Future<List<Endroit>> lireEndroitsGererEndroit() async {
    List<Endroit> endroits = await lireEndroits();
    final pref = await SharedPreferences.getInstance();
    int nbMarker = pref.getInt('nombreMarker')!.toInt();

    endroits.removeRange(nbMarker, endroits.length);

    return endroits;
  }

  static Future<int> insererEndroit(Endroit endroit) async {
    bdd = await ouvrirBdD();
    int id = await bdd.insert('endroits', endroit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    bdd.close();
    return (id);
  }

  static Future detruireEndroit(Endroit endroit) async {
    bdd = await ouvrirBdD();
    int resultat = await bdd.delete(
      'endroits',
      where: 'idEndroit = ?',
      whereArgs: [endroit.id],
    );
    bdd.close();
    return resultat;
  }
}
