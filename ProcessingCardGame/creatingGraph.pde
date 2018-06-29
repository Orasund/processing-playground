JSONObject creatingGraph(ArrayList<Rule> rules)
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