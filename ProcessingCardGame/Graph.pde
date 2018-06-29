class Graph
{
  private  HashMap<String,Node> arr;

  Graph()
  {
    arr = new HashMap<String,Node>();
  }

  void add(String key, String state)
  {
    if(!arr.containsKey(key))
    {
      Node s = new Node();
      s.add(state);
      arr.put(key,s);
    }
    else
    {
      Node s = arr.get(key);
      s.add(state);
    }
  }

  boolean contains(String key)
  {
    return arr.containsKey(key);
  }

  Node get(String key)
  {
    Node s = arr.get(key);
      return s;
  }
}

class Node
{
  private ArrayList<String> arr;
  int label;
  
  Node()
  {
    arr = new ArrayList<String>();
    label = 0;
  }

  void add(String state)
  {
    arr.add(state);
  }

  void increase()
  {
    label++;
  }

  boolean increaseTo(int value)
  {
    if(label == value)
      return false;
    else
      label = value;
    return true;
  }

  int label()
  {
    return label;
  }

  int size()
  {
    return arr.size();
  }

  ArrayList<String> getChildren()
  {
    return arr;
  }
}