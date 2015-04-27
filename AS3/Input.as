package  {
	
	public class Input {
		
		private var document;
		private var last;

		public function Input(document:main) {
			this.document = document;
		}

		protected function input(input:uint):void {
			var tmp = 0, cube = -1;
			if (input > 0) {
				tmp = ((input + Bug.MOVES - 1) % Bug.MOVES) + 1;
				cube = (input - tmp) / 3;
				
				if (cube == last) {
					document.input(0);
				}
			}
			
			document.input(tmp);
			last = cube;
		}
	}
	
}
