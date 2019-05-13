class Wall
{
  int x;
  int y;
  int w;
  int h;
  Wall(int x_,int y_, int w_, int h_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }
  Wall copy()
  {
    Wall out = new Wall(x,y,w,h);
    return out;
  }
  void draw(boolean inverted)
  {
    if(inverted)
      fill(color(255,255,255));
    else
      fill(0);
    noStroke();
    rect(x,y,w,h);
  }
}