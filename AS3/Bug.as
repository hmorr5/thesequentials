package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import com.greensock.TweenMax;
	
	public class Bug extends MovieClip{
		
		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;
		
		public static const UNDO:uint = 0;
		public static const FORWARD:uint = 1;
		public static const TURNLEFT:uint = 2;
		public static const TURNRIGHT:uint = 3;
		
		var grid:Grid;
		var direction:int;
		
		// for smooth rotation
		private var angle:int;
		
		public function Bug(grid:Grid, x:uint = 0, y:uint = 0, direction:uint = EAST) {
	 	 	this.x = grid.x + (x + 0.5) * grid.dx;
	 	 	this.y = grid.y + (y + 0.5) * grid.dy;

			this.direction = direction;
			this.angle = 90 * direction;
			this.grid = grid;
		}

		public function addX(dx) {
			if (grid.x < this.x + dx && this.x + dx < grid.x + grid.cols * grid.dx)
				this.x += dx;
		}
		
		public function addY(dy) {
			if (grid.y < this.y + dy && this.y + dy < grid.y + grid.rows * grid.dy){
				this.y += dy;
			}
		}
		
		public function move(action:uint):void {
			switch (action) {
				case UNDO:
					undo();
					break;
				case FORWARD:
					forward();
					break;
				case TURNLEFT:
					turnLeft();
					break;
				case TURNRIGHT:
					turnRight();
					break;
				default:
			}
		}
		
		public function undo():void {
			// TODO: implement undo for real-time mode
		}
		
		public function forward():void {
			var dx:int, dy:int;
			
			// calculate offsets for x and y
			dx = -1 * ((direction - 1) % 2); // 0: 1, 1: 0, 2: -1, 3: 0
			dy = -1 * ((direction - 2) % 2); // 0: 0, 1: 1, 2: 0, 3: -1
			
			addX(dx * grid.dx);
			addY(dy * grid.dy);
		}
		
		public function turnLeft():void {
			direction = (direction + 3) % 4;
			TweenMax.to(this, 1, {
				shortRotation: {
					rotation: angle -= 90
				}
			});
			angle %= 360;
		}
		
		public function turnRight():void {
			direction = (direction + 1) % 4;
			TweenMax.to(this, 1, {
				shortRotation: {
					rotation: angle += 90
				}
			});
			angle %= 360;
		}
	}
}
