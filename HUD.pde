class HUD {
  int score ;
  int scoreForNewLive;
  int lives;
  int drawShipLiveScale;
  int halfDrawShipLiveScale;

  HUD() {
    reset();
    drawShipLiveScale = 16;
    halfDrawShipLiveScale = drawShipLiveScale / 2;
  }

  void addPointsByDestroyAsteroid(float radius) {
    if (radius > 90) {
      addPoints(20);
    } else if (radius > 40) {
      addPoints(50);
    } else {
      addPoints(100);
    }
  }

  void addPoints(int points) {
    score += points;
    scoreForNewLive += points;
    if (scoreForNewLive >= 10000) {
      scoreForNewLive = 10000 - scoreForNewLive;
      lives++;
    }
  }

  void removeLive() {
    if (lives > 0) {
      lives--;
    }
  }

  void reset() {
    score = 0;
    scoreForNewLive = 0;
    lives = 3;
  }

  void update() {
    switch (currentGameState) {
    case PRESS_START: 
      {
        updatePressStartRender();
      } 
      break;
    case PLAYING: 
      {
        updatePlayingRender();
      } 
      break;
    case GAME_OVER: 
      {
        updateGameOverRender();
      } 
      break;
    }
  }

  void updatePressStartRender() {
    if (shouldDrawHighScores) {
      textFont(asteroidFontBig);
      stroke(255);
      fill(255);
      textAlign(CENTER);
      text("High Scores", width/2, 100);

      textFont(asteroidFontMed);
      stroke(255);
      fill(255);
      textAlign(LEFT);
      ArrayList<ScoreData> scores = scoreManager.getScores();
      for (int i=0; i < min(10, scores.size()); ++i) {
        text(convertToNumericString(i+1, 2) + "." + " " + convertToNumericString(scores.get(i).score, 7) + " - " + scores.get(i).name, width/5, 170 + 40*i);
      }
      
    } else {
      textFont(asteroidFontBig, 48);
      stroke(255);
      fill(255);
      textAlign(CENTER);
      text("Press any key to start", width/2, height/2);
    }
  }
  
  String convertToNumericString(int amount, int maxSize) {
    String retStr = "";
    String amountStr = "" + amount;
    for (int i = 0; i < maxSize - amountStr.length(); ++i) {
      retStr = retStr + "0";
    }
    retStr = retStr + amountStr;
    return retStr; 
  }

  void updatePlayingRender() {
    textFont(asteroidFontBig);
    textAlign(LEFT);
    stroke(255);
    fill(255);
    text(score, 10, 70);
    for (int i = 0; i < lives; i++) {
      drawShipAt(20 + i * 20, 100);
    }
  }

  void updateGameOverRender() {
    textFont(asteroidFontBig);
    stroke(255);
    fill(255);
    textAlign(CENTER);
    text("Your score", width/2, height/3);
    textFont(asteroidFontBig, 64);
    textAlign(CENTER);
    text(this.score, width/2, height/2);
    textFont(asteroidFontBig, 64);
    textAlign(LEFT);
    text(">" + curScoreName, width/4, 100 + height/2);
  }
  
  void drawShipAt(int x, int y) {
    stroke(155);
    noFill();
    pushMatrix();
    translate(x, y);
    rotate(-HALF_PI);
    triangle(-halfDrawShipLiveScale, -halfDrawShipLiveScale, drawShipLiveScale/1.2, 0, -halfDrawShipLiveScale, halfDrawShipLiveScale);
    popMatrix();
  }
}