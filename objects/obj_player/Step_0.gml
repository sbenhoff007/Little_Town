// Check keys for movement
if (global.playerControl == true) {
	moveRight = keyboard_check(vk_right);
	moveUp = keyboard_check(vk_up);
	moveLeft = keyboard_check(vk_left);
	moveDown = keyboard_check(vk_down);
}
if (global.playerControl == false) {
	moveRight = 0;
	moveUp = 0;
	moveLeft = 0;
	moveDown = 0;
}

// Run with Shift key
running = keyboard_check(vk_shift);

// Speed up if running
if (running == true) {
	// Ramp up
	if (runSpeed < runMax) {
		runSpeed += 2;
	}
	// Start creating dust
	if (startDust == 0) {
		alarm[0] = 2;
		startDust = 1;
	}
}
// Slow down if no longer running
if (running == false) {
	// Ramp down
	if (runSpeed > 0) {
		runSpeed -= 1;
	}
	startDust = 0;
}

// Calculate movement
vx = ((moveRight - moveLeft) * (walkSpeed+runSpeed) * (1-carryLimit));
vy = ((moveDown - moveUp) * (walkSpeed+runSpeed) * (1-carryLimit));

// If Idle
if (vx == 0 && vy == 0) {
	// If I'm not picking up or putting down an item
	if (myState != playerState.pickingUp && myState != playerState.puttingDown) {
		// If we don't have an item
		if (hasItem == noone) {
			myState = playerState.idle;
		}
		// If we're carrying an item
		else {
			myState = playerState.carryIdle;
		}
	}
}

//// If Idle
//if (vx == 0 && vy == 0) {
//	myState = playerState.idle;
//}

//// If Idle
//if (vx == 0 && vy == 0) {
//	// Change idle Sprite based on last direction
//	switch dir {
//		case 0: sprite_index = spr_player_idle_right; break;
//		case 1: sprite_index = spr_player_idle_up; break;
//		case 2: sprite_index = spr_player_idle_left; break;
//		case 3: sprite_index = spr_player_idle_down; break;
//	}
//}

// If moving
if (vx != 0 || vy != 0) {
	if !collision_point(x+vx,y,obj_par_environment,true,true) {
		x += vx;
	}
		if !collision_point(x,y+vy,obj_par_environment,true,true) {
		y += vy;
	}

	// Change direction based on movement
	if (vx > 0) {
		dir = 0;
	}
	if (vx < 0) {
		dir = 2;
	}
	if (vy > 0) {
		dir = 3;
	}
	if (vy < 0) {
		dir = 1;
	}
	// Set state
	// If we don't have an item
	if (hasItem == noone) {
		myState = playerState.walking;
	}
	// If we're carrying an item
	else {
		myState = playerState.carrying;
	}


	//// Change walking Sprite based on direction
	//if (vx > 0) {
	//	sprite_index = spr_player_walk_right;
	//	dir = 0;
	//}
	//if (vx < 0) {
	//	sprite_index = spr_player_walk_left;
	//	dir = 2;
	//}
	//if (vy > 0) {
	//	sprite_index = spr_player_walk_down;
	//	dir = 3;
	//}
	//if (vy < 0) {
	//	sprite_index = spr_player_walk_up;
	//	dir = 1;
	//}
	
	// Move audio listener with me
	audio_listener_set_position(0,x,y,0);
}

// Check for collision with NPCs
nearbyNPC = collision_rectangle(x-lookRange,y-lookRange,x+lookRange,y+lookRange,obj_par_npc,false,true);
if nearbyNPC {
	// Play greeting sound
	if (hasGreeted == false) {
		if !(audio_is_playing(snd_greeting01)) {
			audio_play_sound(snd_greeting01,1,0);
			hasGreeted = true;
		}
	}
	// Pop up prompt
	if (npcPrompt == noone || npcPrompt == undefined) {
		npcPrompt = scr_showPrompt(nearbyNPC,nearbyNPC.x,nearbyNPC.y-450);
	}
	show_debug_message("obj_player has found an NPC!");
}
if !nearbyNPC {
	// Reset greeting
	if (hasGreeted == true) {
		hasGreeted = false;
	}
	// Get rid of prompt
	scr_dismissPrompt(npcPrompt,0);
	//show_debug_message("obj_player hasn't found anything");
}

// Check for collision with Items
nearbyItem = collision_rectangle(x-lookRange,y-lookRange,x+lookRange,y+lookRange,obj_par_item,false,false);
if (nearbyItem && !nearbyNPC) {
	// Pop up prompt
	if (itemPrompt == noone || itemPrompt == undefined) {
		show_debug_message("obj_player has found an item!");
		itemPrompt = scr_showPrompt(nearbyItem,nearbyItem.x,nearbyItem.y-300);
	}
}
if (!nearbyItem || nearbyNPC) {
	// Get rid of prompt
	scr_dismissPrompt(itemPrompt,1);
}

// If picking up an item
if (myState == playerState.pickingUp) {
	if (image_index >= image_number-1) {
		myState = playerState.carrying;
		global.playerControl = true;
	}
}

// If putting down an item
if (myState == playerState.puttingDown) {
	// Reset weight
	carryLimit = 0;
	// Reset my state once animation finishes
	if (image_index >= image_number-1) {
		myState = playerState.idle;
		global.playerControl = true;
	}
}

// Auto-choose Sprite based on state and direction
sprite_index = playerSpr[myState][dir];

// Depth sorting
depth =-y;
