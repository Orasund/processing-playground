void attack()
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

void block()
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

void heal()
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

void special()
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

void rest()
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