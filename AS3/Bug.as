package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	public class Bug extends MovieClip{
		
		var grid:Grid;

		public function Bug(x:uint, y:uint, grid:Grid) {
	 	 	this.x = grid.x + (x + 0.5) * grid.dx;
	 	 	this.y = grid.y + (y + 0.5) * grid.dy;
			trace(this.x + ", " + this.y);
			this.grid = grid;
		}

		public function addX(dx) {
			if (grid.x < this.x + dx && this.x + dx < grid.x + grid.cols * grid.dx)
				this.x += dx;
		}
		
		public function addY(dy) {
			trace("grid.y < this.y + dy: " + grid.y + " < " + (this.y + dy));
			trace("this.y + dy < grid.y + grid.rows * grid.dy: " + (this.y + dy) + " < " + (grid.y + grid.rows * grid.dy));
			if (grid.y < this.y + dy && this.y + dy < grid.y + grid.rows * grid.dy){
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
			
			addX(dx * grid.dx);
			addY(dy * grid.dy);
			
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
