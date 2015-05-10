# The Sequentials
Code related to the project for DECO3850 at the University of Queensland in Semester 1, 2015.

Please remember to document any necessary instructions for programmers / users in this file!

## Setup

_Fiducials:_ (as from Pete Worthy on http://deco3850.uqcloud.net/fileresources/lectures/fiducials_guide/assets/player/KeynoteDHTMLPlayer.html)
* download and install reacTIVision: http://reactivision.sourceforge.net/
* download the udpbridge: http://gkaindl.com/software/udp-flashlc-bridge
* rename udp-flashlc-bridge-win to "udp-flashlc-bridge.exe"

To run the application, launch reacTIVision and the udpbridge (either from command line or by double clicking the renamed .exe file).


## Fiducial Cube Assignment
[Direction] : [Fiducial id] 
The fiducial for the direction will be on the opposite side of the cube since the cube will be placed onto the glass.


_Red cube:_
- Foward : 1
- Left : 2
- Right : 3
- Unassigned Command 1 : 4
- Unassigned Command 2 : 5
- Unassigned Command 3 : 6

_Peach cube:_
- Foward : 7
- Left : 8
- Right : 9
- Unassigned Command 1 : 10
- Unassigned Command 2 : 11
- Unassigned Command 3 : 12

_Green cube:_
- Foward : 13
- Left : 14
- Right : 15
- Unassigned Command 1 : 16
- Unassigned Command 2 : 17
- Unassigned Command 3 : 18

## Map layouts
Map layouts can easily be created in the folder Maps/layouts as plain text files. They contain 8 lines of 8 characters to describe an 8x8 grid map. Please note, that _every_ line needs to be ended by a newline character, even the last line. There is 3 types of input fields:
* space: a standard field
* a letter (a, b, c, ...): an obstacle, corresponding to a.png, b.png, ... in the same folder
* a number (1, 2, 3, ...): a goal that needs to be reached
