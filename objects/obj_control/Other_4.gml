// Play music based on Room
switch room {
	case rm_mainTitle: {
		audio_play_sound(snd_seq_good01_BGM,1,1);
		//Enable gestures for Android
		device_mouse_dbclick_enable(false);
		gesture_double_tap_time(0.16);
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
