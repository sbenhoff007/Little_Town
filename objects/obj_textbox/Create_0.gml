// Textbox variables
textToShow = "Try not. Do or do not. There is no try."
textWidth = 450;
lineHeight = 28;
fadeMe = 0;
fadeSpeed = 0.1;
image_alpha = 0;
global.playerControl = false;
sequenceToShow = noone;

// Dismiss any visible prompts
scr_dismissPrompt(obj_prompt,0);

// Play UI sound
audio_play_sound(snd_pop01,1,0);
