// Size of cells
int cellSize = 3;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 4;

// Variables for timer
int interval = 25;
int lastRecordedTime = 0;

// Colors for active/inactive cells
int[] alive = {100, 100,100};
//color alive = color(100, 100,100);
int[] dead = {0,0,0};
//color dead = color(0);
int[] colorShip = {0, 0,200};
//color colorShip = color(0, 0,200);
int[] enemyShip = {200, 0,0};
//color enemyShip = color(200, 0,0);
int[] colorPointer = {0, 200, 0};
//color colorPointer = color(0, 200, 0);
int[] colorBullet = {0, 0,100};
//color colorBullet = color(0, 0,100);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

int regen = 0;
int life = 0;
int maxLife = 5;

int cooldown = 0;
int dir = 0; //Up, go right
char[] directions = {'w','d','s','a'};
int[][] dirMove = {{0,0},{0,0},{0,0},{0,0}};
int[] pointer = {20,20};
int[][] ship = {
  //0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//1
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//2
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//3
   {0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0},//4
   {0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0},//5
   {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},//6
   {0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0},//7
   {0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0},//8
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//9
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//1
   {0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0},//2
   {0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0},//3
   {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},//4
   {0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0},//5
   {0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0},//6
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//7
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//8
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//9
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} //0
};
/*int[][] ship = {
  //0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//1
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//2
   {0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0},//3
   {0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0},//4
   {0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0},//5
   {0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0},//6
   {0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0},//7
   {0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0},//8
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//9
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//0
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//1
   {0,0,0,0,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0},//2
   {0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0},//3
   {0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0},//4
   {0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0},//5
   {0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0},//6
   {0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0},//7
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//8
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},//9
   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} //0
};*/

int[][] bullet = {
  //0,1,2
   {1,1,0,},//0
   {1,0,1,},//1
   {1,0,0,},//2
   {0,0,0,},//3
   {1,0,0,},//4
   {1,0,1,},//5
   {1,1,0,},//6
};

/*int[][] bullet = {
  //0,1,2
   {1,1,0,},//0
   {1,1,0,},//1
   {0,0,0,},//2
   {0,0,0,},//3
   {0,0,0,},//4
   {1,1,0,},//5
   {1,1,0,},//6
};*/

// Pause
boolean pause = false;

void setup() {
  size (1280, 720);
  frameRate(60);
  frame.setResizable(true);
  //noLoop();
  

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(48);

  noSmooth();

  // Initialization of cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      float state = random (100);
      if (state > probabilityOfAliveAtStart) { 
        state = 0; //dead
      }
      else {
        if(int(random (5))==0){
          state = 4; //Enemy
        } else {
          state = 1; //alive
        }
        
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  
  //Build ship
  for (int x=0; x<21; x++) {
    for (int y=0; y<21; y++) {
      cells[pointer[0]-10+x][pointer[1]-10+y] = ship[x][y]*  2; //Ship
    }
  }
  
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      noStroke();
      if (x==pointer[0]&&y==pointer[1]){
        fill(color(colorPointer[0],colorPointer[1],colorPointer[2])); // If alive
      } else if (cells[x][y]==1) {
        //int c = int(random(8))*16+50;
        int c = (floor((x+y*2)/2)%8)*16+50;
        fill(color(c,c,c)); // If alive
      } else if (cells[x][y]==2) {
        int c = floor((x+y*2)/2)%(life+1)*16;
        fill(color(colorShip[0]+life*4*maxLife-c,colorShip[1]+life*4*maxLife-c+regen,colorShip[2]-life*2*maxLife-c));
      } else if (cells[x][y]==3) {
        fill(color(colorBullet[0],colorBullet[1],colorBullet[2]));
      } else if (cells[x][y]==4){
        fill(color(enemyShip[0],enemyShip[1],enemyShip[2]));
      } else {
        fill(color(dead[0],dead[1],dead[2])); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  
  
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      iteration();
      iteration();
      lastRecordedTime = millis();
    }
  }

  
  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(color(dead[0],dead[1],dead[2])); // Fill with kill color
    }
    else { // Cell is dead
      cells[xCellOver][yCellOver]=2; // Make ship
      fill(color(alive[0],alive[1],alive[2])); // Fill alive color
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}



void iteration() { // When the clock ticks
  if(cooldown > 0)cooldown--;
  
  if(regen>0){regenerate();}

// Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  int[] min = {pointer[0],pointer[1]};
  int[] max = {pointer[0],pointer[1]};
  
  int shipParts = 0;

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){//Ship
        shipParts++;
      }
      
      int drawColor = 2;
      int nwidth = floor(width/cellSize);
      int nheight = floor(height/cellSize);
      //println(width + "/" + cellSize);
      //println(nwidth + "+" + nheight);
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      for (int xx=x-1; xx<=x+1;xx++) {
        int nxx = (nwidth+xx)%nwidth;
        //println(nxx);
        //int nxx = xx;
        for (int yy=y-1; yy<=y+1;yy++) {  
          int nyy = (nheight+yy)%nheight;
          //println(nyy);
          //int nyy = yy;
          //if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((nxx==x)&&(nyy==y))) { // Make sure to to check against self
              if (cellsBuffer[nxx][nyy]!=0){
                neighbours ++; // Check alive neighbours and count them
                if(drawColor >= 2 && cellsBuffer[nxx][nyy]==3){
                  drawColor = 3;
                } else if(drawColor < 3 && cellsBuffer[nxx][nyy]==4){
                  drawColor = 4;
                } else if(drawColor != 4 && cellsBuffer[nxx][nyy]==1){
                  drawColor = 1;
                }
              }
            } // End of if
          //} // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]!=0) { // The cell is alive: kill it if necessary
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
      }
      else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = drawColor; // Only if it has 3 neighbours
        }
      } // End of if
      //Mittelpunkt des Schiffes bestimmen
      if(cells[x][y]==2){
        if(x>max[0])max[0] = x;
        if(x<min[0])min[0] = x;
        if(y>max[1])max[1] = y;
        if(y<min[1])min[1] = y;
      }
    } // End of y loop
  } // End of x loop
  
  //Pointer setzen
  if(regen==0){
    pointer[0] = (max[0]+min[0])/2;
    pointer[1] = (max[1]+min[1])/2;
    
    //Regeneration?
    if(shipParts<20){
      regen = 100;
      dir = 0;
      if(life < maxLife+1)life++;
    }
  }
  
  
} // End of function

void turnRight() {
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){ //ship
        cells[x][y] = 0;
      }
    }
  }
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){ //ship
        int rx = (x-pointer[0]);
        int ry = (y-pointer[1]);
        cells[(pointer[0]-ry+(width/cellSize))%(width/cellSize)][(pointer[1]+rx+(height/cellSize))%(height/cellSize)] = 2;
      }
    }
  }
}

void turnLeft() {
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){ //ship
        cells[x][y] = 0;
      }
    }
  }
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){ //ship
        int rx = x-pointer[0];
        int ry = y-pointer[1];
        cells[(pointer[0]+ry+(width/cellSize))%(width/cellSize)][(pointer[1]-rx+(height/cellSize))%(height/cellSize)] = 2;
      }
    }
  }
}

int[] turn(int dir){
  int[] back = {0,0};
  switch(dir){
    case 0:
      back[1] = -1;
      break;
    case 1:
      back[0] = 1;
      break;
    case 2:
      back[1] = 1;
      break;
    case 3:
      back[0] = -1;
      break;
  }
  return back;
}

void shot(){
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 3){ //Bullet
        cells[x][y] = 0;
      }
    }
  }
  
  for (int x=0; x<7; x++) {
    for (int y=0; y<3; y++) {
      if(bullet[x][y] != 0){
        int rx = x-3;
        int ry = y-16;
        switch(dir){
            case 0:
              cells[pointer[0]+rx][pointer[1]+ry] = 3; //Bullet
              break;
            case 1:
              cells[pointer[0]-ry][pointer[1]+rx] = 3; //Bullet
              break;
            case 2:
              cells[pointer[0]-rx][pointer[1]-ry] = 3; //Bullet
              break;
            case 3:
              cells[pointer[0]+ry][pointer[1]-rx] = 3; //Bullet
              break;        
        }
      }
    }
  }
}

void regenerate(){
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cellsBuffer[x][y] == 2){ //ship
        cells[x][y] = 0;
      }
    }
  }
  
  //Build ship
  for (int x=0; x<21; x++) {
    for (int y=0; y<21; y++) {
      if(int(random(regen/16+life*2)) < life+maxLife){
        cells[(pointer[0]-10+x+width/cellSize)%(width/cellSize)][(pointer[1]-10+y+height/cellSize+1)%(height/cellSize)] = ship[x][y]*  2; //Ship
      }
    }
  }
  
  println("life:"+life);
  regen--;
}

void keyPressed() {
  if(regen==0){
    if (key==directions[(dir+1)%4]) {
        dir=(dir+1)%4;
        turnRight();
        println(dir);
    }
    if (key==directions[(dir+3)%4]) {
        dir=(dir+3)%4;
        turnLeft();
        println(dir);
    }
    if (key==' ') { // On/off of pause
      if(cooldown == 0){
        shot();
        cooldown = 30;
      }
    }
    
    
    /*  // Restart: reinitialization of cells
      for (int x=0; x<width/cellSize; x++) {
        for (int y=0; y<height/cellSize; y++) {
          float state = random (100);
          if (state > probabilityOfAliveAtStart) {
            state = 0;
          }
          else {
            state = 1;
          }
          cells[x][y] = int(state); // Save state of each cell
        }
      }
    }*/
    if (key=='p') { // On/off of pause
      pause = !pause;
    }
    /*if (key=='c' || key == 'C') { // Clear all
      for (int x=0; x<width/cellSize; x++) {
        for (int y=0; y<height/cellSize; y++) {
          cells[x][y] = 0; // Save all to zero
        }
      }
    }*/
    
    //iteration();
    //redraw();
  }
}
