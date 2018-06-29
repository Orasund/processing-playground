public class Enemy
{
  final private int MAX_HEALTH = 10;
  int health;
  
  Enemy()
  {
    health = MAX_HEALTH;
  }
  
  void reset()
  {
    health = MAX_HEALTH;
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
      //player.reset();
      timeMaster.faster();
    }
  }
}