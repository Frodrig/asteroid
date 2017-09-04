class ScoreData implements Comparable<ScoreData> {
  public int score;
  public String name;
  
  ScoreData(int _score, String _name) {
    score = _score;
    name = _name;
  }
  
  public int compareTo(ScoreData _scoreData) {
    if (score < _scoreData.score) {
      return -1;
    } else if (score > _scoreData.score) {
      return 1;
    } else {
      return 0;
    }
  }
}