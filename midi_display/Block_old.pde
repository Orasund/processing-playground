/*class Block_old
{
  float default_x;
  float default_y;
  float default_w;
  float default_h;
  float default_a;
  float x;
  float y;
  float w;
  float h;
  float a;
  color c;
  float t;
  int delay;
  
  Block_old(int delay_)
  {
    init(0,0,0,0,color(0),delay_);
  }
  
  Block_old(float x_, float y_, float w_, float h_, int delay_)
  {
    init(x_,y_,w_,h_,color(0),delay_);
  }
  
  Block_old(float x_, float y_, float w_, float h_,color c_, int delay_)
  {
    init(x_,y_,w_,h_,c_,delay_);
  }
  
  private void init(float x_, float y_, float w_, float h_,color c_, int delay_)
  {
    default_x = x_;
    x = x_;
    default_y = y_;
    y = y_;
    default_w = w_;
    w = w_;
    default_h = h_;
    h = h_;
    c = c_;
    delay = delay_;
    t = 0;
    a = 0;
    default_a = 0;
  }
  
  Block_old setColor(color c_)
  {
    c = c_;
    return this;
  }
  
  Block_old setAlpha(int a_)
  {
    default_a = a_;
    a = a_;
    t = delay;
    return this;
  }
  
  Block setFinalX(float x_)
  {
    default_x = x_;
    x = x_;
    return this;
  }
  
  Block setFinalY(float y_)
  {
    default_y = y_;
    y = y_;
    return this;
  }
  
  Block setFinalWidth(float w_)
  {
    default_w = w_;
    w = w_;
    return this;
  }
  
  Block setFinalHeight(float h_)
  {
    default_h = h_;
    h = h_;
    return this;
  }
  
  Block setX(float x_)
  {
    default_x = x_;
    return this;
  }
  
  Block setY(float y_)
  {
    default_y = y_;
    return this;
  }
  
  Block setWidth(float w_)
  {
    default_w = w_;
    return this;
  }
  
  Block setHeight(float h_)
  {
    default_h = h_;
    return this;
  }
  
  Block moveTo(float x_, float y_, float w_, float h_)
  {
    setX(x_);
    setY(y_);
    setWidth(w_);
    setHeight(h_);
    return this;
  }
  
  void draw()
  {
    if(t>0)
    {
      if(a==default_a)
        stroke(255);
      else
        noStroke();
      fill(c,a);
      rect(x,y,w,h);
      //println(x+","+y+","+w+","+h);
    }
    
    t--;
    a = (default_a/2)*(1-cos((t/delay)*PI));
    if(abs(default_x-x)>1)
      x += (default_x-x)/2;
    if(abs(default_y-y)>1)
      y += (default_y-y)/2;
    if(abs(default_w-w)>1)
      w += (default_w-w)/2;
    if(abs(default_h-h)>1)
      h += (default_h-h)/2;
  }
}*/