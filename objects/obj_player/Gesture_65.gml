if (global.playerControl == true) {
	x_goto = event_data[?"posX"];
	y_goto = event_data[?"posY"];

	if x_goto > x {
		// Player is moving to the right
		moveRight = 1;
		moveLeft = 0;
	} else {
		// Player is moving to the left
		moveLeft = 1;
		moveRight = 0;
	}	
}