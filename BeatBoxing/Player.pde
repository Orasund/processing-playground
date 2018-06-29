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
  
  void reset()
  {
    health = MAX_HEALTH;
    mana = 0;
  }
  
  void addMana()
  {
    if(mana>MAX_MANA)
      return;
      
    mana++;
  }
  
  int getHealth()
  {
    return health;
  }
  
  void gainHealth(int amount)
  {
    health+=amount;
    if(health>=MAX_HEALTH)
    {
      health = MAX_HEALTH;
    }
  }
  
  void looseHealth(int amount)
  {
    health-=amount;
    
    if(health<=0)
    {
      reset();
      enemy.reset();
      timeMaster.restart();
    }
  }
  
  boolean isManaMaxed()
  {
    return mana == MAX_MANA;
  }
  
  int getMana()
  {
    return mana;
  }
  
  void spendMana(int amount)
  {
    mana -= amount;
    if(mana < 0)
      mana = 0;
  }
  
  void startTumbling()
  {
    tumbling = true;
    spendMana(3);
  }
  
  boolean isTumbling()
  {
    return tumbling;
  }
  
  void endTumbling()
  {
    tumbling = false;
  }
}