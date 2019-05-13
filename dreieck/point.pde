//-----------------------------------------------------
//  Point: vector v with two "friends" a,b
//-----------------------------------------------------
class Point
{
  //use temp_v to tempuraly chance the vector
  //use flush() to permernantly save chances from temp_v to v.
  
  PVector v = new PVector(); //(x,y)
  PVector temp_v = new PVector(); //Dummy
  int a,b; //index of the his friends 
  
  Point(int i)
  {
    v.x = random(W);
    v.y = random(H);
    temp_v.x = v.x;
    temp_v.y = v.y;
    a = floor(random(N-1));
    b = floor(random(N-2));
    if(b >= a) b++;
    if(a >= i) a++;
    if(b >= i) b++;
  }
  
  //-----------------------------------------------------
  //  
  //  pointFromEquilTriangle()
  //  findes a point temp_p so that (a,b,temp_p) describes
  //  a Equilateral Triangle
  //
  //-----------------------------------------------------
  PVector pointFromEquilTriangle()
  {
    //first get the distance d between a and b
    //then find the center and draw the height h of the triangle
    //h must be in 90° to d
    //now find nearest point (to h or -h)
    
    /* find h */
    PVector d = //new PVector(0,0);
    PVector.sub(p[b].v,p[a].v); //distance
    
    PVector h = new PVector(d.y,-d.x); //height of the Triangle
    h.setMag(d.mag()*sqrt(3)/2);  //h := d*sqrt(3) / 2
    
    /* find the nearest point */
    //p1 will first be used as center
    //later it will be reused as a candidate point
    PVector p1 = PVector.div(d,2); //center of AB
    PVector p2 = new PVector(0,0);
    
    p1.add(p[a].v); //make p1 a Point (not a vector)
    
    PVector.add(p1,h,p2);
    PVector.sub(p1,h,p1);
    
    //p1,p2 are now the candidate points
    PVector.sub(p1,v,h);
    float dist1 = h.mag();
    PVector.sub(p2,v,h);
    float dist2 = h.mag();
    
    //return the best point
    if(dist1 > dist2)
    {
      return p2;
    }
    return p1;
  }
  
  //-----------------------------------------------------
  //  
  //  move()
  //  moves the point to the new location and write it into temp_v
  //
  //-----------------------------------------------------
  void move(PVector temp_p)
  {
    temp_p.sub(v);
    
    //Drawing the Lines
    if(MODE != 1)
    {
      if(MODE == 0)
        stroke(0);
      if(MODE == 2)
        stroke(temp_p.mag()*256/H);
      line(v.x,v.y,p[a].v.x,p[a].v.y);
      line(v.x,v.y,p[b].v.x,p[b].v.y);
    }
    
    temp_p.normalize();
    if(S.Speed_Up)
    {
      temp_p.setMag(5);
    }
    temp_v.add(temp_p);
  }
  
  //-----------------------------------------------------
  //  
  //  flush()
  //  ivaluates temp_v and stores them in v
  //
  //-----------------------------------------------------
  void flush()
  {
    if(temp_v.x > W-1)
      temp_v.x = W-1;
    if(temp_v.x < 0)
      temp_v.x = 0;
    if(temp_v.y > H-1)
      temp_v.y = H-1;
    if(temp_v.y < 0)
      temp_v.y = 0;
    
    v.x = temp_v.x;
    v.y = temp_v.y;
  }
  
  //-----------------------------------------------------
  //  
  //  draw()
  //  draws the Point
  //
  //-----------------------------------------------------
  void draw()
  {
    //fill((i*256)/N);
    fill(0);
    //line(p[i].v.x,p[i].v.y,p[p[i].a].v.x,p[p[i].a].v.y);
    //line(p[i].v.x,p[i].v.y,p[p[i].b].v.x,p[p[i].b].v.y);
    noStroke();
    ellipse(v.x, v.y, 1, 1);
  }
}