import 'package:flutter/material.dart';
import 'package:tp6_carte_aux_tresors/modal/dialogue_endroit.dart';
import 'package:tp6_carte_aux_tresors/modeles/endroit.dart';
import 'package:tp6_carte_aux_tresors/utilitaires/gestion_bdd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GererEndroits extends StatelessWidget {
  const GererEndroits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var listEndroit = ListeEndroits();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des lieux'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              final nbMarker = pref.getInt('nombreMarker');
              if (nbMarker!.toInt() > 1) {
                await pref.setInt('nombreMarker', nbMarker.toInt() - 1);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListeEndroits(),
    );
  }
}

class ListeEndroits extends StatefulWidget {
  @override
  _ListeEndroitsState createState() => _ListeEndroitsState();
}

class _ListeEndroitsState extends State<ListeEndroits> {
  late List<Endroit> _endroits;

  _fetchListEndroits() async {
    _endroits = await GestionBdD.lireEndroitsGererEndroit();
    return _endroits;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchListEndroits(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: _endroits.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: const Color.fromRGBO(232, 232, 232, 1),
                    child: ListTile(
                      title: Text(_endroits[index].designation),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          DialogueEndroit dialogue =
                              DialogueEndroit(_endroits[index], false);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                dialogue.construireDialogue(context),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  );
                });
          }
        });
  }
}
