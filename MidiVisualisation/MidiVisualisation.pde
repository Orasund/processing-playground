/**
 * Array. 
 * 
 * An array is a list of data. Each piece of data in an array 
 * is identified by an index number representing its position in 
 * the array. Arrays are zero based, which means that the first 
 * element in the array is [0], the second element is [1], and so on. 
 * In this example, an array named "coswav" is created and
 * filled with the cosine values. This data is displayed three 
 * separate ways on the screen.  
 */


Retrogrid retrogrid;
int tick = 0;

void setup() {
  size(640, 360);
  
  retrogrid = new Retrogrid(640, 180, 0, 180, 10); 
  
  background(0);
}

void draw() {
  tick++;
  if(tick>120)
    tick = 0;
  if(tick%10==0)
    retrogrid.add();
  retrogrid.draw();
}