//-----------------------------------------------------
//
//  dreieck.pde
//    For N Points, each takes two other points and
//    trys to form a equilateral triangle
//
//  PLEASE USE THE SETTINGS CLASS FOR BASIC CHANCES
//
//
//  Author: Lucas Payr
//
//-----------------------------------------------------

/******************************************************
**  Gobal Variables
***************************************************+**/
settings S = new settings();
int N = S.Amount_Of_Points; //min:3
int W,H; //Width, Height
int MODE = S.Default_Mode; //0-triangle, 1-Path, 2-Shadow
Point[] p = new Point[N];

/******************************************************
**  Setup
******************************************************/
void setup() {
  /* use either fullScreen or size. */
  //fullScreen();  
  size(640,640);//windowed Mode 
  
  if(!S.Auto_Run) noLoop();
  colorMode(HSB, 100);
  background(color(0,0,100));
  W = width; //width of the Window
  H = height; //height of the Windw
  
  /* setting up p */
  for(int i = 0; i < N; i++)
  {
    p[i] = new Point(i);
  }
}

/******************************************************
**  ITERATE
******************************************************/
void draw() {
  
  if(MODE == 0){background(color(0,0,100));}
  
  /* Logic */
  for(int i = 0; i < N; i++)
  {
    PVector temp_p = p[i].pointFromEquilTriangle();
    p[i].move(temp_p);
  }
  
  /*Graphics */
  for(int i = 0; i < N; i++)
  {
    p[i].flush();
    p[i].draw();
  }
}

/******************************************************
**  CONTROLS
******************************************************/
void keyPressed() {
  
  /* M...chance Mode */
  if(key == 'm' || key == 'M') {
    background(color(0,0,100));
    MODE = (MODE+1)%3;
  }
  
  /* S...speed Up */
  if(key == 's' || key == 'S') {
    S.Speed_Up = !S.Speed_Up;
  }
}