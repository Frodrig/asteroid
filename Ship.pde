class Ship {
  PVector acceleration;
  PVector velocity;
  PVector location;
  float angle;
  float angularVelocity;
  float dumping;
  float boostMag;
  float drawScale;
  float halfDrawScale; 
  Shoot[] shoots;
  int maxShoots;
  int topSpeed;
  boolean isDestroyed;
  int blinkTime;
  int blinkModeTime;
  boolean isBlinkInShowMode;
  
  Ship() {
    acceleration = new PVector();
    velocity = new PVector();
    angle = -HALF_PI;
    angularVelocity = 0.1;
    dumping = 0.96;
    boostMag = 0.8;
    drawScale = 32;
    halfDrawScale = drawScale / 2;
    maxShoots = 4;
    shoots = new Shoot[maxShoots];
    for (int i = 0; i < shoots.length; ++i) {
      shoots[i] = null;
    }
    topSpeed = 12;
    spawn();
    blinkTime = 0;
    blinkModeTime = 0;
    isBlinkInShowMode = true;
  }
  
  void turnLeft() {
    angle -= angularVelocity;
  }
  
  void turnRight() {
    angle += angularVelocity;
  }
  
  void boost() {
    PVector boostAcceleration = generateVectorDirection().mult(boostMag);
    acceleration.add(boostAcceleration);
  }
  
  void shoot() {
    for (int i = 0; i < shoots.length; ++i) {
      if (shoots[i] == null) {
        PVector shootDirection = generateVectorDirection().normalize();
        PVector shootLocation = location.get().add(shootDirection.get().mult(drawScale/1.2)); 
        shoots[i] = new Shoot(shootLocation, shootDirection);
        break;
      } 
    }
  }
  
  PVector generateVectorDirection() {
    return new PVector(cos(angle), sin(angle));
  }
  
  void removeAllShots() {
    for (int i = 0; i < shoots.length; ++i) {
      shoots[i] = null;
    }
  }
  
  boolean checkCollisionWithAsteroid(Asteroid asteroid) {
    PVector dist = PVector.sub(asteroid.location, location);
    float sumRadius = drawScale + asteroid.circleColliderRadius;
    boolean existCollision = dist.mag() < sumRadius;
    return existCollision;
  }
  
  void setDestroyed() {
    isDestroyed = true;
  }
  
  void update() {
    if (isDestroyed) {
      spawn();
    }
    updateLogic();
    updateRender();
  }
  
  void spawn() {
    location = new PVector(width/2, height/2);
    velocity.mult(0);
    acceleration.mult(0);
    isDestroyed = false;
    blinkTime = millis() + 4 * 1000;
    blinkModeTime = millis() + 200;
    isBlinkInShowMode = true;
  }
  
  void updateLogic() {
    updateShipMovement();
    updateShipEdges();
    updateShoots();
  }
  
  
  void updateShipMovement() {
    velocity.add(acceleration).mult(dumping);
    if (velocity.mag() > topSpeed) {
      velocity.normalize().mult(topSpeed);
    }
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void updateShipEdges() {
    if (location.x > width + halfDrawScale) {
      location.x = -halfDrawScale;
    } else if (location.x < -halfDrawScale) {
      location.x = width - halfDrawScale;
    }
    
    if (location.y > height + halfDrawScale) {
      location.y = -halfDrawScale;
    } else if (location.y < -halfDrawScale) {
      location.y = height - halfDrawScale;
    }
  }
  
  void updateShoots() {
    for (int i = 0; i < shoots.length; i++) {
      if (shoots[i] != null) {
        if (shoots[i].isFinished()) {
          shoots[i] = null;
        } else {
          shoots[i].updateLogic();
        }
      }
    }
  }
  
  void updateRender() {
     renderShoots();
     renderShip();
  }
 
  void renderShoots() {
    for (int i = 0; i < shoots.length; i++) {
      if (shoots[i] != null) {
        shoots[i].updateRender();
      }
    }
  }
  
  boolean isInBlinkMode() {
    return blinkTime > 0;
  }
  
  void renderShip() {
    
    if (isInBlinkMode()) {
      if (millis() > blinkTime) {
        blinkTime = 0;
      } else {
        if (millis() > blinkModeTime) {
          blinkModeTime = millis() + 200;
          isBlinkInShowMode = !isBlinkInShowMode;
        }
        if (!isBlinkInShowMode) {
          return;
        }
      }
    }
    
    fill(0);
    stroke(255);
    
    float velMag = velocity.mag();
    pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      triangle(-halfDrawScale, -halfDrawScale, drawScale/1.2, 0, -halfDrawScale, halfDrawScale);
      if (velMag > 0) {
          stroke(255, 255 * velMag);
        
        line(-halfDrawScale - 3, -halfDrawScale*0.6 - 3, -halfDrawScale - 3, halfDrawScale*0.6 + 3);
        line(-halfDrawScale - 6, -halfDrawScale*0.3 - 6, -halfDrawScale - 6, halfDrawScale*0.3 + 6);
        //line(-halfDrawScale - 9, -halfDrawScale*0.1 - 9, -halfDrawScale - 9, halfDrawScale*0.1 + 9);
      }
    popMatrix();
    
  }
  
  void renderDebug() {
    stroke(255);
    noFill();
    ellipse(location.x, location.y, drawScale * 2, drawScale * 2);
  }
  

}