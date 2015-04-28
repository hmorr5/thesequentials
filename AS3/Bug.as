package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import com.greensock.TweenMax;
	
	public class Bug extends MovieClip{
		
		public static const MOVES:uint = 3;
		
		public static const UNDO:uint = 0;
		public static const FORWARD:uint = 1;
		public static const TURNLEFT:uint = 2;
		public static const TURNRIGHT:uint = 3;
		
		private var document:main;
		
		public var posX:uint;
		public var posY:uint;
		
		var grid:Grid;
		var direction:int;
		
		// for smooth rotation
		private var angle:int;
		
		// store the last performed action for undo()
		private var last:uint;
		
		private var message;
		
		/**
		 * Adds a new bug to the grid and positions it correctly.
		 * 
		 * @param direction Uses the directions Grid.EAST, Grid.SOUTH, Grid.WEST and Grid.NORTH.
		 * @param alpha Controls the transparency of the bug.
		 */
		public function Bug(document:main, grid:Grid, posX:uint = 0, posY:uint = 0, direction:uint = 0, alpha:Number = 1.0) {
			this.document = document;
			
			this.posX = posX;
			this.posY = posY;

			this.direction = direction;
			this.angle = 0;
			if (direction != 0) {
			TweenMax.to(this, 0, {
				shortRotation: {
					rotation: angle = 90 * direction
				}
			});
			}
			
			this.alpha = alpha;
			
			this.last = UNDO;
			
			this.grid = grid;
			
			this.message = new dialog;
			message.x = 940;
			message.y = 500;
			message.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				document.allowInput();
				document.removeChild(message);
			});
			
			updatePosition(false);
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
		
		public function reverse(action:uint):void {
			switch (action) {
				case FORWARD:
					direction = (direction + 2) % 4;
					forward();
					direction = (direction + 2) % 4;
					break;
				case TURNLEFT:
					turnRight();
					break;
				case TURNRIGHT:
					turnLeft();
					break;
				default:
			}
		}
		
		public function undo():void {
			reverse(last);
			last = UNDO;
		}
		
		public function forward():void {
			var dx:int, dy:int;
			
			// calculate offsets for x and y
			dx = -1 * ((direction - 1) % 2); // 0: 1, 1: 0, 2: -1, 3: 0
			dy = -1 * ((direction - 2) % 2); // 0: 0, 1: 1, 2: 0, 3: -1
			
			if (grid.isAccessible(posX + dx, posY + dy, direction)){
				this.posX += dx;
				this.posY += dy;
			
				last = FORWARD;
			} else {
				last = UNDO;
			}
			
			if (grid.isGoal(posX, posY)) {
				document.addChild(message);
				document.blockInput();
			}
			
			updatePosition();
		}
		
		public function turnLeft():void {
			direction = (direction + 3) % 4;
			TweenMax.to(this, 1, {
				shortRotation: {
					rotation: angle -= 90
				}
			});
			angle %= 360;
			
			last = TURNLEFT;
		}
		
		public function turnRight():void {
			direction = (direction + 1) % 4;
			TweenMax.to(this, 1, {
				shortRotation: {
					rotation: angle += 90
				}
			});
			angle %= 360;
			
			last = TURNRIGHT;
		}
		
		public function updatePosition(animate:Boolean = true):void {
			if (animate) {
				TweenMax.to(this, 1, {x: grid.x + (posX + 0.5) * grid.dx});
				TweenMax.to(this, 1, {y: grid.y + (posY + 0.5) * grid.dy});
			} else {
				this.x = grid.x + (posX + 0.5) * grid.dx;
				this.y = grid.y + (posY + 0.5) * grid.dy;
			}
		}
	}
}
