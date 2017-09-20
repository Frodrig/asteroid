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
  Shooter shooter;
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
    dumping = 0.97;
    boostMag = 0.8;
    drawScale = 32;
    halfDrawScale = drawScale / 2;
    shooter = new Shooter(ShooterOriginType.PLAYER);
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
    soundManager.beginPlayingBoost();
    PVector boostAcceleration = generateVectorDirection().mult(boostMag * boostKeyPressTime);
    acceleration.add(boostAcceleration);
  }

  void shoot() {
    PVector shootDirection = generateVectorDirection().normalize();
    PVector shootLocation = location.get().add(shootDirection.get().mult(drawScale/1.2)); 
    shooter.shoot(shootDirection, shootLocation);
  }

  PVector generateVectorDirection() {
    return new PVector(cos(angle), sin(angle));
  }

  void removeAllShots() {
    shooter.removeAllShots();
  }

  boolean checkCollisionWithAsteroid(Asteroid asteroid) {
    PVector dist = PVector.sub(asteroid.location, location);
    float sumRadius = drawScale + asteroid.circleColliderRadius;
    boolean existCollision = dist.mag() < sumRadius;
    return existCollision;
  }

  void setDestroyed() {
    isDestroyed = true;
    hud.removeLive();
  }

  void update() {
    if (isDestroyed) {
      spawn();
    }
    updateLogic();
    updateOvniCollision();
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
    shooter.update();
    //      println(velocity.mag());
    if (MathUtils.isAlmostEqual(velocity.mag(), 0)) {
      soundManager.endPlayingBoost();
    }
  }

  void updateOvniCollision() {
    Ovni currentOvni = ovniManager.getCurrentOvni();
    if (currentOvni != null) {
      if (MathUtils.checkIntersect(ship.location, currentOvni.getLocation(), ship.drawScale, currentOvni.getRadius())) {
        setDestroyed();
        currentOvni.setDestroyedByShip();
      }
    }
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


  void updateRender() {
    renderShip();
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