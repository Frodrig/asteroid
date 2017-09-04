class Entity {
  private PVector location;
  private PVector acceleration;
  private PVector velocity;
  private float mass;
  
  Entity(PVector _location) {
    location = _location.get();
    acceleration = new PVector();
    velocity = new PVector();
    mass = 1;
  }
  
  Entity(PVector _location, PVector _acceleration, PVector _velocity, float _mass) {
    location = _location.get();
    acceleration = _acceleration.get();
    velocity = _velocity.get();
    mass = _mass;
  }
  
  PVector getLocation() {
    return location.get();
  }
  
  PVector getAcceleration() {
    return acceleration.get();
  }
  
  PVector getVelocity() {
    return velocity.get();
  }
  
  float getMass() {
    return mass;
  }
  
  void setLocation(PVector _location) {
    location = _location.get();
  }
  
  void resetVelocity() {
    velocity.mult(0);
  }
  
  void resetForces() {
    acceleration.mult(0);
  }
  
  void stopMovement() {
    resetVelocity();
    resetForces();
  }
  
  void applyForce(PVector force) {
    PVector adjustedForce = force.get().div(mass);
    acceleration.add(adjustedForce);
  }
  
  void updateAgent() {
    velocity.add(acceleration);
    location.add(velocity);
    
    acceleration.mult(0);
  }
}