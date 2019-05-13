/**
 * Triangle Strip 
 * by Ira Greenberg. 
 * 
 * Generate a closed ring using the vertex() function and 
 * beginShape(TRIANGLE_STRIP) mode. The outsideRadius and insideRadius 
 * variables control ring's radii respectively.
 */

int PLANETS = 1500;  int SCOPE = 15; int BOND = 1000; int S = 0; int A = 0; float G = 0.2;

float[][][] points = new float[PLANETS][3][2]; float temp_a[] = new float[2]; int tick=0;
float[] pick = new float[PLANETS];
float[][] c = new float[PLANETS][3];

float v[] = new float[2]; float leng;

float mod(float i, float m)
{
  return (i+m)%m;
}

void setup() {
  //fullScreen();
  size(640, 640);
  colorMode(HSB, 100);
  noStroke();
  background(color(0,0,70));
  frameRate(30);
  for(int i = 0; i < points.length;i++)
  {
    points[i][0][0] = int(1.5*width+random(width));
    points[i][0][1] = int(1.5*height+random(height));
    points[i][1][0] = int(random(S*2)-S);points[i][1][1] = int(random(S*2)-S);
    points[i][2][0] = int(random(A*2)-A);points[i][2][1] = int(random(A*2)-A);
    pick[i] = 0;
  }
}

void draw() {
  if(true){background(color(0,0,70));}
  
  fill(color(0,0,50));
  textSize(24);
  text("Gravitation in Farbe", 10, 30);
  textSize(20);
  text("in Zusammenarbeit mit Deumus", 10, height-10); 
  
  int MOUSE = 1; 
  //int MOUSE = int(map(mouseX, 0, width, 2, 10)); //Vertikale Position der Maus bestimmt G
  tick++;
  if(tick>1000)
  {
    tick-=1000;
    for(int i = 0; i < points.length/2;i++)
    {
      points[i][0][0] = int(1.5*width+random(width));
      points[i][0][1] = int(1.5*height+random(height));
      points[i][1][0] = int(random(S*2)-S);points[i][1][1] = int(random(S*2)-S);
      points[i][2][0] = int(random(A*2)-A);points[i][2][1] = int(random(A*2)-A);
      pick[i] = 0;
    }
  }
  for(int i = 0; i < points.length;i++)
  {
    if(pick[i]<1){
      //c[i][0]=mod(c[i][0]-16+random(32),255);
      c[i][0]=random(4)*64-16+random(32);
      
    }
    pick[i] = 0;
    for(int j = 0; j < points.length;j++)
    {
      v[0] = points[j][0][0]-points[i][0][0];
      v[1] = points[j][0][1]-points[i][0][1];
      
      leng = sqrt(v[0]*v[0] + v[1]*v[1]);
      if(leng < SCOPE && leng > -SCOPE){
        if(leng !=0)
        {
          temp_a[0] += ((G/MOUSE)*v[0]*BOND)/(leng*leng);
          temp_a[1] += ((G/MOUSE)*v[1]*BOND)/(leng*leng);
          c[i][0]+=(c[j][0]-c[i][0])/1.2;
          pick[i] += sqrt(v[0]*v[0] + v[1]*v[1]);
        }
      } else {
        points[i][2][0] += ((G/MOUSE)*v[0])/(leng*leng);
        points[i][2][1] += ((G/MOUSE)*v[1])/(leng*leng);
        points[i][2][1] += ((G/MOUSE)*v[0])/(100*leng*leng);
        points[i][2][0] -= ((G/MOUSE)*v[1])/(100*leng*leng);
      }
    }
    
    points[i][1][0] += points[i][2][0];
    points[i][1][1] += points[i][2][1];
    
    if(temp_a[0]==0){}
    else if(temp_a[0]>0)
    {
      if(temp_a[0] < points[i][2][0])
        points[i][2][0] -= temp_a[0];
      else
        //points[i][1][0] = 0;
        points[i][2][0] = 0;
    }
    else if(temp_a[0]<0)
    {
      if(temp_a[0] > points[i][2][0])
        points[i][2][0] -= temp_a[0];
      else
        //points[i][1][0] = 0;
        points[i][2][0] = 0;
    }
    
    if(temp_a[1]==0){}
    else if(temp_a[1]>0)
    {
      if(temp_a[1] < points[i][2][1])
        points[i][2][1] -= temp_a[1];
      else
        //points[i][1][1] = 0;
        points[i][2][1] = 0;
    }
    else if(temp_a[1]<0)
    {
      if(temp_a[1] > points[i][2][1])
        points[i][2][1] -= temp_a[1];
      else
        //points[i][1][1] = 0;
        points[i][2][1] = 0;
    }
  }
  for(int i = 0; i < points.length;i++)
  {
    points[i][0][0] += points[i][1][0];
    if(points[i][0][0]<0) points[i][0][0]=0;
    if(points[i][0][0]>(width*4)-4) points[i][0][0]=(width*4)-4;
    points[i][0][1] += points[i][1][1];
    if(points[i][0][1]<0) points[i][0][1]=0;
    if(points[i][0][1]>(height*4)-4) points[i][0][1]=(height*4)-4;
    //points[i][0][0] = (points[i][0][0]+points[i][1][0]+width*4)%(width*4);
    //points[i][0][1] = (points[i][0][1]+points[i][1][1]+height*4)%(height*4);
    fill(mod(c[i][0],100),100,pick[i]*10);
    //stroke(mod(c[i][0],255),255,pick[i]*16);
    //fill(color(c[i][0], c[i][1]-pick[i]/2, c[i][2]-pick[i]/2));
    //stroke(color(c[i][0]-127, c[i][1]-127, c[i][2]-127));
    //if(pick[i] > 0)
    int size = 20;
    if(pick[i] > size)
    //rect(points[i][0][0]/4,points[i][0][1]/4,6,6);
    ellipse(points[i][0][0]/4, points[i][0][1]/4, 6, 6);
    else
    //rect(points[i][0][0]/4,points[i][0][1]/4,1+pick[i]*5/20,1+pick[i]*5/20);
    ellipse(points[i][0][0]/4, points[i][0][1]/4,1+pick[i]*5/size,1+pick[i]*5/size);
  }
}