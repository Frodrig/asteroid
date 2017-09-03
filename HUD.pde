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
    updateRender();
  }
  
  void updateRender() {
    if (currentGameState == GameState.PRESS_START) {
      textFont(asteroidFont, 64);
      stroke(255);
      fill(255);
      textAlign(CENTER);
      text("Press any key to start", width/2, height/2);

    } else  if (currentGameState == GameState.PLAYING) {
      textFont(asteroidFont);
      textAlign(LEFT);
      stroke(255);
      fill(255);
      text(score, 10, 50);
      for (int i = 0; i < lives; i++) {
        drawShipAt(20 + i * 20, 80);
      }
    }
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