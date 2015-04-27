package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		static const EASY:uint = 0;
		static const INTERMEDIATE:uint = 1;
		static const ADVANCED:uint = 2;
		
		static const CUBES:uint = 3;
		
		var mode:uint;
		var block_KEY_DOWN:Boolean;
		
		// maps keycodes to bug movements
		private var codeMap:Dictionary;
		
		// handles the input and calls
		var fiducial:FiducialInput;
		var keyboard:KeyboardInput;
		
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
		
		public function main() {
			codeMap = new Dictionary();
			codeMap[37] = Bug.TURNLEFT;
			codeMap[38] = Bug.FORWARD;
			codeMap[39] = Bug.TURNRIGHT;
			codeMap[40] = Bug.UNDO;
			
			fiducial = new FiducialInput(this);
			keyboard = new KeyboardInput(this);
			
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			gameGrid = new Grid(8,8);
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
			
			block_KEY_DOWN = false;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (!block_KEY_DOWN && e.keyCode in codeMap) {
					input(codeMap[e.keyCode]);
				}
			});
			
			mode = EASY;
		}
		
		private function setupIntermediateMode() {
			setupAdvancedMode();
			
			var ghostDelay:Timer = new Timer(15000);
			ghostDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent = null):void {
				if (moves.length > 0) {
					var tmpMoves:Array = moves.slice(); // shallow copy, works for non-object arrays
					
					var ghost:Bug = new Bug(gameGrid, character.posX, character.posY, character.direction, 0.25);
					ghost.gotoAndStop(1);
					addChild(ghost);
					
					var ghostTick = new Timer(500, 2 * tmpMoves.length);
					ghostTick.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
						if (block_KEY_DOWN) {
							ghostTick.stop();
							removeChild(ghost);
						}
						var count:int = ghostTick.currentCount - 1;
						if (count < tmpMoves.length) {
							ghost.move(tmpMoves[count]);
						} else if (count > tmpMoves.length){
							ghost.reverse(tmpMoves[2 * tmpMoves.length - count]);
						}
					});
					ghostTick.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
						removeChild(ghost);
					});
					ghostTick.start();
				}
			});
			ghostDelay.start();
			
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
			movementDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
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
		 *  - INTERMEDIATE / ADVANCED (work in moves array and show arrows in moveDisplayArray)
		 */
		public function input(input:uint):void {
			if (mode == EASY) {
				character.move(input);
			} else { // intermediate/advanced mode
				if (input == Bug.UNDO) {
					if (moves.length > 0) {
						moves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
					}
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
		
		/**
		 * Toggles between grey/green GoButton.
		 */
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