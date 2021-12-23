import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  @observable
  var videoEnabled = true;

  @observable
  var overlayEnabled = true;

  @observable
  var messageLimit = 200.0;

  @observable
  var hideBannedMessages = false;

  @observable
  var zeroWidthEnabled = false;

  Future<void> init() async {
    // Retrieve the instance that will allow us to store and persist settings.
    final prefs = await SharedPreferences.getInstance();

    // Initialize settings from stored preferences if any.
    videoEnabled = prefs.getBool('video_enabled') ?? videoEnabled;
    overlayEnabled = prefs.getBool('overlay_enabled') ?? overlayEnabled;
    messageLimit = prefs.getDouble('message_limit') ?? messageLimit;
    hideBannedMessages = prefs.getBool('hide_banned_messages') ?? hideBannedMessages;
    zeroWidthEnabled = prefs.getBool('zero_width_enabled') ?? zeroWidthEnabled;

    // Set up reactions to store setting anytime they're changed.
    // The ReactionDisposer will not be needed since settings will always exist.
    reaction((_) => messageLimit, (double newValue) => prefs.setDouble('message_limit', newValue));
    reaction((_) => videoEnabled, (bool newValue) => prefs.setBool('video_enabled', newValue));
    reaction((_) => overlayEnabled, (bool newValue) => prefs.setBool('overlay_enabled', newValue));
    reaction((_) => zeroWidthEnabled, (bool newValue) => prefs.setBool('zero_width_enabled', newValue));
    reaction((_) => hideBannedMessages, (bool newValue) => prefs.setBool('hide_banned_messages', newValue));
  }
}
