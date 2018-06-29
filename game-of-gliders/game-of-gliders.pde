// Size of cells
int cellSize = 5;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 10; //15
float probabilityOfAlive = 1; //15
float probabilityOfVirusAtStart = 1; //15

float counter;
float allies;
float timer;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;
int[] ship_position = new int[4];
int cell_typ = 0;

// Colors for active/inactive cells
color alive = color(200,200,200);
color dead = color(0);
color ship = color(000, 0, 200);
color enemy = color(0, 200, 0);
color virus = color(200, 0, 0);
color c = color(200,200,0); //counter

PFont f = createFont("Arial",16,true);

//ship animation

int[][][][] ship_animation = {
  {
    {
      {0,0,0,0,0},
      {0,0,2,0,0},
      {0,0,0,2,0},
      {0,2,2,2,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,2,0,2,0},
      {0,0,2,2,0},
      {0,0,2,0,0},
      {0,0,0,0,0},
    },{
      {0,0,0,0,0},
      {0,0,0,2,0},
      {0,2,0,2,0},
      {0,0,2,2,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,2,0,0,0},
      {0,0,2,2,0},
      {0,2,2,0,0},
      {0,0,0,0,0}
    }
  },{
    {
      {0,0,0,0,0},
      {0,0,2,0,0},
      {0,2,0,0,0},
      {0,2,2,2,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,0,0,2,0},
      {0,2,2,0,0},
      {0,0,2,2,0},
      {0,0,0,0,0},
    },{
      {0,0,0,0,0},
      {0,2,0,0,0},
      {0,2,0,2,0},
      {0,2,2,0,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,2,0,2,0},
      {0,2,2,0,0},
      {0,0,2,0,0},
      {0,0,0,0,0}
    }
  },{
    {
      {0,0,0,0,0},
      {0,2,2,0,0},
      {0,2,0,2,0},
      {0,2,0,0,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,0,2,0,0},
      {0,2,2,0,0},
      {0,2,0,2,0},
      {0,0,0,0,0},
    },{
      {0,0,0,0,0},
      {0,2,2,2,0},
      {0,2,0,0,0},
      {0,0,2,0,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,0,2,2,0},
      {0,2,2,0,0},
      {0,0,0,2,0},
      {0,0,0,0,0}
    }
  },{
    {
      {0,0,0,0,0},
      {0,2,2,2,0},
      {0,0,0,2,0},
      {0,0,2,0,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,2,2,0,0},
      {0,0,2,2,0},
      {0,2,0,0,0},
      {0,0,0,0,0},
    },{
      {0,0,0,0,0},
      {0,0,2,2,0},
      {0,2,0,2,0},
      {0,0,0,2,0},
      {0,0,0,0,0}
    },{
      {0,0,0,0,0},
      {0,0,2,0,0},
      {0,0,2,2,0},
      {0,2,0,2,0},
      {0,0,0,0,0}
    }  
  }
};


// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (640, 360);

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
        state = 0;
      }
      else {
        state = random (100);
        if(state <= probabilityOfVirusAtStart){
          state = 4; //Virus
        } else {
          state = 3; //Enemy
        }
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  /*ship*/
  ship_position[0] = width/(2*cellSize);
  ship_position[1] = height/(2*cellSize);
  ship_position[2] = 0; //Direction
  ship_position[3] = 0; //animation
  for (int x=0; x<5;x++){
     for (int y=0; y<5;y++){
       cells[ship_position[0]+x][ship_position[1]+y] = int(ship_animation[ship_position[2]][ship_position[3]][y][x]);
     }
  }
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      switch(cells[x][y]){
        case 1:
          fill(alive); // If alive
          break;
        case 2:
          fill(ship); // If Ship
          break;
        case 3:
          fill(enemy); //if Enemy
          break;
        case 4:
          fill(virus); //if Virus
          break;
        default:
          fill(dead); // If dead
          break;
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

/*
  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]!=0) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(dead); // Fill with kill color
    }
    else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive color
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }*/
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  counter = 0;
  allies = 0;

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      cell_typ=0;
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]!=0){
                neighbours ++; // Check alive neighbours and count them
                if (cellsBuffer[xx][yy]==4){
                  cell_typ=2; //virus
                } else if ((cellsBuffer[xx][yy]==1) || (cellsBuffer[xx][yy]==2)){
                  if (cell_typ !=2){
                    cell_typ=1; //life
                  }
                }
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]!=0) { // The cell is alive: kill it if necessary
        if (neighbours < 2 || neighbours > 3) {
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
        counter++;
        if (cellsBuffer[x][y]<=2){allies++;}
      } 
      else if(cellsBuffer[x][y]==0) { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          if(cell_typ==1){
            cells[x][y] = 1;
          } else if(cell_typ==2){ 
            cells[x][y] = 4; 
          } else {
            cells[x][y] = 3;
          }
        } else {
          float state = random (10000);
          if(state <= probabilityOfAlive){
            cells[x][y] = 3;
          }
        }
      }
    } // End of y loop
  } // End of x loop
  
  //move Ship
  switch(ship_position[2]){
    case 0:
      ship_position[0]++;
      ship_position[1]++;
      break;
    case 1:
      ship_position[0]--;
      ship_position[1]++;
      break;
    case 2:
      ship_position[0]--;
      ship_position[1]--;
      break;
    case 3:
      ship_position[0]++;
      ship_position[1]--;
      break;
  }
  ship_position[3]++;
  if(ship_position[3] > 3){ship_position[3]-=3;}
  
  for (int x=0; x<5;x++){
     for (int y=0; y<5;y++){
       if ((((ship_position[0]+x)>=0)&&((ship_position[0]+x)<width/cellSize))&&(((ship_position[1]+y)>=0)&&((ship_position[1]+y)<height/cellSize))) {
         if(ship_animation[ship_position[2]][ship_position[3]][y][x] == 2){
           cells[ship_position[0]+x][ship_position[1]+y] = int(2);
         } else if (cells[ship_position[0]+x][ship_position[1]+y] == 2){
           cells[ship_position[0]+x][ship_position[1]+y] = int(0);
         }
       }
     }
  }
  textFont(f,32);      
  fill(c);
  
  timer++;
  textAlign(RIGHT);
  text((floor(sqrt(timer)))+"Punkte",width-30,30);
  
  // Counter
  
  textAlign(LEFT);
  text((floor(100*allies/counter))+"%",20,30);
  if((floor(100*allies/counter) >= 95) || ((floor(100*allies/counter) <= 5) && (timer >= 25))){
    pause = true;
  }
} // End of function

void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
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
  }
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
  if (key=='d' || key == 'D'){
      ship_position[2]=0;
  }
  if (key=='s' || key == 'S'){
      ship_position[2]=1;
  }
  if (key=='a' || key == 'A'){
      ship_position[2]=2;
  }
  if (key=='w' || key == 'W'){
      ship_position[2]=3;
  }
}
