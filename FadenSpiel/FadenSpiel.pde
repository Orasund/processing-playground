//int RANGE = int((width*height)/(PLANETS));

int RANGE;
int PLANETS;
int tick = 0;

//int PLANETS = (int((width*height)/16))*(int((width+height)/16)); 

//100/200


//1000/50

float[][] points;
float[][] temp_points;
float[] temp_a;
float[] range;
float[] pick;

float v[] = new float[2]; float leng;

void setup() {
  //fullScreen();
  size(640, 640);
  colorMode(HSB, 100);
  background(color(0, 0, 70));
  frameRate(30);
  
  RANGE = (width+height)/16;
  PLANETS = int((width*height)/(RANGE*RANGE)*1.5);
  
  points = new float[PLANETS][2];
  temp_points = new float[PLANETS][2];
  temp_a = new float[2];
  range = new float[PLANETS];
  pick = new float[PLANETS];
  
  
  for(int i = 0; i < points.length;i++)
  {
    points[i][0] = int(random(width));
    points[i][1] = int(random(height));
    range[i] = RANGE;
    //range[i] = int((RANGE*2)/2+random(RANGE/4));
  }
}

void draw() {
  if(true){background(color(0, 0, 70));}
  
  fill(color(0,0,50));
  textSize(24);
  text("Fadenspiel", 10, 30);
  
  //int MOUSE = 1; 
  //int MOUSE = int(map(mouseX, 0, width, 2, 10)); //Vertikale Position der Maus bestimmt G
  
  tick++;
  for(int i = 0; i < points.length;i++)
  {
    temp_a[0] = 0;
    temp_a[1] = 0;
    if(int(random(PLANETS*100))==0)
    {
      points[i][0] = int(random(width));
      points[i][1] = int(random(height));
    }
    
    //temp_points[i][0] = points[i][0];
    //temp_points[i][1] = points[i][1];
    temp_points[i][0] = 0;
    temp_points[i][1] = 0;
    for(int j = 0; j < points.length;j++)
    {
      v[0] = points[j][0]-points[i][0];
      v[1] = points[j][1]-points[i][1];
      
      leng = sqrt(v[0]*v[0] + v[1]*v[1]);
      
      if(leng <= range[i]+20 && leng > 0){
        /*stroke(color((tick/8)%100, 50, 20+((leng/RANGE)*50)));
        line(points[i][0], points[i][1], points[j][0], points[j][1]);*/
        if(leng <= range[i]){
            temp_a[0] += v[0];
            temp_a[1] += v[1];
        }
      }
    }
    leng = sqrt(temp_a[0]*temp_a[0] + temp_a[1]*temp_a[1]);
    if(leng > 0)
    {
      temp_points[i][0] -= temp_a[0]/leng;
      temp_points[i][1] -= temp_a[1]/leng;
    }
  }
  for(int i = 0; i < points.length;i++)
  {
    for(int j = i+1; j < points.length;j++)
    {
      v[0] = points[j][0]-points[i][0];
      v[1] = points[j][1]-points[i][1];
      
      leng = sqrt(v[0]*v[0] + v[1]*v[1]);
      
      if(leng <= range[i]+20 && leng > 0)
      {
        stroke(color((tick/8)%100, 50, 00+((leng/RANGE)*50)));
        line(points[i][0], points[i][1], points[j][0], points[j][1]);
      }
    }
  }
  for(int i = 0; i < points.length;i++)
  {
    points[i][0] += temp_points[i][0];
    if(points[i][0]<0) points[i][0]=0;
    if(points[i][0]>width-4) points[i][0]=width-4;
    points[i][1] += temp_points[i][1];
    if(points[i][1]<0) points[i][1]=0;
    if(points[i][1]>height-4) points[i][1]=height-4;
    //fill(color(255, 255-pick[i]/2, 255-pick[i]/2));
    //stroke(color(pick[i]*16, 0, 0));
    //rect(points[i][0],points[i][1],4,4);
  }
}