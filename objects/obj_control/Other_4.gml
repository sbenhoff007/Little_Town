// Play music based on Room
switch room {
	case rm_mainTitle: {
		audio_play_sound(snd_seq_good01_BGM,1,1);
		//Enable gestures for Android
		device_mouse_dbclick_enable(false);
		gesture_double_tap_time(0.16);
		
		if os_type = os_android {
			//Show the "Tap to Play" sequence
			var default_text_lay_id = layer_get_id("DefaultText");
			var android_text_lay_id = layer_get_id("AndroidText");
			layer_set_visible(default_text_lay_id, false);
			layer_set_visible(android_text_lay_id, true);
		}
	}; break;
	case rm_gameMain: {
		audio_play_sound(snd_townBGM,1,1);
		audio_play_sound(snd_townAmbience,1,1);
	}; break;
}

// Mark Sequences layer
if (layer_exists("Cutscenes")) {
	curSeqLayer = "Cutscenes";
}
else {
	curSeqLayer = "Instances";
}
