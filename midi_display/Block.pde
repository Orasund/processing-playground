class Block
{
  float x;
  float y;
  float w;
  float h;
  float a;
  
  Ani xAni;
  Ani yAni;
  Ani wAni;
  Ani hAni;
  Ani aAni;
  
  color c;
  float delay;
  
  Block(int delay_)
  {
    init(0,0,0,0,color(0),delay_);
  }
  
  Block(float x_, float y_, float w_, float h_, float delay_)
  {
    init(x_,y_,w_,h_,color(0),delay_);
  }
  
  Block(float x_, float y_, float w_, float h_,color c_, float delay_)
  {
    init(x_,y_,w_,h_,c_,delay_);
  }
  
  private void init(float x_, float y_, float w_, float h_,color c_, float delay_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
    delay = delay_;
    a = 0;
  }
  
  Block setColor(color c_)
  {
    c = c_;
    return this;
  }
  
  Block setAlpha(int a_)
  {
    a = a_;
    aAni = Ani.to(this, 0.5, 0, "a", 0, Ani.CUBIC_IN);
    return this;
  }
  
  Block moveTo(float x_, float y_, float w_, float h_)
  {
    xAni = Ani.to(this, 0.5, 0, "x", x_, Ani.CIRC_OUT);
    yAni = Ani.to(this, 0.5, 0, "y", y_, Ani.CIRC_OUT);
    wAni = Ani.to(this, 0.5, 0, "w", w_, Ani.LINEAR);
    hAni = Ani.to(this, 0.5, 0, "h", h_, Ani.LINEAR);
    return this;
  }
  
  void draw()
  {
    if(a>0)
    {
      if(aAni.getSeek() == 0)
        stroke(0);
      else
        noStroke();
      fill(c,a);
      rect(x,y,w,h);
    }
  }
}