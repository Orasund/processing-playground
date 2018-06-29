String[] starting_states;
Graph graph = new Graph();
IntDict bank;

void setup()
{
  size(50, 50);
  
  println("starting program");
  startProgram();
}

void draw()
{
}

void keyPressed()
{
  println("fing longest path...");
  longestPath();
}