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
        out = str.removeVarAjacent(commands[i][1],commands[i][2],int(commands[i][3].charAt(0)-48));
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