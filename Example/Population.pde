class Population
{
  MrBrain mrBrain;
  float[] population;
  int _num;
  
  Population(float mutationRate,int num)
  {
    _num = num;
    mrBrain = new MrBrain(mutationRate,_num);
    
    population = new float[_num];
    for(int i = 0; i < _num; i++)
    {
      population[i] = random(26);
    }
  }
  
  float fitness(int i) {

    int amount = floor(population[i]);
    
    int sum = 0;
    for (int j = 0; j < population.length; j++)
    {
      if(floor(population[j]) == amount)
        sum++;
    }
    float out = (sum+random(1)*0.5);
    return out;
  }
  
  void move()
  {
    for(int i = 0; i < _num; i++)
    {
      MB_Dna dna = mrBrain.getDna(i);
      int sum = 0;
      for(int k = 0; k < dna.length(); k++)
        sum += dna.get(k);
      int r = floor(random(sum));
      int j = 0; 
      for(;j < dna.length(); j++)
        if(r+dna.get(j)> sum)
          break;
        else
          sum -= dna.get(j);
       
      float step = 0.05;
      switch(j)
      {
        case 0: //right
          population[i] = (population[i]+step)%26;
          break;
        case 2: //left
          population[i] = (population[i]+26-step)%26;
          break;
        case 1:
        default:
          break;
      }
    }
  }
  
  void iterate()
  {
    float[] new_fitness_pool = new float[_num];
    max_fitness = 0;
    for(int i = 0; i < population.length; i++)
    {
      float fit = fitness(i);
      if(max_fitness<fit)
      {
        max_fitness = fit;
        max_fit_char = floor(population[i]);
      }
      new_fitness_pool[i] = fit;
    }

    mrBrain.iterate(new_fitness_pool);
  }
  
  void display()
  {
    color[][] colors = {
      {170, 57, 57},
      {170, 88, 57},
      {170, 106, 57},
      {170, 130, 57},
      {170, 139, 57},
      {170, 147, 57},
      {170, 155, 57},
      {170, 164, 57},
      {159, 168, 56},
      {138, 162, 54},
      {117, 157, 52},
      {89, 149, 50},
      {44, 132, 55},
      {39, 116, 85},
      {34, 102, 102},
      {41, 81, 109},
      {45, 68, 113},
      {50, 55, 118},
      {61, 49, 117},
      {72, 46, 116},
      {82, 43, 114},
      {98, 40, 112},
      {125, 42, 104},
      {143, 48, 91},
      {170, 57, 57},
      {170, 88, 57}
    };
    
    if(max_fitness < 3)
      background(0);
    else
      background(colors[max_fit_char][0],colors[max_fit_char][1],colors[max_fit_char][2]);
    for(int i = 0; i < population.length; i++)
    {
      int size = 50;
      float sum = 0;
      MB_Dna dna = mrBrain.getDna(i);
      for(int k = 0; k < dna.length(); k++)
        sum += dna.get(k);
      float mult;
      
      for(int j = 0; j < 3; j++)
      {
        int w = size/3;
        int[][] c = new int[][]{
          {0,0,255},
          {0,255,0},
          {255,0,0}
        };
        
        if(sum == 0)
          mult = 0;
        else
          mult = (dna.get(j)/sum);

        
        //display genes
        fill(color(c[j][0],c[j][1],c[j][2]));
        rect(size*i+j*w,height/2,w,size*mult*4);
      }
      
      fill(mrBrain.getFitness(i)*20);
      rect(size*i, height/2-size/2,size,size);
      
      int[] col = colors[floor(population[i])];
      fill(color(col[0],col[1],col[2]));
      rect(size*i, height/2-size*2,size,size);
      
      fill(255);
      
      //display number
      textSize(32);
      text(char(65+floor(population[i])), size*i, height/2-size/2); 
      
      //display fitness
      textSize(10);
      text(mrBrain.getFitness(i), size*i, height/2); 
      
      textSize(10);
      text(max_fitness, 0, height-10); 
    }
  }
}