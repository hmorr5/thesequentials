package  {
	
	import com.frigidfish.Grid;
	
	public class Grid extends com.frigidfish.Grid {

		public var dx:uint;
		public var dy:uint;
		
		public function Grid(rows, cols, spacer) {
			this.dx = 0;
			this.dy = 0;
			
			super(Token, rows, cols, spacer);
			
			if (rows > 0 && cols > 0) {
				this.dx = this.cell[0].width + 1; // +1 for the border
				this.dy = this.cell[0].height + 1;
			}
		}

	}
	
}
