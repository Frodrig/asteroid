Ship ship;
StarField starField;
AsteroidField asteroidField;
HUD hud;
ScoreManager scoreManager;
boolean spaceKeyPress;
int stage;
PFont debugFont;
enum GameState {
  PRESS_START,
  PLAYING,
  GAME_OVER
};
GameState currentGameState;
PFont asteroidFont;

void settings() {
  size(1200, 568);
}

void setup() {
  //fullScreen();
  stage = 1;
  ship = new Ship();
  starField = new StarField(100, 0.5);
  hud = new HUD();
  scoreManager = new ScoreManager();
  spaceKeyPress = false;
  debugFont = createFont("Arial", 12);
  asteroidFont = createFont("Vectorb.ttf", 38);
  changeToPressStartState();
}

void draw() {
  if (currentGameState == GameState.PRESS_START) {
    updatePressStartState();
  } else if (currentGameState == GameState.PLAYING) {
    updatePlayingState();
  } else if (currentGameState == GameState.GAME_OVER) {
  }
}

void updatePressStartState() {
    background(0);  
    updatePressStartStateKeys();
    updatePressStartStateScene();
}

void updatePressStartStateKeys() {
  if (keyPressed) {
    changeToPlayingState();
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
  currentGameState = GameState.PRESS_START;
}

void changeToPlayingState() {
  asteroidField.generateAsteroids(4, 100, 50);
  hud.reset();
  currentGameState = GameState.PLAYING;
}

void changeToGameOverState() {
  changeToPressStartState();
}

void updatePlayingState() {
  background(0);  
  updatePlayingStateKeys();
  updatePlaingStateScene();
}

void updatePlayingStateKeys() {
  if (asteroidField.isFieldEmpty())
    return;
  
  if (keyPressed) {
    if (key == CODED && keyCode == LEFT) {
      ship.turnLeft();
    } else if (key == CODED && keyCode == RIGHT) {
      ship.turnRight();
    } else if (key == CODED && keyCode == UP) {
      ship.boost();
    } else if (key == ' '&& !spaceKeyPress) {
      ship.shoot();
      spaceKeyPress = true;
    }
  } else {
    spaceKeyPress = false;
  }
}

void updatePlaingStateScene() {
  starField.update();
  
  if (asteroidField.isFieldEmpty()) {
    stage += 1;
    ship.removeAllShots();
    int velocityRange = 50 + int(random(stage * 10));
    velocityRange = constrain(velocityRange, 50, 150);
    asteroidField.generateAsteroids(int(random(4, 6)), 100, velocityRange);
  } else {
    asteroidField.update();
    ship.update();
  }
  
  hud.update(); 
  
  if (hud.lives < 1) {
    changeToGameOverState();
  }
}