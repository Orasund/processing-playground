import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BeatBoxing extends PApplet {



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

final int RED = color(255,0,0);
final int BLUE = color(0,0,255);
final int GREEN = color(0,255,0);
final int YELLOW = color(255,216,0);


PFont mono;

public void setup()
{
  
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

public void draw()
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

public void keyPressed()
{
  inputHandler.keyPressed();
}
public class Enemy
{
  final private int MAX_HEALTH = 10;
  int health;
  
  Enemy()
  {
    health = MAX_HEALTH;
  }
  
  public void reset()
  {
    health = MAX_HEALTH;
  }
  
  public int getHealth()
  {
    return health;
  }
  
  public void gainHealth(int amount)
  {
    health+=amount;
    if(health>=MAX_HEALTH)
    {
      health = MAX_HEALTH;
    }
  }
  
  public void looseHealth(int amount)
  {
    health-=amount;
    
    if(health<=0)
    {
      reset();
      //player.reset();
      timeMaster.faster();
    }
  }
}
public class InputHandler
{
  final char[][] keys = {{},{'w','W'},{'s','S'},{'d','D'},{'a','A'}};

  InputHandler()
  {    
  }

  public boolean isCorrectKey()
  {
    return isCorrectKey(0);
  }

  public boolean isCorrectKey(int t)
  {
    int pos = (timeMaster.bar_position + 8 + t)%8;
    for(int i = 0; i<keys[timeMaster.pattern[pos]].length; i++)
      if(keys[timeMaster.pattern[pos]][i] == key)
        return true;
    return false; 
  }

  public void keyPressed()
  {
    if(timeMaster.offset == 0)
    {
      for(int i = 0; i<keys[1].length; i++)
        if(keys[1][i] == key)
        {
          timeMaster.startBeat();
          break;
        }
      return;
    }

    println(timeMaster.bar_position%8 + " " + key);
    
    timeMaster.pressed = true;
    if(timeMaster.comboing)
    {
      /*int pos = timeMaster.combo[combo_count];
      boolean found = false;
      for(int i = 0; i<keys[pos].length; i++)
        if(keys[pos][i] == key)
        {
          found = true;
          break;
        }
      
      if(found == false)
      */
    }
    else
    if(isCorrectKey() == false)
      player.startTumbling();
  }
}
public void attack()
{
  if(timeMaster.pressed == false)
  {
    if(player.isManaMaxed() == false)
    {
      player.addMana();
      
      if(player.isManaMaxed() == true)
      double_hihat.trigger();
      else
      hihat.trigger();
    }
  }
  else if(inputHandler.isCorrectKey(-1))
  {
    kick.trigger();
    enemy.looseHealth(1);
  }
}

public void block()
{
  if(player.isTumbling())
  {
    player.looseHealth(1);
    player.spendMana(3);
    player.endTumbling();
    kick.trigger();
  }
  else if(timeMaster.pressed == false)
  {
    player.looseHealth(1);
    kick.trigger();
    player.startTumbling();
  }
  else if(inputHandler.isCorrectKey(-1))
  {
    snare.trigger();
  }
}

public void heal()
{
  if(player.isManaMaxed())
  {
    if(inputHandler.isCorrectKey(-1))
    {
      player.spendMana(8);
      player.gainHealth(4);
      snare.trigger();
    }
  }
  else
  {
    player.addMana();
    
    if(player.isManaMaxed() == true)
    double_hihat.trigger();
    else
    hihat.trigger();
  }
}

public void special()
{
  if(player.getMana() < 4)
    return;
  
  if(inputHandler.isCorrectKey(-1))
  {
    player.spendMana(4);

    timeMaster.comboing = true;
    timeMaster.combo_count = 0;
    low.trigger();
  }
}

public void rest()
{
  if(timeMaster.bar_position%2 == 0+1)
    if(player.isManaMaxed() == false)
    {
      player.addMana();
      
      if(player.isManaMaxed() == true)
      double_hihat.trigger();
      else
      hihat.trigger();
    }
}
public class Player
{
  final private int MAX_MANA = 10;
  final private int MAX_HEALTH = 10;
  boolean tumbling;
  int health;
  
  int mana;
  Player()
  {
    mana = 0;
    tumbling = false;
    health = MAX_HEALTH;
  }
  
  public void reset()
  {
    health = MAX_HEALTH;
    mana = 0;
  }
  
  public void addMana()
  {
    if(mana>MAX_MANA)
      return;
      
    mana++;
  }
  
  public int getHealth()
  {
    return health;
  }
  
  public void gainHealth(int amount)
  {
    health+=amount;
    if(health>=MAX_HEALTH)
    {
      health = MAX_HEALTH;
    }
  }
  
  public void looseHealth(int amount)
  {
    health-=amount;
    
    if(health<=0)
    {
      reset();
      enemy.reset();
      timeMaster.restart();
    }
  }
  
  public boolean isManaMaxed()
  {
    return mana == MAX_MANA;
  }
  
  public int getMana()
  {
    return mana;
  }
  
  public void spendMana(int amount)
  {
    mana -= amount;
    if(mana < 0)
      mana = 0;
  }
  
  public void startTumbling()
  {
    tumbling = true;
    spendMana(3);
  }
  
  public boolean isTumbling()
  {
    return tumbling;
  }
  
  public void endTumbling()
  {
    tumbling = false;
  }
}
public class TimeMaster
{
  float tolerance;
  int bar_size;
  final int[] pattern = {1,0,4,0,2,3,0,0};
  int[] combo = {2,3,2}; //2,3,4 possible
  
  int default_bpm;
  int bpm;
  int time;
  float bar_length; //in millisek
  int bar_position;
  int last_beat;
  int beat_count;
  int offset;
  int combo_count;
  boolean comboing;
  boolean awaiting_input;
  boolean pressed;
  
  TimeMaster(int bpm_)
  {
    bar_size = 4*8;
    tolerance = 250;//500;
    
    default_bpm = bpm_;
    restart();
  }
  
  public void faster()
  {
    setBPM(bpm+10);
    println(bpm);
    reset();
  }

  public void reset()
  {
    time = 0;
    offset = 0;
    bar_position = 0;
    awaiting_input = false;
    pressed = false;    
    comboing = false;
    beat_count = 0;
    last_beat = 0;
  }
  
  public void restart()
  {
    setBPM(default_bpm);
    reset();
  }
  
  public void setBPM(int bpm_)
  {
    bpm = bpm_;
    bar_length = (60*1000)/bpm;
  }
  
  public boolean isOnBeat()
  {
    boolean out = true;
    if(time > beat_count*bar_length)
      out = false;
    else if(time+tolerance < beat_count*bar_length)
      out = false;
    return out;
  }
  
  public void tick()
  {
    if(offset == 0)
      return;
    
    time = millis() - offset;
    
    if(awaiting_input && !isOnBeat())
    {
      
    }

    if(beat_count*bar_length<=time)
    { 
      beat_count++;
      bar_position=(bar_position+1)%bar_size;
      
      awaiting_input = false;
      if(comboing)
      {
        /********/
        println("comboing");
        /********/

        boolean found = false;
        for(int i = 0; i<inputHandler.keys[combo[combo_count]].length; i++)
          if(inputHandler.keys[combo[combo_count]][i] == key)
          {
            found = true;
            break;
          }
        
        if(found)
        {
          /*********/
          println("HIT");
          /*********/
          switch(combo[combo_count])
          {
            case 3:
              low.trigger();
            case 2:
              mid.trigger();
            case 4:
            default:
              high.trigger();
          }
          enemy.looseHealth(1);
          combo_count++;
          if(combo_count>=combo.length)
            comboing = false;
        }
        else
        {
          comboing = false;
          kick.trigger();
          player.startTumbling();
        }
      }
      else      
        switch(pattern[(bar_position+7)%8])
        //switch(bar_position%8)
        {
          case 1://Attack
            attack();
            break;
          case 2://Block
            block();
            break;
          case 3://special
            special();
            break;
          case 4://heal
            heal();
            break;
          case 0:
          default:
            rest();
            break;
        }
      
      pressed = false;
    }
    else if(!awaiting_input && isOnBeat())
    {
      awaiting_input = true;
    }
  }
  
  public void startBeat()
  {
    offset = millis();
  }
  
  public int GetBeatCount()
  {
    return beat_count;
  }
}
public void drawGUI()
{
  fill(0);
  rect(0,0,200+2,25+2);
  rect(0,25+3,200+2,10+2);
  rect(width-200+2,0,200+2,25+2);
  fill(RED);
  rect(1,1,player.getHealth()*20,25);
  rect(width-enemy.getHealth()*20-1,1,enemy.getHealth()*20,25);
  fill(BLUE);
  rect(1,25+4,player.getMana()*20,10);
  
  

  String txt = "false";
  if(timeMaster.awaiting_input)
  {
    fill(255);
    txt = "true";
  }
  text(timeMaster.bar_position%8, width/2, height/2);
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BeatBoxing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
