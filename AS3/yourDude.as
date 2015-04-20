package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	public class yourDude extends MovieClip{
		
		var document:main;

		public function yourDude(x, y, d:main) {
			this.document = d;

	 	 	this.x = x;
	 	 	this.y = y;
	 	 }
		 
		public function setX(x) {
			 this.x = x;
		}
		 
		public function getX() {
			 return this.x;
		}
		 
		public function setY(y) {
			 this.y = y;
		}
		 
		public function getY() {
			 return this.y;
		}

		public function addX(dx) {
			if (document.gameGrid.x < this.x + dx && this.x + dx < document.gameGrid.x + document.gameGrid.cols * document.gameGrid.dx)
				this.x += dx;
		}
		
		public function addY(dy) {
			if (document.gameGrid.y < this.y + dy && this.y + dy < document.gameGrid.y + document.gameGrid.rows * document.gameGrid.dy){
				this.y += dy;
			}
		}
		
		/**
		 * @param direction 0: East, 1: South, 2: West, 3: North
		 */
		public function move(direction):void {
			var dx:int, dy:int;
			
			// calculate offsets for x and y
			dx = -1 * ((direction - 1) % 2); // 0: 1, 1: 0, 2: -1, 3: 0
			dy = -1 * ((direction - 2) % 2); // 0: 0, 1: 1, 2: 0, 3: -1
			
			addX(dx * document.gameGrid.dx);
			addY(dy * document.gameGrid.dy);
			
			/*
			if (playerDirection == 0 && character.x < 1271) {
				//move east
				character.setX(character.getX() + speed);
			} else if (playerDirection == 1 && character.y < 921) {
				//move south
				character.setY(character.getY() + speed);
			} else if (playerDirection == 2 && character.x > 480) {
				//move west
				character.setX(character.getX() - speed);
			} else if (playerDirection == 3  && character.y > 130) {
				//move north
				character.setY(character.getY() - speed);
			}
			*/
		}
	}
}
