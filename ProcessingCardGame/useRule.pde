HashMap<String,Void> useRule(String str)
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