# Interactive Tic Tac Toe using Webcam

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/kd77onAzMz0/0.jpg)](https://www.youtube.com/watch?v=kd77onAzMz0)


This project implements an interactive version of tic-tac-toe using live video stream captured through a webcam. In a game of tic-tac-toe, there is a 3x3 grid of tiles and the 2 players in successive turns try to pick their tiles and the first player to pick 3 tiles arranged vertically/horizontally/diagonally is the winner. 

Here, we capture the realtime video through a webcam and superimpose it with a 3x3 grid and display the image. The 2 players (X,O) use 2 markers of colors green and red to point to the tile they would like to select. Here Image processing is used to first detect the pointers. 

Note that in order to keep track of turns, we only look for the pointer corresponding with the color allotted to the player (red/green) in each turn. Once the first player’s tile is assigned, we look for the second person’s color pointer.The tic-tac-toe algorithm is implemented to determine the winner.

References:

[1] https://www.mathworks.com/matlabcentral/fileexchange/62081-tictactoe?focused=7390605&tab=function

[2] https://www.mathworks.com/matlabcentral/fileexchange/40154-how-to-detect-and-track-red-green-and-blue-colored-object-in-live-video?focused=6513820&tab=function

