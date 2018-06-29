Population population;

int counter = 0;
int max = 1;
int iterate_intervall = 10;
float max_fitness = 0;
int max_fit_char = 1;

void setup()
{
  size(1200,300);
  float mutationRate = 0.005;
  population = new Population(mutationRate,24);
}

void draw()
{
  population.display();
  
  counter=(counter+1);
  if(counter%iterate_intervall == 0)
    population.iterate();
  if(counter%max == 0)
    population.move();
}