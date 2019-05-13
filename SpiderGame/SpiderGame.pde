int W,H;
Game game;

void setup()
{
  /* main settings */
  size(400,400);
  W = width;
  H = height;
  int $size = 40;
  Wall[] walls = {
    new Wall($size,0,8*$size,$size), //Top
    new Wall(9*$size,0,$size,9*$size), //Right
    new Wall(0,0,$size,9*$size), //Left
    new Wall(0,9*$size,4*$size,$size), //Bottom 1
    new Wall(6*$size,9*$size,4*$size,$size), //Bottom 2
    new Wall(4*$size,4*$size,2*$size,2*$size), //mittle
    //new Wall($size,5*$size-$size/4,$size/2,$size/2),
    //new Wall(9*$size-$size/2,5*$size-$size/4,$size/2,$size/2)
  };
  PVector[] points1 = {
   new PVector(5*$size,10*$size),
   new PVector(5*$size,7*$size),
   new PVector(3*$size,7*$size),
   new PVector(3*$size,$size)
  };
  Route route1 = new Route(points1);
  PVector[] points2 = {
   new PVector(5*$size,10*$size),
   new PVector(5*$size,7*$size),
   new PVector(7*$size,7*$size),
   new PVector(7*$size,$size)
  };
  Route route2 = new Route(points2);
  Fly[] flys = {
    new Fly(route1,2),new Fly(route2,2),
    new Fly(route1,3),new Fly(route2,3)
  };
  Level level = new Level(walls,flys);//,lines);
  level.addLine(new Line(new PVector(5*$size,$size),new PVector(5*$size,4*$size)));
  level.addLine(new Line(new PVector($size,5*$size),new PVector(4*$size,5*$size)));
  level.addLine(new Line(new PVector(6*$size,5*$size),new PVector(9*$size,5*$size)));
  Player player = new Player($size, $size);
  game = new Game(level,player);
  
}

void draw()
{
  game.tick();
  
  game.draw();
}

void keyPressed() {
  int $speed = 2;
  switch(key)
  {
    case 'w':
    case 'W':
      for(int i=0;i<$speed;i++)
      {
        game.movePlayer(0, -1);
      }
      break;
    case 's':
    case 'S':
      for(int i=0;i<$speed;i++)
      {
        game.movePlayer(0, 1);
      }
      break;
    case 'd':
    case 'D':
      for(int i=0;i<$speed;i++)
      {
        game.movePlayer(1, 0);
      }
      break;
    case 'a':
    case 'A':
      for(int i=0;i<$speed;i++)
      {
        game.movePlayer(-1, 0);
      }
      break;
    case 'e':
    case 'E':
        game.startWave();
      break;
  }
}

void keyReleased() {
  switch(key)
  {
    case ' ':
      game.placeLineAtPlayer();
      break;
  }
}