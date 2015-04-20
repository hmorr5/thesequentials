package {
	
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class main extends MovieClip{
		
		//Delays movement of bug on intermediate/advanced levels
		var movementDelay = new Timer(1000, 4);
		
		// 0: East, 1: South, 2: West, 3: North
		var playerDirection:int = 0;
		
		//Arrays
		var intermediateMoves:Array = [];
		var moveDisplayArray:Array = [];
		
		//Global var for the smooth rotation
		var angle:int = 0;
		
		//These are all vars for symbols (images)
		var checkList;
		var character:yourDude;
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
			
			character = new yourDude(0, 0, gameGrid);
			addChild(character);
			character.gotoAndStop(1);
			playerDirection = 0;
			
			addChild(checkList);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCharacterEasy);
		}
		
		//Start the game in intermediate mode.  Bug moves every 4 inputs.
		public function startIntermediateMode() {
			var gameGrid:Grid = new Grid(8,8,0);
			gameGrid.x = 400;
			gameGrid.y = 50;
			addChild(gameGrid);
			
			character = new yourDude(0, 0, gameGrid);
			addChild(character);
			character.gotoAndStop(1);
			playerDirection = 0;
			
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
			var speed = 113;
			
			//Player turns left
			if(e.keyCode == 37) {
				playerDirection = (playerDirection + 3) % 4;
				TweenMax.to(character, 1, {shortRotation:{rotation:angle -= 90}});
				if (angle <= -360) {
					angle = 0;
				}
			}
			
			//Player turns right
			else if(e.keyCode == 39) {
				playerDirection = (playerDirection + 1) % 4;
				trace("angle: " + angle);
				TweenMax.to(character, 1, {shortRotation:{rotation:angle += 90}});
				if (angle >= 360) {
					angle = 0;
				}
			}
			
			//player moves in direction
			else if(e.keyCode == 38) {
				character.move(playerDirection);
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
						trace("What's in array: " + intermediateMoves);
					}
				
					//Player turns right
					else if(e.keyCode == 39) {
						intermediateMoves.push("39");
						turnRight = new turnRightArrow();
						turnRight.y = (300 + 125*(intermediateMoves.length - 1));
						turnRight.x = 200;
						moveDisplayArray.push(turnRight);
						addChild(turnRight);
						trace("What's in array: " + intermediateMoves);
					}
				
					//player moves up
					else if(e.keyCode == 38) {
						intermediateMoves.push("38");
						forwardArrow = new goForwardArrow();
						forwardArrow.y = (300 + 125*(intermediateMoves.length - 1));
						forwardArrow.x = 200;
						moveDisplayArray.push(forwardArrow);
						addChild(forwardArrow);
						trace("What's in array: " + intermediateMoves);
					}
				}
				
				if (intermediateMoves.length > 0) {
					//player deletes move
					if(e.keyCode == 40) {
						intermediateMoves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
						trace("What's in Array " + intermediateMoves);
					} 
				} 
				
				toggleGoButton();
			}
			trace("Key Code: " + e.keyCode);
		}
		
		//Execute the moves that have been inputted (intermediate mode)
		public function executeIntermediateMoves(e:TimerEvent=null){
			var speed = 113;
			
			if(intermediateMoves[0] == 37) {
				playerDirection = (playerDirection + 3) % 4;
				TweenMax.to(character, 1, {shortRotation:{rotation:angle -= 90}});
				if (angle <= -360) {
					angle = 0;
				}
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 39) {
				playerDirection = (playerDirection + 1) % 4;
				TweenMax.to(character, 1, {shortRotation:{rotation:angle += 90}});
				if (angle >= 360) {
					angle = 0;
				}
				intermediateMoves.shift();
			}
			else if (intermediateMoves[0] == 38) {
				character.move(playerDirection);
				intermediateMoves.shift();
			}
		}
		
		public function clickGo(Event:MouseEvent) {
			if (intermediateMoves.length == 4) {
				movementDelay.start();
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			}
		}
		
		//Reset delay timer after it has ticked the set amount of 4 times
		public function resetTimer(e:TimerEvent) {
			movementDelay.reset();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushCharacterIntermediate);
			removeDisplay();
			moveDisplayArray = [];
			
		}
		
		//removes the display arrows
		public function removeDisplay() {
			for (var i=0; i< moveDisplayArray.length; i++) {
				removeChild(moveDisplayArray[i]);
				trace("remove display" + moveDisplayArray[i]);
			}
		}
		
		//toggle whether the go button is greyed out or not
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

///http://www.as3blog.org/2010/03/01/how-to-create-an-as3-game-grid/