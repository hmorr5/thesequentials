package {
	import flash.display.MovieClip;
	
	public class Grid extends MovieClip {

		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;

		public static const DX:uint = 112;
		public static const DY:uint = 112;
		
		public var rows;
		public var cols;
		
		private var goal;
		private var goalX:uint;
		private var goalY:uint;
		
		public function Grid(rows, cols, goalX = 7, goalY = 7) {
			this.goalX = goalX;
			this.goalY = goalY;
			this.rows = rows;
			this.cols = cols;
			
			goal = new diamond;
			goal.x = x + (goalX + 0.5) * DX;
			goal.y = y + (goalY + 0.5) * DY;
			addChild(goal);
		}
		
		public function isAccessible(posX:uint, posY:uint, fromDirection:uint):Boolean {
			return (0 <= posX && posX < this.cols && 0 <= posY && posY < this.rows);
		}
		
		public function isGoal(posX:uint, posY:uint):Boolean {
			return (posX == goalX && posY == goalY);
		}
	}
}