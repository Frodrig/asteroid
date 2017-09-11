class Shoot {
  private PVector location;
  private PVector velocity;
  private float velocityMag;
  private int endMillis;
  private int drawScale;
  private boolean endByTime;
  private boolean isFinished;
  
  Shoot(PVector _location, PVector _direction, boolean _endByTime) {
    velocityMag = 10;
    location = _location.get();
    endByTime = _endByTime;
    velocity = _direction.get().normalize().mult(velocityMag);
    if (endByTime) {
      endMillis = millis() + int(1000.0 * 0.8);
    }
    drawScale = 2;
    soundManager.playShootSound();
  }
  
  public boolean isFinished() {
    return isFinished;
  }
  
  public PVector getLocation() {
    return location;
  }
  
  public void update() {
    updateLogic();
    updateRender();
  }
  
  public void updateLogic() {
    checkFinished();
    if (!isFinished) {
      move();
    }
  }
  
  private void checkFinished() {
    if (endByTime) {
      isFinished = millis() > endMillis;
    } else {
      isFinished = location.x > width || location.x < 0 || location.y > height || location.y < 0;
    }
  }
  
  private void updateRender() {
    if (!isFinished()) {
      render();
    }
  }
  
  private void move() {
    location.add(velocity);
    updateEdgePosition();
  }
  
  private void updateEdgePosition() {
    if (endByTime) {
    }
    
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }
    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
  }
  
  private void render() {
    fill(255);
    stroke(255);
    ellipse(location.x, location.y, drawScale, drawScale);
  }
}