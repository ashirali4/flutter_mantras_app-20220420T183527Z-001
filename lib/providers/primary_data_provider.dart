import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/model/affirmation.dart';
import 'package:flutter_mantras_app/utils/network.dart';
import 'package:flutter_mantras_app/utils/shared_pref.dart';
import 'package:flutter_mantras_app/utils/snackbar.dart';

class ProviderDataProvider extends ChangeNotifier {

  bool isLoading = false;
  List<Affirmation> affList = [];

  List<String> favouriteList = [];

  /// get data from the db
  getData(BuildContext context) async {
    isLoading = true;
    bool network = await NetworkHelper.checkNetwork();
    if (network) {
      final dbRef = FirebaseDatabase.instance.ref().child("affirmation");
      DatabaseEvent event = await dbRef.once();

      for (var value in event.snapshot.children) {
        Affirmation aff = Affirmation.fromSnapshot(value.value);
        affList.add(aff);
      }
    } else {
      SnackBarMessage.show(context: context, message: "Please check your connection!");
    }
    isLoading = false;
    notifyListeners();
  }

  /// get favourite data
  getFav() async {
    favouriteList = await getFavourites();
    notifyListeners();
  }

  /// save favourites
  saveFav() async {
    saveFavourites(favouriteList).whenComplete(() => getFav());
  }

}
