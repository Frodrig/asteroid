class Shoot {
  PVector location;
  PVector velocity;
  float velocityMag;
  int endMillis;
  int drawScale;
  
  Shoot(PVector _location, PVector _direction) {
    velocityMag = 10;
    location = _location.get();
    velocity = _direction.get().normalize().mult(velocityMag);
    endMillis = millis() + int(1000.0 * 0.8);
    drawScale = 2;
  }
  
  boolean isFinished() {
    boolean isByTime = millis() > endMillis;
    boolean is = isByTime;
   
    return is;
  }
  
  void updateLogic() {
    if (!isFinished()) {
      move();
    }
  }
  
  void updateRender() {
    if (!isFinished()) {
      render();
    }
  }
  
  void move() {
    location.add(velocity);
    updateEdgePosition();
  }
  
  void updateEdgePosition() {
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
  
  void render() {
    fill(255);
    stroke(255);
    ellipse(location.x, location.y, drawScale, drawScale);
  }
}