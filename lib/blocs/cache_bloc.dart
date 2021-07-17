import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CacheBloc {
  SharedPreferences? _preferences;
  final BehaviorSubject<String> _uidController = BehaviorSubject();  //to hold data

  _CacheBloc() {  //we use init method since constructor wont accept async
    _init();
  }
  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? get currentUid => _uidController.hasValue ? _uidController.value: null;

  Future<void> loadData(String uid) async {
    if (_preferences == null) await _init();
    _uidController.sink.add(uid);
    _preferences!.setString(UID_KEY, uid);
  }

  Future<void> setup() async {
    if (_preferences == null) await _init();

    final value = _preferences!.getString(UID_KEY);
    if (value != null) {
      loadData(value);
    }
  }

  void close() {
    _uidController.close();
  }
}

final cache = _CacheBloc();
const UID_KEY = "uid_key";
