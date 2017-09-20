import ddf.minim.*; //<>//

Minim minim;

Ship ship;
StarField starField;
AsteroidField asteroidField;
HUD hud;
ScoreManager scoreManager;
OvniManager ovniManager;
SoundManager soundManager;
boolean spaceKeyPressed;
float boostKeyPressTime;
int stage;
PFont debugFont;
enum GameState {
  PRESS_START, 
    PLAYING, 
    GAME_OVER
};
GameState currentGameState;
PFont asteroidFontBig;
PFont asteroidFontMed;
PFont arialFont;
String curScoreName;
boolean curScoreNameKeyPressed;
int auxiliarTimer;
boolean shouldDrawHighScores;

void settings() {
  size(962, 720);
}

void setup() {
  //fullScreen();
  stage = 1;
  minim = new Minim(this);
  ship = new Ship();
  starField = new StarField(100, 0.5);
  hud = new HUD();
  scoreManager = new ScoreManager();
  ovniManager = new OvniManager();
  soundManager = new SoundManager();
  spaceKeyPressed = false;
  boostKeyPressTime = 0;
  debugFont = createFont("Arial", 12);
  asteroidFontBig = createFont("Vectorb.ttf", 64);
  asteroidFontMed = createFont("Vectorb.ttf", 32);
  arialFont = createFont("Arial", 12);
  changeToPressStartState();  
}

void draw() {  
  if (currentGameState == GameState.PRESS_START) {
    updatePressStartState();
  } else if (currentGameState == GameState.PLAYING) {
    updatePlayingState();
  } else if (currentGameState == GameState.GAME_OVER) {
    updateGameOverState();
  }
  textFont(arialFont);
  fill(255);
  text(frameRate, 50, height - 30);
  text("keypressed: " + keyPressed, 50, height-60);
}

void updatePressStartState() {
  if (millis() > auxiliarTimer) {
      if (scoreManager.getScores().size() > 0) {
        shouldDrawHighScores = !shouldDrawHighScores;
        if (shouldDrawHighScores) {
          auxiliarTimer = millis() + 8000;
        } else {
          auxiliarTimer = millis() + 3000;
        }
      } else {
        shouldDrawHighScores = false;
        auxiliarTimer = millis() + 3000;
      }
    }
  updatePressStartStateKeys();
  updatePressStartStateScene();
}

void updatePressStartStateKeys() {
  if (keyPressed) {
    changeToPlayingState();
  } else {
    
  }
}

void updatePressStartStateScene() {
  background(0);
  starField.update();
  asteroidField.update();
  hud.update();
}

void changeToPressStartState() {
  asteroidField = new AsteroidField(6, 100, 50);
  auxiliarTimer = millis() + 3000;
  shouldDrawHighScores = false;
  currentGameState = GameState.PRESS_START;
  keyPressed = false;
}

void changeToPlayingState() {
  asteroidField.generateAsteroids(4, 100, 50);
  hud.reset();
  ovniManager.reset();
  currentGameState = GameState.PLAYING;
  keyPressed = false;
}

void changeToGameOverState() {
  currentGameState = GameState.GAME_OVER;

  curScoreName = "";
  curScoreNameKeyPressed = false;
  //changeToPressStartState();
  keyPressed = false;
}

void updatePlayingState() {
  background(0);  
  updatePlayingStateKeys();
  updatePlayingStateScene();
}

void updatePlayingStateKeys() {
  if (asteroidField.isFieldEmpty() && !ovniManager.existCurrentOvni())
    return;

  if (keyPressed) {
    if (key == CODED && keyCode == LEFT) {
      ship.turnLeft();
    } else if (key == CODED && keyCode == RIGHT) {
      ship.turnRight();
    } else if (key == CODED && keyCode == UP) {
      ship.boost();
      boostKeyPressTime += 0.006;
      boostKeyPressTime = constrain(boostKeyPressTime, 0, 1);
    } else if (key == ' '&& !spaceKeyPressed) {
      ship.shoot();
      spaceKeyPressed = true;
    }
  } else {
    spaceKeyPressed = false;
    boostKeyPressTime = 0;
  }
}

void updatePlayingStateScene() {
  starField.update();

  if (asteroidField.isFieldEmpty() && !ovniManager.existCurrentOvni()) {
    stage += 1;
    ship.removeAllShots();
    int velocityRange = 50 + int(random(stage * 10));
    velocityRange = constrain(velocityRange, 50, 150);
    asteroidField.generateAsteroids(int(random(4, 6)), 100, velocityRange);
    ovniManager.reset();
  } else {
    asteroidField.update();
    ship.update();
    ovniManager.update();
  }

  hud.update(); 

  if (hud.lives < 1) {
    changeToGameOverState();
  }
}

void updateGameOverState() {
  background(0);  
  updateGameOverStateKeys();
  updateGameOverStateScene();
}

void updateGameOverStateKeys() {
  if (keyPressed) {
    if (!curScoreNameKeyPressed) {
      if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
        if (curScoreName.length() < 10) {
          curScoreName += key;
          curScoreName.toUpperCase();
        }
      } else if (key == BACKSPACE) {
        if (curScoreName.length() > 0) {
          curScoreName = curScoreName.substring(0, curScoreName.length() - 1);
        }
      } else if (key == ENTER && curScoreName.length() > 0) {
        scoreManager.addScore(hud.score, curScoreName);
        changeToPressStartState();
        
      }
    }
    curScoreNameKeyPressed = true;
  } else {
    curScoreNameKeyPressed = false;
  }
}

void updateGameOverStateScene() {
  background(0);
  starField.update();
  asteroidField.update();
  hud.update();
}