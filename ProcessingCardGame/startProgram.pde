void startProgram()
{
  println("loading Game...");
  JSONObject json = loadJSONObject("data/tier1.json");
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