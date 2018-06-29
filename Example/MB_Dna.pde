class MB_Dna
{
  private int[] _genes;
  private int len;

  MB_Dna()
  {
    len = 3;
    _genes = new int[len];
    for (int i = 0; i < _genes.length; i++) {
      _genes[i] = floor(random(1,100));
    }
  }

  //Copy Constructor
  MB_Dna(int[] genes)
  {
    _genes = new int[genes.length];
    for(int i = 0; i < genes.length; i++)
      _genes[i] = genes[i];
  }
  
  MB_Dna copy()
  {
    MB_Dna out = new MB_Dna(_genes);
    return out;
  }

  int get(int i)
  {
    return _genes[i];
  }

  int length()
  {
    return _genes.length;
  }
  
  //[full] Crossover
  MB_Dna crossover(MB_Dna partner) {
    MB_Dna child = new MB_Dna();
    int midpoint = int(random(_genes.length));
    for (int i = 0; i < _genes.length; i++) {
      if (i > midpoint) child._genes[i] = _genes[i];
      else              child._genes[i] = partner._genes[i];
    }
    return child;
  }
  //[end]
  
  void mutate(float mutationRate) {
    // Looking at each gene in the array
    for (int i = 0; i < _genes.length; i++) {
      if (random(1) < mutationRate) {
        // Mutation, a new random character
        _genes[i] = floor(random(1,100));
        if(_genes[i] < 1)
          _genes[i] = 1;
        else if(_genes[i] > 9)
          _genes[i] = 9;
      }
    }
  }
}