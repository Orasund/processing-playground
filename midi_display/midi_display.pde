import themidibus.*; //Import the library
import de.looksgood.ani.*;
PImage img;

MidiBus myBus; // The MidiBus
ManualMode manual;
Brain brain;

void setup()
{
  //fullScreen();
  size(1280,720);
  
  Ani.init(this);
  
  textAlign(CENTER);
  colorMode(HSB, 360, 100, 100,127);
  
  img = loadImage("back.jpg");
  
  Instrument[] instruments = {
    new TempInst(4),
    new ConservativeInst("Bass"),
    new SmartInst(""),
    new BaseInst()
  };
  
  int[] channels = {
    0,
    3,
    1,
    2
  };
  
  float[][] canvas = {
  //  x1,  y1,  x2,  y2
    { 0,   0,   (width*3)/4,   height/3},
    { 0,   height/3,  (width*3)/4,   (height*2)/3},
    { 0,   (height*2)/3,  (width*3)/4,   height},
    { (width*3)/4,   0,  width,   height},
  };
  
  brain = new Brain(instruments,channels,canvas);
  int[][] pattern = {
    {
      41,41,40,43,  35,0,36,0,  0,36,0,36,  0,36,33,0
    },
    {
      41,41,40,43,  35,0,36,0,  0,36,0,36,  0,36,33,0
    }
  };
  
  //                      BPM
  manual = new ManualMode(120,pattern,brain);
  MidiBus.list();
  myBus = new MidiBus(this, "LoopBe Internal MIDI"
, -1);
}

void noteOn(Note note) {
  brain.noteOn(note);
  // Receive a noteOn
  /*println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());*/
}

void noteOff(Note note) {
  // Receive a noteOff
  brain.noteOff(note);
  /*println();
  println("Note Off:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());*/
}
 
void draw()
{
  //background(0);
  image(img,0,0);
  //manual.tick();
  brain.draw();
}