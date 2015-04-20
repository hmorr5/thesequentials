package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		//Delays movement of bug on intermediate/advanced levels
		var movementDelay = new Timer(1000, 4);
		
		//Arrays
		var intermediateMoves:Array = [];
		var moveDisplayArray:Array = [];
		
		//These are all vars for symbols (images)
		var checkList;
		var character:Bug;
		var mainMenu:menu;
		var gameGrid:Grid;
		var goButton;
		var goButtonGreen;
		var moveList;
		var forwardArrow;
		var turnRight;
		var turnLeft;
		
		//var for the fiducial input
		var input:FiducialInput;
		
		public function main() {
			input = new FiducialInput();
			
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			checkList = new mockList;
			checkList.x = 1350;
			checkList.y = 50;
			
			goButton = new goText;
			goButton.x = 200;
			goButton.y = 900;
			
			goButtonGreen = new goTextGreen;
			goButtonGreen.x = 200;
			goButtonGreen.y = 900;
			
			moveList = new inputText;
			moveList.x = 200;
			moveList.y = 150;
			
			forwardArrow = new goForwardArrow;
			turnRight = new turnRightArrow;
			turnLeft = new turnLeftArrow;
		}
		
		//Start the game in real time easy mode
		public function startEasyMode() {
			var gameGrid:Grid = new Grid(8,8,0);
			gameGrid.x = 400;
			gameGrid.y = 50;
			addChild(gameGrid);
			
			character = new Bug(gameGrid);
			addChild(character);
			character.gotoAndStop(1);
			
			addChild(checkList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCharacterEasy);
		}
		
		//Start the game in intermediate mode.  Bug moves every 4 inputs.
		public function startIntermediateMode() {
			var gameGrid:Grid = new Grid(8,8,0);
			gameGrid.x = 400;
			gameGrid.y = 50;
			addChild(gameGrid);
			
			character = new Bug(gameGrid);
			addChild(character);
			character.gotoAndStop(1);
			
			addChild(checkList);
			addChild(goButton);
			addChild(moveList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			goButtonGreen.addEventListener(MouseEvent.CLICK, clickGo);
			movementDelay.addEventListener(TimerEvent.TIMER, executeIntermediateMoves);
			movementDelay.addEventListener(TimerEvent.TIMER_COMPLETE, resetTimer);
		}
		
		//Player movement for easy mode; real time movement
		public function moveCharacterEasy(e:KeyboardEvent){
			switch(e.keyCode) {
				case 37:
					character.turnLeft();
					break;
				case 39:
					character.turnRight();
					break;
				case 38:
					character.move();
					break;
				default:
			}
		}
		
		//Player movement for intermediate mode; movement every 4 inputs
		//Also shows the display of moves
		public function pushCharacterIntermediate(e:KeyboardEvent){
			//outer if statement here so that toggleGoButton does not detect anything other than the 4 keys
			//detecting anything other than the 3 keycodes will stuff up the order
			if (e.keyCode == 37 || e.keyCode == 38 || e.keyCode == 39 || e.keyCode == 40) {
				if (intermediateMoves.length < 4) {
					//Player turns left
					if(e.keyCode == 37) {
						intermediateMoves.push("37");
						turnLeft = new turnLeftArrow();
						turnLeft.y = (300 + 125*(intermediateMoves.length - 1));
						turnLeft.x = 200;
						moveDisplayArray.push(turnLeft);
						addChild(turnLeft);
					}
				
					//Player turns right
					else if(e.keyCode == 39) {
						intermediateMoves.push("39");
						turnRight = new turnRightArrow();
						turnRight.y = (300 + 125*(intermediateMoves.length - 1));
						turnRight.x = 200;
						moveDisplayArray.push(turnRight);
						addChild(turnRight);
					}
				
					//player moves up
					else if(e.keyCode == 38) {
						intermediateMoves.push("38");
						forwardArrow = new goForwardArrow();
						forwardArrow.y = (300 + 125*(intermediateMoves.length - 1));
						forwardArrow.x = 200;
						moveDisplayArray.push(forwardArrow);
						addChild(forwardArrow);
					}
				}
				
				if (intermediateMoves.length > 0) {
					//player deletes move
					if(e.keyCode == 40) {
						intermediateMoves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
					} 
				} 
				
				toggleGoButton();
			}
		}
		
		// Execute the moves that have been inputted (intermediate mode)
		public function executeIntermediateMoves(e:TimerEvent=null){
			switch(intermediateMoves[0]) {
				case 37:
					character.turnLeft();
					break;
				case 39:
					character.turnRight();
					break;
				case 38:
					character.move();
					break;
				default:
			}
			intermediateMoves.shift();
		}
		
		public function clickGo(Event:MouseEvent) {
			if (intermediateMoves.length == 4) {
				movementDelay.start();
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			}
		}
		
		// Reset delay timer after it has ticked the set amount of 4 times
		public function resetTimer(e:TimerEvent) {
			movementDelay.reset();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			removeDisplay();
			moveDisplayArray = [];
			
		}
		
		// removes the display arrows
		public function removeDisplay() {
			for (var i=0; i< moveDisplayArray.length; i++) {
				removeChild(moveDisplayArray[i]);
			}
		}
		
		// toggle whether the go button is greyed out or not
		public function toggleGoButton() {
			if (intermediateMoves.length < 4) {
				addChild(goButton);
			} else {
				removeChild(goButton);
				addChild(goButtonGreen);
			}
		}
	}
}