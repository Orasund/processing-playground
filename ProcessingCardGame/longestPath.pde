void longestPath()
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