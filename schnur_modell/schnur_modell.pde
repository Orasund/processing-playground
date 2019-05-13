Player p = new Player();
int H;
int W;

class Player
{
  float x=0;
  float y=0;
  float v=1;
  void draw()
  {
    //draw a triangle with center at (x,y)
    float l = 20; //length of one side
    float[] c = {+l*sqrt(3)/3,0};
    float[] b = {-l*sqrt(3)/6,l/2};
    float[] a = {-l*sqrt(3)/6,-l/2};
    triangle(x+a[0], y+a[1], x+b[0], y+b[1], x+c[0], y+c[1]);
  }
}

void setup()
{
  //fullScreen();
  size(680,360);
  int W = width;
  int H = height;
  
  colorMode(HSB, 100);
  background(color(0, 0, 70));
  
  p.x = W/4;
  p.y = H/2;
}

void draw()
{
  background(color(0, 0, 70));
  p.draw();
}