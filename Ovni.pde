enum OvniType {
  NORMAL_TYPE, 
  ELITE_TYPE
};

class Ovni extends Entity {  
  private OvniType type;

  Ovni(OvniType _type, PVector location) {
    super(location);
    type = _type;
    configure();
  }

  private void configure() {
  }

  void update() {
    updateMovement();
    updateRender();
  }

  private void updateRender() {
    noFill();
    stroke(255);
    pushMatrix();
      translate(getLocation().x, getLocation().y);
    popMatrix();
  }
}