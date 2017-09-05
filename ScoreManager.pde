import java.util.*; 
import java.io.File;

class ScoreManager {
  private ArrayList<ScoreData> scores;

  ScoreManager() {
    Load();
  }

  public void addScore(int _score, String _name) {
    scores.add(new ScoreData(_score, _name));
    sortScore();
    Save();
  }

  public ArrayList<ScoreData> getScores() {
    return scores;
  }

  private void Save() {
    JSONObject json = new JSONObject();
    JSONArray values = new JSONArray();
    for (int i = 0; i < scores.size(); i++) {
      ScoreData scoreEntry = scores.get(i);
      JSONObject jsonScoreEntry = new JSONObject();
      jsonScoreEntry.setString("name", scoreEntry.name);
      jsonScoreEntry.setInt("score", scoreEntry.score);
      values.setJSONObject(i, jsonScoreEntry);
    }
    json.setJSONArray("scores", values);
    saveJSONObject(json, "data/scores.json");
  }

  private void Load() {
    scores = new ArrayList<ScoreData>();
    boolean existFile = existFile();
    if (existFile) {
      JSONObject json = loadJSONObject("data/scores.json");
      if (json != null) {
        JSONArray values = json.getJSONArray("scores");
        for (int i = 0; i < values.size(); i++) {
          JSONObject scoreEntry = values.getJSONObject(i); 
          ScoreData dataEntry = new ScoreData(scoreEntry.getInt("score"), scoreEntry.getString("name"));
          scores.add(dataEntry);
        }
      }

      sortScore();
    }
  }

  private void sortScore() {
    Collections.sort(scores);
  }

  private boolean existFile() {
    File f = new File(dataPath("scores.json"));
    if (f.exists() && !f.isDirectory()) { 
      return true;
    }
    return false;
  }
}