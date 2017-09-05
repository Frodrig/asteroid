class Asteroid {
  AsteroidField owner;
  float size;
  float halfSize;
  float circleColliderRadius;
  PVector acceleration;
  PVector velocity;
  PVector location;
  ArrayList<PVector> allVertex;
  boolean hitted;
  int fadeAlpha;
  
  
  Asteroid(AsteroidField _owner, float _size, float _topSpeed, PVector _location) {
    owner = _owner;
    init(_size, _topSpeed, _location);
  }
  
  Asteroid(AsteroidField _owner, float _size, float _topSpeed) {
    owner = _owner;
    PVector location = null;
    do {
       location = generateRandomFreeLocation(_size);
    } while (location == null);
    init(_size, _topSpeed,  location);
  }
  
  void init(float _size, float _topSpeed, PVector _location) {
    acceleration = new PVector();
    velocity = new PVector();
    location = _location.get();
    size = _size;
    halfSize = size / 2;
    generateAllVertex();
    //applyForce(new PVector(random(_topSpeed), random(_topSpeed)));
    PVector dirToShip = ship.location.get().sub(location).normalize();
    PVector dirToShipWhithNoise = PVector.add(dirToShip, (new PVector(cos(TWO_PI), sin(TWO_PI))).normalize().mult(0.2)).normalize();
   // PVector forceToShip = PVector.add(location, ).normalize();
    applyForce(dirToShipWhithNoise.mult(random(_topSpeed/2, _topSpeed)));
    hitted = false;
    fadeAlpha = 0;
  }
  
  void resetForces() {
    acceleration.mult(0);
  }
  
  PVector generateRandomFreeLocation(float _size) {
    PVector retLocation = null;
    
    float initialPositionDice = random(1);
    if (initialPositionDice > 0.75) {
       retLocation = new PVector(-_size, random(height));
    } else if (initialPositionDice > 0.5) {
       retLocation = new PVector(width + _size, random(height));
    } else if (initialPositionDice > 0.25) {
      retLocation = new PVector(random(width), height + _size);
    } else {
      retLocation = new PVector(random(width), -_size);
    }
    
    if (owner.findAsteroidAtPosition(retLocation, _size) != null) {
      return null;
    }
    
    return retLocation;
  }
  
  void generateAllVertex() {
    circleColliderRadius = 0;
    allVertex = new ArrayList<PVector>();
    for (float angle = 0; angle < TWO_PI; angle += random(HALF_PI/2)) {
      PVector vertex = new PVector(cos(angle), sin(angle)).mult(random(0.5, 1));
      float distFromLocation = vertex.mag() * size;
      if (distFromLocation > circleColliderRadius) {
        circleColliderRadius = distFromLocation;
      }  
      allVertex.add(vertex);
    }
  }
  
  void applyForce(PVector force) {
    PVector adjustedForce = force.get().div(size);
    acceleration.add(adjustedForce);
  }
   
  void update() {
    updateLogic();
    updateAsteroidEdges();
    updateRender();
  }
   
  boolean checkIntersect(PVector point) {
    if (PVector.sub(point, location).mag() < circleColliderRadius) {
      return true;
    }
    
    return false;
  }
    
  void updateLogic() {
    updateMove();
    if (currentGameState == GameState.PLAYING) {
      updateShootingCheck();  
      updateShipCollisionCheck();
    }
  }
  
  void updateMove() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void updateShootingCheck() {
     for (int i = 0; i < ship.shoots.length; ++i) {
      if (ship.shoots[i] != null && checkIntersect(ship.shoots[i].location)) {
        hitted = true;
        ship.shoots[i] = null;
        break;
      }
    }
  }
  
  void updateShipCollisionCheck() {
    if (!ship.isInBlinkMode() && ship.checkCollisionWithAsteroid(this)) {
      ship.setDestroyed();
      hud.removeLive();
      hitted = true;
    }
  }
   
  void updateAsteroidEdges() {
    if (location.x > width + halfSize) {
      location.x = -halfSize;
    } else if (location.x < -halfSize) {
      location.x = width - halfSize;
    }
    
    if (location.y > height + halfSize) {
      location.y = -halfSize;
    } else if (location.y < -halfSize) {
      location.y = height - halfSize;
    }
   }
  
  void updateRender() {
    if (fadeAlpha < 255) {
      fadeAlpha += 5;
    }

    fill(0);  
    if (currentGameState == GameState.PRESS_START || currentGameState == GameState.GAME_OVER) {
      stroke(255, 55);
    } else {
      stroke(255 * (hitted ? 0.5 : 1), fadeAlpha);
    }
    
    pushMatrix();
    translate(location.x, location.y);
    beginShape();
    for (PVector vertex : allVertex) {
      vertex(vertex.x * size, vertex.y * size);
    }
    endShape(CLOSE);
    popMatrix();
    
    //renderDebug();
  }
  
  void renderDebug() {
    stroke(255);
    noFill();
    ellipse(location.x, location.y, circleColliderRadius * 2, circleColliderRadius  * 2);
    PVector dirShip = ship.location.get().sub(location);
    line(location.x, location.y, location.x + dirShip.x, location.y + dirShip.y); 
    textFont(debugFont);
    stroke(255);
    fill(255);
    text(circleColliderRadius, location.x, location.y + 10);
  }

}