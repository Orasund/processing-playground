class State
{
  private ArrayList<IntDict> cards;
  
  /***************************************
  *
  *  Constructor
  *
  ****************************************/

  State(ArrayList<IntDict> cards_)
  {
    cards = new ArrayList<IntDict>();
    int n = cards_.size();
    for(int i=0; i<n; i++)
    {
      cards.add(cards_.get(i).copy());
    }
  }
  
  State(String str)
  {
    cards = new ArrayList<IntDict>();
    
    rec_constructor(str);
    reverse();
    normalize();
  }
  
  //recursive constructor
  private void rec_constructor(String str)
  {
    if(str.equals(""))
      return;
    
    int n = str.length();
    IntDict item;
    item = new IntDict();
    
    int i = 0;
    //adding the label
    for(; str.charAt(i) != '('; i++);
    item.set(str.substring(0,i),-1);
    
    i++;
    int j = i;
    //recusive
    int k = i;
    for(; i<n; i++)
    {
      if(str.charAt(i) == '{')
      k = i;
    };
    i = k;
    rec_constructor(str.substring(j,i-1));
    
    i++;
    j = i;
    for(; i<n; i++)
    {
      if(str.charAt(i) == ',' || str.charAt(i) == '}')
      {
        if(j == i)
          break;
          
        item.increment(str.substring(j,i));
        j = i+1;
        i++;
        
      }
    }
    
    cards.add(item);
    return;
  }

  /***************************************
  *
  *  Copy
  *
  ****************************************/
  public State copy()
  {
    State out = new State(cards);
    return out;
  }

  /***************************************
  *
  *  Contains
  *
  ****************************************/
  public boolean containsFunc(String str)
  {
    for(int i = 0; i < cards.size(); i++)
    {
      if(cards.get(i).keyArray()[0].equals(str))
        return true;
    }
    return false;
  }

  public boolean containsVar(String str)
  {
    for(int i = 0; i < cards.size(); i++)
    {
      String[] arr = cards.get(i).keyArray();
      for(int j = 0; j < arr.length; j++)
      {
        if(arr[j].equals(str))
          return true;
      }
    }
    return false;
  }

  /***************************************
  *
  *  Remove
  *
  ****************************************/
  public HashMap<String,Void> removeFuncWithAjacent(String str,String var)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    int n = cards.size();
    if(n == 1)
      return out;
    IntDict item;
    State temp;
    //ajacent to func
    if(cards.get(0).keyArray()[0].equals(str))
    {
      if(cards.get(0).hasKey(var))
      {
        if(cards.get(0).get(var) >= 3)
        {
          item = cards.get(0);
          cards.remove(0);
          temp = copy();
          temp.normalize();
          out.put(temp.getString(),null);
          cards.add(0,item);
        }
      }
    }
    if(cards.get(n-1).keyArray()[0].equals(str))
    {
      if(cards.get(n-1).hasKey(var))
      {
        if(cards.get(n-1).get(var) >= 3)
        {
          item = cards.get(n-1);
          cards.remove(n-1);
          temp = copy();
          temp.normalize();
          out.put(temp.getString(),null);
          cards.add(item);
        }
      }
    }

    return out;
  }

  public HashMap<String,Void> removeFunc(String str)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    int n = cards.size();
    IntDict item;
    State temp;
    if(cards.get(0).keyArray()[0].equals(str))
    {
      if(cards.get(0).size() == 1)
      {
        item = cards.get(0);
        cards.remove(0);
        temp = copy();
        temp.normalize();
        out.put(temp.getString(),null);
        cards.add(0,item);
      }
    }
    if(cards.get(n-1).keyArray()[0].equals(str))
    {
      if(cards.get(n-1).size() == 1)
      {
        item = cards.get(n-1);
        cards.remove(n-1);
        temp = copy();
        temp.normalize();
        out.put(temp.getString(),null);
        cards.add(item);
      }
    }
    return out;
  }

  public HashMap<String,Void> removeVar(String str)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    int n = cards.size();
    for(int i = 0; i<n; i++)
    {
      State temp;
      int max = 2;
      if(cards.get(i).hasKey(str))
      {
        if(cards.get(i).get(str) > 1)
          cards.get(i).sub(str, 1);
        else
          cards.get(i).remove(str);
        temp = copy();
        temp.normalize();
        out.put(temp.getString(),null);
        cards.get(i).increment(str);
      }
    }
    return out;
  }

  public HashMap<String,Void> removeVarAjacent(String str,String func,int amount)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    int n = cards.size();
    for(int i = 0; i<n; i++)
    {
      State temp;
      //ajacent to func
      if(!cards.get(i).keyArray()[0].equals(func))
        continue;

      if(cards.get(i).hasKey(str))
      {
        if(cards.get(i).get(str) < amount)
          continue;
        else if(cards.get(i).get(str) > amount)
          cards.get(i).sub(str, amount);
        else
          cards.get(i).remove(str);
        temp = copy();
        temp.normalize();
        out.put(temp.getString(),null);
        cards.get(i).add(str, amount);
      }
    }
    return out;
  }

  /***************************************
  *
  *  Add
  *
  ****************************************/
  public HashMap<String,Void> addFunc(String str)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    IntDict item = new IntDict();
    item.add(str,-1);
    int n = cards.size();
    State temp;
    //add at back
    if(n == 0 || 3>sumOfIntArray(cards.get(n-1).valueArray())+1)
    {
      
      cards.add(item);
      temp = copy();
      temp.normalize();
      out.put(temp.getString(),null);
      cards.remove(n);
    }
    
    //add in front
    int max = 2;
    if(n == 1)
      max++;
    if(n == 0 || max>=sumOfIntArray(cards.get(0).valueArray())+1)
    {
      cards.add(0,item);
      temp = copy();
      temp.normalize();
      out.put(temp.getString(),null);
      cards.remove(0);
    }
    return out;
  }

  public HashMap<String,Void> addVar(String str)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    int n = cards.size();
    State temp;
    for(int i = 0; i<n; i++)
    {
      int max = 1;
      if(i == 0 || i == n-1)
        max++;
      if(n == 1)
        max++;
      if(max>=sumOfIntArray(cards.get(i).valueArray())+1)
      {
         cards.get(i).increment(str);
         temp = copy();
         temp.normalize();
         out.put(temp.getString(),null);
         if(cards.get(i).get(str) > 1)
           cards.get(i).sub(str, 1);
         else
           cards.get(i).remove(str);
      }
    }
    return out;
  }

  /***************************************
  *
  *  normalize
  *
  ****************************************/
  
  public void normalize()
  {
    int n = cards.size();
    
    if(n%2==1)
      cards.get(floor(n/2)).sortValues();
    
    if(n == 1)
      return;
    
    for(int i = 0; i < floor(n/2); i++)
    {
      cards.get(i).sortValues();
      cards.get(n-i-1).sortValues();
      String[] keys_0 = cards.get(i).keyArray();
      int[] values_0 = cards.get(i).valueArray();
      String[] keys_n = cards.get(n-i-1).keyArray();
      int[] values_n = cards.get(n-i-1).valueArray();

      //function name order
      if(!isFuncBiggerEqual(keys_0[0],keys_n[0]))
      {
        reverse();
        return;
      }
      else if(!keys_0[0].equals(keys_n[0]))
        return;

      //var name order
      int[] order_0 = sortByVarOrder(keys_0);
      int[] order_n = sortByVarOrder(keys_n);
      int len = min(keys_0.length,keys_n.length)-1;
      for(int j = 0; j < len; j++)
      {
        if(!isVarBiggerEqual(keys_0[order_0[j]], keys_n[order_n[j]]))
        {
          reverse();
          return;
        }
        else if(!keys_0[order_0[j]].equals(keys_n[order_n[j]]))
          return;
        if(values_0[order_0[j]] < values_n[order_n[j]])
        {
          reverse();
          return;
        }
        else if(values_n[order_n[j]] < values_0[order_0[j]])
          return;
      }
      
      if(keys_n.length > keys_0.length) //<>//
      {
        reverse();
        return;
      }
      else if(keys_0.length > keys_n.length)
        return;
    }
  }
  
  /***************************************
  *
  *  Order
  *
  ****************************************/
  
  private int[] sortByVarOrder(String[] vars)
  {
    int[] order = {1,2,3};
    if(vars.length < 2+1)
      return order;
    if(isVarBiggerEqual(vars[1],vars[2]))
    {
      order[0] = 2;
      order[1] = 1;
    }
    if(vars.length < 3+1)
      return order;
    if(isVarBiggerEqual(vars[order[1]],vars[3]))
    {
      order[2] = order[1];
      order[1] = 3;
      if(isVarBiggerEqual(vars[order[0]],vars[order[1]]))
      {
        order[1] = order[0];
        order[0] = 3;
      }
    }
    return order;
  }
  
  private boolean isFuncBiggerEqual(String a, String b)
  {
    if(a.equals(b))
      return true;

    return (a.compareTo(b) < 0);
      
    /*IntDict func_order = new IntDict();
    func_order.add("B",1);
    func_order.add("C",2);
    
    return (func_order.get(a)>=func_order.get(b));*/
  }
  
  private boolean isVarBiggerEqual(String a, String b)
  {
    if(a.equals(b))
      return true;
    
    return (a.compareTo(b) < 0);
      
    /*IntDict func_order = new IntDict();
    func_order.add("s",1);
    func_order.add("i",2);
    func_order.add("16g",3);
    
    return (func_order.get(a)>=func_order.get(b));*/
  }
  
  /***************************************
  *
  *  reverse
  *
  ****************************************/
  
  private void reverse()
  {
    IntDict item;
    int n = cards.size();
    for(int i = 0; i <floor(n/2); i++)
    {
      item = cards.get(i);
      cards.set(i,cards.get(n-i-1));
      cards.set(n-i-1,item);
    }
  }
  
  /***************************************
  *
  *  getString
  *
  ****************************************/
  
  //recursive getString
  private String rec_getString(int i)
  {
    String out = "";
    int n = cards.size();
    if(i >= n)
      return out;
      
    IntDict item = cards.get(i);
    String[] keys = item.keyArray();
    int[] values = item.valueArray();
    out = out.concat(keys[0]+"(");
    String rec_str = rec_getString(i+1);
    out = out.concat(rec_str);
    out = out.concat(",{");
    for(int j = 1; j < keys.length; j++)
    {
      for(int k = 0; k < values[j]; k++)
      {
        out = out.concat(keys[j]);
        if(k<values[j]-1)
          out = out.concat(",");
      }
      if(j<keys.length-1)
        out = out.concat(",");
    }
    out = out.concat("})");
    return out;
  }
  
  String getString()
  {
    return rec_getString(0);
  }
}