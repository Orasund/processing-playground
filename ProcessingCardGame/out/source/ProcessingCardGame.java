import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcessingCardGame extends PApplet {

String[] starting_states;
Graph graph = new Graph();
IntDict bank;

public void setup()
{
  
  
  println("starting program");
  startProgram();
}

public void draw()
{
}

public void keyPressed()
{
  println("fing longest path...");
  longestPath();
}
class Graph
{
  private  HashMap<String,Node> arr;

  Graph()
  {
    arr = new HashMap<String,Node>();
  }

  public void add(String key, String state)
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

  public boolean contains(String key)
  {
    return arr.containsKey(key);
  }

  public Node get(String key)
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

  public void add(String state)
  {
    arr.add(state);
  }

  public void increase()
  {
    label++;
  }

  public boolean increaseTo(int value)
  {
    if(label == value)
      return false;
    else
      label = value;
    return true;
  }

  public int label()
  {
    return label;
  }

  public int size()
  {
    return arr.size();
  }

  public ArrayList<String> getChildren()
  {
    return arr;
  }
}
class Rule
{
  String card;
  int cardtype;
  String[][] commands;
  
  Rule(String name,int type,String[][] commands_)
  {
    cardtype = type; //variabel
    /*card = "s";
    String[][] commands_ = 
    {
      {"removeVar","16g"},
      {"removeVar","s"}
    };
    commands = commands_;*/
    commands = commands_;
    card = name;
  }

  private HashMap<String,Void> useCommand(int i,State str)
  {
    HashMap<String,Void> out = new HashMap<String,Void>();
    switch(commands[i][0])
    {
      case "removeFuncWithAjacent":
        out = str.removeFuncWithAjacent(commands[i][1],commands[i][2]);
        break;
      case "removeFunc":
        out = str.removeFunc(commands[i][1]);
        break;
      case "removeVar":
        out = str.removeVar(commands[i][1]);
        break;
      case "removeVarAjacent":
        out = str.removeVarAjacent(commands[i][1],commands[i][2],PApplet.parseInt(commands[i][3].charAt(0)-48));
        break;
      case "addFunc":
        out = str.addFunc(commands[i][1]);
        break;
      case "addVar":
        out = str.addVar(commands[i][1]);
        break;
      default:
        println("ERROR:"+commands[i][0]+" does not exist");
    }
    return out;
  }

  public HashMap<String,Void> use(String str)
  {
    String[] temp_results;
    HashMap<String,Void> temp_results_2 = new HashMap<String,Void>();
    temp_results_2.put(str,null);
    bank = new IntDict();

    State temp_str = new State(str);
    //may Rule be used?
    switch(cardtype)
    {
      case 0://Var
        if(!temp_str.containsVar(card))
          return new HashMap<String,Void>();
        break;
      case 1://Func
        if(!temp_str.containsFunc(card))
          return new HashMap<String,Void>();
        break;
      default:
        println("Error: Cardtype "+cardtype);
        exit();
        break;
    }

    for(int k = 0; k < commands.length; k++)
    {
      temp_results = temp_results_2.keySet().toArray(new String[0]);
      temp_results_2 = new HashMap<String,Void>();
      for(int i = 0; i < temp_results.length; i++)
      {
        temp_str = new State(temp_results[i]);
        temp_results_2.putAll(useCommand(k,temp_str));
      }
    }

    return temp_results_2;
  }
}
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
  
  public String getString()
  {
    return rec_getString(0);
  }
}
public JSONObject creatingGraph(ArrayList<Rule> rules)
{
  println("**********************************");
  JSONObject out = new JSONObject();
  String[] result_array = starting_states;
  HashMap<String,Void> finished = new HashMap<String,Void>();
  bank = new IntDict();

  int i = 0;
  for(;result_array.length > 0 && i < 20; i++)
  {
    //println("--- "+i);

    HashMap<String,Void> result_set = new HashMap<String,Void>();
    for(int j = 0; j < result_array.length; j++)
    {
      if(finished.containsKey(result_array[j]))
        continue;
      
      HashMap<String,Void> temp_results = new HashMap<String,Void>();
      for(int k = 0; k < rules.size(); k++)
      {
        temp_results = rules.get(k).use(result_array[j]);
        result_set.putAll(temp_results);
        finished.put(result_array[j],null);

        String[] str_arr = temp_results.keySet().toArray(new String[0]);
        
        for(int l = 0; l<str_arr.length; l++)
        {
          out.setString(result_array[j], str_arr[l]);
          graph.add(result_array[j],str_arr[l]);
          println('"'+result_array[j]+'"'+ " -> "+'"'+str_arr[l]+'"'+",");
        }
      }
      if(graph.contains(result_array[j]) == false)
      {
        graph.add(result_array[j],"end");
        println('"'+result_array[j]+'"'+ " -> "+'"'+"end"+'"'+",");
      }
    }
    result_array = result_set.keySet().toArray(new String[0]);
  }
  println("---"+i);
  println("**********************************");
  return out;
}
public void longestPath()
{
  println("**********************************");

  ArrayList<String> result_array = new ArrayList();
  int max_moves = 0;
  ArrayList<String> longest_paths = new ArrayList();
  for(int i = 0; i < starting_states.length; i++)
  {
    result_array.add(starting_states[i]); 
  }

  while(result_array.size() > 0)
  {
    int length = result_array.size()-1;
    String name = result_array.get(length);
    Node node = graph.get(name);
    ArrayList<String> temp_array = node.getChildren();

    result_array.remove(length);
    if(temp_array.size() == 1 && temp_array.get(0).equals("end"))
    {
      if(node.label > max_moves)
      {
        max_moves = node.label;
        longest_paths.clear();
        longest_paths.add(name);
      }
      else if(node.label == max_moves)
      {
        longest_paths.add(name);
      }
    }
    else
    {
      for(int i = 0; i < temp_array.size(); i++)
      {
        if(graph.get(temp_array.get(i)).increaseTo(node.label+1) == true)
        {
          result_array.add(temp_array.get(i));
        }
      }
    }
  }

  println("max_moves:"+max_moves);
  println("final_states:");
  for(int i = 0;i < longest_paths.size(); i++)
  {
    println(longest_paths.get(i));
  }
  println("**********************************");
  
  exit();
}
public int sumOfIntArray(int[] arr)
{
  int sum = 0;
  for(int i = 0; i < arr.length; i++)
    sum += arr[i];
   return sum;
}
public void startProgram()
{
  println("loading Game...");
  JSONObject json = loadJSONObject("data/game.json");
  starting_states = json.getJSONArray("start").getStringArray();
  JSONArray cards = json.getJSONArray("card");
  ArrayList<Rule> rules = new ArrayList<Rule>();
  for(int i = 0; i < cards.size(); i++)
  {
    JSONObject item = cards.getJSONObject(i);
    String name = item.getString("name");
    int type = item.getInt("type");
    JSONArray commands_json = item.getJSONArray("commands");
    String[][] commands = new String[commands_json.size()][];
    for(int j = 0; j < commands_json.size(); j++)
    {
      commands[j] = commands_json.getJSONArray(j).getStringArray();
    }
    rules.add(new Rule(name,type,commands));
  }
  saveJSONObject(creatingGraph(rules), "data/out.json");
  println("please make sure the Graph is a-cyclic.");
  println("press any key to resume");
}
public HashMap<String,Void> useRule(String str)
{
  State temp_str = new State(str);
  //1.) remove 1 (16g)
  //2.) remove 1 (s)
  String[] temp_results = temp_str.removeVar("16g").keySet().toArray(new String[0]);
  HashMap<String,Void> temp_results_2 = new HashMap<String,Void>();
  for(int i = 0; i < temp_results.length; i++)
  {
    temp_str = new State(temp_results[i]);
    temp_results_2.putAll(temp_str.removeVar("s"));
  }
  //temp_results = temp_results_2.keySet().toArray(new String[0]);
  //temp_results_2 = new HashMap<String,Void>();

  return temp_results_2;
}
  public void settings() {  size(50, 50); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingCardGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
