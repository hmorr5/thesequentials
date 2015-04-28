package {
	
	import com.frigidfish.Grid;
	
	public class Grid extends com.frigidfish.Grid {

		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;

		public var dx:uint;
		public var dy:uint;
		
		private var goal;
		private var goalX:uint;
		private var goalY:uint;
		
		public function Grid(rows, cols, goalX = 6, goalY = 6) {
			this.goalX = goalX;
			this.goalY = goalY;
			this.dx = 0;
			this.dy = 0;
			
			super(Token, rows, cols, 0);
			
			if (rows > 0 && cols > 0) {
				this.dx = this.cell[0].width + 1; // +1 for the border
				this.dy = this.cell[0].height + 1;
			}
			
			goal = new diamond;
			goal.x = x + (goalX + 0.5) * dx;
			goal.y = y + (goalY + 0.5) * dy;
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