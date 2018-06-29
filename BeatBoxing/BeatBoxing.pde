import ddf.minim.*;

Minim minim;
AudioSample kick;
AudioSample snare;
AudioSample hihat;
AudioSample double_hihat;
AudioSample low;
AudioSample mid;
AudioSample high;

TimeMaster timeMaster;
Player player;
Enemy enemy;
InputHandler inputHandler;

final color RED = color(255,0,0);
final color BLUE = color(0,0,255);
final color GREEN = color(0,255,0);
final color YELLOW = color(255,216,0);


PFont mono;

void setup()
{
  size(640, 360);
  player = new Player();
  enemy = new Enemy();
  timeMaster = new TimeMaster(120);
  inputHandler = new InputHandler();
  
  mono = createFont("Georgia", 32);
  textFont(mono);
  textSize(100);
  
  minim = new Minim(this);
  kick = minim.loadSample( "Kick.wav",512);
  snare = minim.loadSample( "Snare.wav",512);
  hihat = minim.loadSample( "Hihat.wav",512);
  double_hihat = minim.loadSample( "double_Hihat.wav",512);
  low = minim.loadSample( "Low.wav",512);
  mid = minim.loadSample( "Mid.wav",512);
  high = minim.loadSample( "High.wav",512);
  background(0);
}

void draw()
{
  background(0);
  timeMaster.tick();

  if(timeMaster.isOnBeat() && timeMaster.pressed==false)
    //switch(timeMaster.pattern[(timeMaster.bar_position)%8])
    if(timeMaster.comboing)
    {
      switch(timeMaster.combo[timeMaster.combo_count])
      {
        case 2:
          background(BLUE);
        case 3:
          background(YELLOW);
        case 4:
          background(GREEN);
        case 1:
        case 0:
        default:
          break;
      }
    }
    else
      switch(timeMaster.pattern[(timeMaster.bar_position)%8])
      {
        case 1://Kick
          background(RED);
          break;
        case 2://Block
          background(BLUE);
          break;
        case 3://Special
          if(player.getMana() >= 4)
            background(YELLOW);
          break;
        case 4://Heal
          if(player.isManaMaxed())
            background(GREEN);
          break;
        case 0:
        default:
          break;
      }
  
  drawGUI();
}

void keyPressed()
{
  inputHandler.keyPressed();
}