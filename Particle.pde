class Particle extends Entity {
  float endTime;
  
  Particle(PVector _location, float _durationSecs, PVector _force) {
    super(_location);
    endTime = millis() + _durationSecs * 1000;
    applyForce(_force);
  }
  
  public void update() {
    if (!isFinished()) {
      super.updateMovement();
      strokeWeight(1.5);
      stroke(255, 255 * getPercentageOfLiveTime());
      noFill();
      ellipse(super.getLocation().x, super.getLocation().y, 1, 1);
    }
  }
  
  public boolean isFinished() {
    boolean isFinished = millis() > endTime;
    return isFinished;
  }
  
  public float getPercentageOfLiveTime() {
    float percentage = min(1.0, 1.0 - millis() / endTime);
    return percentage;
  }
}