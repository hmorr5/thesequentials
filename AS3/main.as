﻿package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.geom.ColorTransform;
	
	import flash.media.*;
	
	public class main extends MovieClip{
		
		
		static const EASY:uint = 0;
		static const INTERMEDIATE:uint = 1;
		static const ADVANCED:uint = 2;
		
		static const cubeColor:Array = [0xff0000, 0xffdab9, 0x007f00];
		
		public var MusicBeginBg = new BegBg(); //Creates beginner lvl bg music
		public var MusicBeginBgCh = new SoundChannel(); //Creates beginner lvl bg sound channel
		public var MusicMenuBg = new loop(); //Creates Menu bg music
		public var MusicMenuBgCh = new SoundChannel(); //Creates Menu bg sound channel
		public var OnLvlStart = new weird(); //Creates sound for start of lvl
		
		private var document:main;
		
		var mode:uint;
		var block_newInput:Boolean;
		
		// maps keycodes to bug movements
		private var codeMap:Dictionary;
		
		// handles the input and calls
		var input:Input;
		
		// basic display objects
		var mainMenu:menu;
		var gameGrid:Grid;
		var character:Bug;
		var checkList;
		
		// intermediate/advanced mode
		var moves:Array;
		var moveDisplayArray:Array;
		var moveDisplayBackgrounds:Array;
		var moveList;
		var nextCube;
		var nextCubeArea;
		var nextCubeDisplay;
		var goButton;
		var goButtonGreen;
		public var enableGoButton:Boolean;
		
		// delays movement of bug in intermediate/advanced mode
		var movementDelay:Timer;
		
		public function main() {
			codeMap = new Dictionary();
			codeMap[37] = Bug.TURNLEFT;
			codeMap[38] = Bug.FORWARD;
			codeMap[39] = Bug.TURNRIGHT;
			codeMap[40] = Bug.UNDO;
			
			this.document = this;
		
			MusicMenuBgCh = MusicMenuBg.play(0, 20); //Begins playing the Menu Bg music
			
			//*
			input = new FiducialInput(this);
			/*/
			input = new KeyboardInput(this);
			// */
			
			input.next = 0;
			
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			gameGrid = new Map(8, 8, 3, 2);
			gameGrid.x = 400;
			gameGrid.y = 50;
			
			character = new Bug(this, gameGrid);
			character.gotoAndStop(1);
			
			checkList = new mockList;
			checkList.x = 1350;
			checkList.y = 50;
			
			nextCube = new nextText;
			nextCube.x = 1420;
			nextCube.y = 725;
			
			nextCubeArea = new nextArea;
			nextCubeArea.x = 1350;
			nextCubeArea.y = 725;
			
			nextCubeDisplay = new ColorTransform();
			
			mode = EASY;
		}
		
		private function setupEasyMode() {
			addChild(gameGrid);
			addChild(character);
			addChild(checkList);
			addChild(nextCubeArea);
			addChild(nextCube);
			nextInput();
			
			block_newInput = false;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode in codeMap) {
					newInput(codeMap[e.keyCode]);
				}
			});
			
			mode = EASY;
		}
		
		private function setupIntermediateMode() {
			setupAdvancedMode();
			
			var ghostDelay:Timer = new Timer(15000);
			ghostDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent = null):void {
				if (moves.length > 0 && !block_newInput) {
					var tmpMoves:Array = moves.slice(); // shallow copy, works for non-object arrays
					
					var ghost:Bug = new Bug(document, gameGrid, character.posX, character.posY, character.direction, 0.5);
					ghost.gotoAndStop(1);
					addChild(ghost);
					
					var ghostTick = new Timer(500, 2 * tmpMoves.length + 2);
					ghostTick.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
						if (block_newInput) {
							ghostTick.stop();
							removeChild(ghost);
						}
						var count:int = ghostTick.currentCount - 1;
						if (count < tmpMoves.length) {
							ghost.move(tmpMoves[count]);
						}/* else if (tmpMoves.length < count && count <= 2 * tmpMoves.length){
							ghost.reverse(tmpMoves[2 * tmpMoves.length - count]);
						}*/
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
			moveDisplayBackgrounds = [];
			
			moveList = new inputText;
			moveList.x = 200;
			moveList.y = 150;
			
			goButton = new goText;
			goButton.x = 200;
			goButton.y = 900;
			
			goButtonGreen = new goTextGreen;
			goButtonGreen.x = goButton.x;
			goButtonGreen.y = goButton.y;
			
			enableGoButton = false;
			
			addChild(moveList);
			
			updateGoButton();
			
			movementDelay = new Timer(1000, 4);
			
			goButtonGreen.addEventListener(MouseEvent.CLICK, clickGoButton);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == 32) { // spacebar
					clickGoButton();
				}
			});
			
			movementDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				if (moves.length > 0) {
					character.move(moves[0]);
					moves.shift();
				}
			});
			movementDelay.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				movementDelay.reset();
				allowInput();
				updateGoButton();
				
				// remove the display arrows
				for (var i=0; i< moveDisplayArray.length; i++) {
					removeChild(moveDisplayArray[i]);
					removeChild(moveDisplayBackgrounds[i]);
				}
				
				moveDisplayArray = [];
				moveDisplayBackgrounds = [];
			});
			
			mode = ADVANCED;
		}
		
		/**
		 * Start the game in easy mode: bug moves in real time.
		 */
		public function startEasyMode() {
			
			OnLvlStart.play(); //Starts playing the sound on lvl start
			MusicMenuBgCh.stop(); //Stops the menu Music
			MusicBeginBgCh.stop(); //Stops the Beginner lvl music (if the lvl goes straight back to main menu)
			MusicBeginBgCh = MusicBeginBg.play(0, 20); //Start Beginner lvl music
			setupEasyMode();
		}
		
		/**
		 * Start the game in intermediate mode: bug moves every 4 inputs and has a ghost.
		 */
		public function startIntermediateMode() {
			OnLvlStart.play(); //Same as beginner
			MusicMenuBgCh.stop(); //Same as beginner
			MusicBeginBgCh.stop(); //Same as beginner
			MusicBeginBgCh = MusicBeginBg.play(0, 20); //Same as Beginner
			MusicBeginBgCh = MusicBeginBg.play(0, 20); //Same as Beginner
			setupIntermediateMode();
		}
		
		/**
		 * Start the game in advanced mode: bug moves every 4 inputs.
		 */
		public function startAdvancedMode() {
			OnLvlStart.play();
			MusicMenuBgCh.stop();
			MusicBeginBgCh.stop();
			MusicBeginBgCh = MusicBeginBg.play(0, 20);
			setupAdvancedMode();
		}
		
		/**
		 * Process input depending on the selected mode:
		 *  - EASY (real time)
		 *  - INTERMEDIATE / ADVANCED (work in moves array and show arrows in moveDisplayArray)
		 */
		public function newInput(input:uint):void {
			if (block_newInput) return;
			if (mode == EASY) {
				character.move(input);
				
				nextInput();
			} else { // intermediate/advanced mode
				if (input == Bug.UNDO) {
					if (moves.length > 0) {
						moves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
						tmp = moveDisplayBackgrounds.splice(-1, 1);
						removeChild(tmp[0]);
						
						lastInput();
					}
				} else if (moves.length < 4) {
					moves.push(input);
					
					var arrow;
					switch (input) {
						case Bug.FORWARD:
							arrow = new goForwardArrow();
						
							break;
						case Bug.TURNLEFT:
							arrow = new turnLeftArrow();
							break;
						case Bug.TURNRIGHT:
							arrow = new turnRightArrow();
							break;
					}
					arrow.y = (300 + 130 * (moves.length - 1));
					arrow.x = 200;
					moveDisplayArray.push(arrow);
					var background = new Token();
					background.x = arrow.x - 0.5 * background.width;
					background.y = arrow.y - 0.5 * background.height;
					background.transform.colorTransform = nextCubeDisplay;
					moveDisplayBackgrounds.push(background);
					
					addChild(background);
					addChild(arrow);
				
					nextInput();
				}
				updateGoButton();
			}
		}
		
		public function blockInput():void {
			block_newInput = true;
		}
		
		public function allowInput():void {
			block_newInput = false;
		}
		
		private function nextInput():void {
			if (input.next != -1) {
				input.next = (input.last + 1) % cubeColor.length;
				
				nextCubeDisplay.color = cubeColor[input.next];
				nextCubeArea.transform.colorTransform = nextCubeDisplay;
			}
		}
		
		private function lastInput():void {
			if (input.next != -1) {
				input.next = (input.last + cubeColor.length) % cubeColor.length;
				input.last = (input.last + cubeColor.length - 1) % cubeColor.length;
				
				nextCubeDisplay.color = cubeColor[input.next];
				nextCubeArea.transform.colorTransform = nextCubeDisplay;
			}
		}
		
		private function clickGoButton(e:MouseEvent = null):void {
			if (moves.length == 4 || enableGoButton) {
				movementDelay.start();
				blockInput();
				
				
				
				input.last = -1;
			}
		}
		
		/**
		 * Toggles between grey/green GoButton.
		 */
		private function updateGoButton() {
			if (moves.length < 4) {
				enableGoButton = false;
				var ghost:Bug = new Bug(document, gameGrid, character.posX, character.posY, character.direction, 0);
				ghost.gotoAndStop(1);
				for (var i:Number = 0; i < moves.length; i++) {
					ghost.move(moves[i]);
				}
			}
			if (moves.length == 4 || enableGoButton) {
				if (goButton.stage) {
					removeChild(goButton);
				}
				addChild(goButtonGreen);
				
			} else {
				if (goButtonGreen.stage) {
					removeChild(goButtonGreen);
				}
				addChild(goButton);
			}
		}
	}
}