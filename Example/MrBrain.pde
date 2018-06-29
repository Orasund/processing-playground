class MrBrain
{
  private float _mutation_rate;
  private int _creature_count;
  private float[] _fitness_pool;
  private int[] _population_pool;
  private MB_Dna[] _dna_pool;
  private int _max_population = 1000;
  private float _fitness_sum;
  private int _population_sum;
  
  MrBrain(float mutation_rate,int creature_count)
  {
    _mutation_rate = mutation_rate;
    _creature_count = creature_count;
    
    _fitness_pool = new float[_creature_count];
    _population_pool = new int[_creature_count];
    _dna_pool = new MB_Dna[_creature_count];
    _fitness_sum = 0;
    _population_sum = 0;
    for(int i = 0; i < _creature_count; i++)
    {
      _fitness_pool[i] = 1;
      _fitness_sum += _fitness_pool[i];
      
      _population_pool[i] = floor(_max_population/_creature_count);
      _population_sum += _population_pool[i];
      _dna_pool[i] = new MB_Dna();
    }
  }
  
  public void iterate(float[] fitness)
  {
    updateFitness(fitness);
    updatePopulation();
    reproduction();
  }
  
  public MB_Dna getDna(int i)
  {
    return _dna_pool[i].copy();
  }
  
  public float getFitness(int i)
  {
    return _fitness_pool[i];
  }
  
  public float getPopulation(int i)
  {
    return _population_pool[i];
  }
  
  /******************************************
  *
  *  P R I V A T E   F U N C T I O N S
  *
  *******************************************/
  
  private void updateFitness(float[] fitness)
  {
    _fitness_sum = 0;
    for(int i = 0; i < _creature_count; i++)
    {
      _fitness_pool[i] = fitness[i];
      _fitness_sum += _fitness_pool[i];
    }
  }
  
  private void updatePopulation()
  {
    _population_sum = 0;
    for(int i = 0; i < _creature_count; i++)
    {
      _population_pool[i] = floor(_max_population*(_fitness_pool[i]/_fitness_sum));
      _population_sum += _population_pool[i];
    }
  }
  
  private int randomFromPool(float pool[],float sum)
  {
    int l = pool.length;
    int r = floor(random(sum));
    float temp_sum = sum;
    int i = 0;
    for(; i < l; i++)
    {
      if(r+pool[i]>=temp_sum)
        break;
      temp_sum-=pool[i];
    }
    return i;
  }
  
  private int randomFromPool(int pool[],int sum)
  {
    int l = pool.length;
    float new_pool[] = new float[l];
    for(int i = 0; i < l; i++)
    {
      new_pool[i] = pool[i];
    }
    return randomFromPool(new_pool,sum);
  }
  
  private int randomFromPopulation()
  {
    return randomFromPool(_population_pool,_population_sum);
  }
  
  private void reproduction()
  {
    MB_Dna[] temp_dna_pool = new MB_Dna[_creature_count];
    for(int i = 0; i < _creature_count; i++)
    {
      MB_Dna partnerA = _dna_pool[randomFromPopulation()];
      MB_Dna partnerB = _dna_pool[randomFromPopulation()];
      MB_Dna child = partnerA.crossover(partnerB);
      child.mutate(_mutation_rate);
      temp_dna_pool[i] = child;
    }
    for(int i = 0; i < _creature_count; i++)
    {
      _dna_pool[i] = temp_dna_pool[i];
    }
  }
}