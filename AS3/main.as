package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		static const EASY:uint = 0;
		static const INTERMEDIATE:uint = 1;
		static const ADVANCED:uint = 2;
		
		var mode:uint;
		
		// maps keycodes to bug movements
		private var codeMap:Dictionary;
		
		// handles the input and calls
		var fiducial:FiducialInput;
		
		// basic display objects
		var mainMenu:menu;
		var gameGrid:Grid;
		var character:Bug;
		var checkList;
		
		// intermediate/advanced mode
		var moves:Array;
		var moveDisplayArray:Array;
		var moveList;
		var forwardArrow;
		var turnRight;
		var turnLeft;
		var goButton;
		var goButtonGreen;
		
		// delays movement of bug in intermediate/advanced mode
		var movementDelay:Timer;
		var block_KEY_DOWN:Boolean = false;
		
		public function main() {
			codeMap = new Dictionary();
			codeMap[37] = Bug.TURNLEFT;
			codeMap[38] = Bug.FORWARD;
			codeMap[39] = Bug.TURNRIGHT;
			codeMap[40] = Bug.UNDO;
			
			fiducial = new FiducialInput(this);
			
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			gameGrid = new Grid(8,8,0);
			gameGrid.x = 400;
			gameGrid.y = 50;
			
			character = new Bug(gameGrid);
			character.gotoAndStop(1);
			
			checkList = new mockList;
			checkList.x = 1350;
			checkList.y = 50;
			
			mode = EASY;
		}
		
		private function setupEasyMode() {
			addChild(gameGrid);
			addChild(character);
			addChild(checkList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {   
				if (!block_KEY_DOWN && e.keyCode in codeMap) {
					input(codeMap[e.keyCode]);
				} else if (block_KEY_DOWN) { trace("blocked " + e.keyCode);
				} else trace("keycode " + e.keyCode + " is not in the map");
			});
			
			mode = EASY;
		}
		
		private function setupIntermediateMode() {
			setupAdvancedMode();
			
			// TODO: setup ghost
			
			mode = INTERMEDIATE;
		}
		
		private function setupAdvancedMode() {
			setupEasyMode();
			
			moves = [];
			moveDisplayArray = [];
			
			moveList = new inputText;
			moveList.x = 200;
			moveList.y = 150;
			
			forwardArrow = new goForwardArrow;
			turnRight = new turnRightArrow;
			turnLeft = new turnLeftArrow;
			
			goButton = new goText;
			goButton.x = 200;
			goButton.y = 900;
			
			goButtonGreen = new goTextGreen;
			goButtonGreen.x = goButton.x;
			goButtonGreen.y = goButton.y;
			
			addChild(moveList);
			
			updateGoButton();
			
			movementDelay = new Timer(1000, 4);
			
			goButtonGreen.addEventListener(MouseEvent.CLICK, function(Event:MouseEvent):void {
				if (moves.length == 4) {
					movementDelay.start();
					block_KEY_DOWN = true;
				}
			});
			movementDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent = null):void {
				character.move(moves[0]);
				moves.shift();
			});
			movementDelay.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				movementDelay.reset();
				block_KEY_DOWN = false;
				
				// remove the display arrows
				for (var i=0; i< moveDisplayArray.length; i++) {
					removeChild(moveDisplayArray[i]);
				}
				
				moveDisplayArray = [];
			});
			
			mode = ADVANCED;
		}
		
		/**
		 * Start the game in easy mode: bug moves in real time.
		 */
		public function startEasyMode() {
			setupEasyMode();
		}
		
		/**
		 * Start the game in intermediate mode: bug moves every 4 inputs and has a ghost.
		 */
		public function startIntermediateMode() {
			setupIntermediateMode();
		}
		
		/**
		 * Start the game in advanced mode: bug moves every 4 inputs.
		 */
		public function startAdvancedMode() {
			setupAdvancedMode();
		}
		
		/**
		 * Process input depending on the selected mode:
		 *  - EASY (real time)
		 *  - INTERMEDIATE / ADVANCED (store in moves array and show symbol)
		 *  - 
		 */
		public function input(input:uint):void {
			if (mode == EASY) {
				character.move(input);
			} else { // intermediate/advanced mode
				if (input == Bug.UNDO) {
					moves.splice(-1, 1);
					var tmp = moveDisplayArray.splice(-1, 1);
					removeChild(tmp[0]);
				} else if (moves.length < 4) {
					moves.push(input);
					
					switch (input) {
						case Bug.FORWARD:
							forwardArrow = new goForwardArrow();
							forwardArrow.y = (300 + 125*(moves.length - 1));
							forwardArrow.x = 200;
							moveDisplayArray.push(forwardArrow);
							addChild(forwardArrow);
							break;
						case Bug.TURNLEFT:
							turnLeft = new turnLeftArrow();
							turnLeft.y = (300 + 125*(moves.length - 1));
							turnLeft.x = 200;
							moveDisplayArray.push(turnLeft);
							addChild(turnLeft);
							break;
						case Bug.TURNRIGHT:
							turnRight = new turnRightArrow();
							turnRight.y = (300 + 125*(moves.length - 1));
							turnRight.x = 200;
							moveDisplayArray.push(turnRight);
							addChild(turnRight);
					}
				}
				
				updateGoButton();
			}
		}
		
		// toggle between grey/green GoButton
		private function updateGoButton() {
			if (moves.length < 4) {
				if (goButtonGreen.stage) {
					removeChild(goButtonGreen);
				}
				addChild(goButton);
			} else {
				if (goButton.stage) {
					removeChild(goButton);
				}
				addChild(goButtonGreen);
			}
		}
	}
}