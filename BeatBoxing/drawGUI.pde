void drawGUI()
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