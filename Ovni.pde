enum OvniType {
  NORMAL, 
  ELITE
};

class Ovni extends Entity {  
  private OvniType type;
  private int drawScale;
  private int radius;
  private int nextMovementUpdate;
  private int nextShootUpdate;
  private int horDirection;
  private float velocity;
  private Shooter shooter;
  private boolean isDestroyed;

  Ovni(OvniType _type, PVector location) {
    super(location);
    type = _type;
    drawScale = OvniType.NORMAL== type ? 12 : 6;
    velocity = OvniType.NORMAL == type ? 2 : 2.8;
    radius = drawScale * 2;
    horDirection = random(1) < 0.5 ? -1 : 1;
    setLocation(new PVector(horDirection < 0 ? width + radius : 0, random(height)));
    applyForce((new PVector(horDirection, 0)).normalize().mult(velocity));
    nextMovementUpdate = millis() + 2 * 1000;
    nextShootUpdate = calculeNextShootUpdate();
    shooter = new Shooter(ShooterOriginType.ENEMY);
    isDestroyed = false;
  }

  public void update() {
    updateLogic();
    updateRender();
    shooter.update();
  }
  
  public int getRadius() {
    return radius;
  }
  
  public void setDestroyedByShip() {
    setDestroyed();
    if (type == OvniType.NORMAL) {
      hud.addPoints(200);
    } else if (type == OvniType.ELITE) {
       hud.addPoints(1000);
    }
  }
  
  public void setDestroyed() {
    isDestroyed = true;
  }

  public boolean isDestroyed() {
    return isDestroyed;
  }
  
  private int calculeNextShootUpdate() {
    if (OvniType.NORMAL == type) {
      return millis() + 1000;
    } else {
      return millis() + 500;
    }
  }
  
  private void updateLogic() {
    if (millis() > nextMovementUpdate) {
      super.stopMovement();
      applyForce((new PVector(horDirection, random(-1, 1)).normalize().mult(velocity)));
      nextMovementUpdate = millis() + 1000 * 2;
    }
    if (millis() > nextShootUpdate) {
      shoot();
      nextShootUpdate = calculeNextShootUpdate();
    }
    
    super.updateMovement();
    updateEdges(); 
  }
  
  
  private void shoot() {
    if (OvniType.NORMAL == type) {
      float angle = random(TWO_PI);
      PVector direction = (new PVector(cos(angle), sin(angle))).normalize();
      shooter.shoot(direction, getLocation());
    } else if (OvniType.ELITE == type) {
      PVector direction = PVector.sub(ship.location, getLocation()).normalize();
      shooter.shoot(direction, getLocation());
    }
  }
  
  private void updateEdges() {
    if (getLocation().x > width) {
      setLocation(new PVector(0, getLocation().y));
    } else if (getLocation().x < 0) {
       setLocation(new PVector(width, getLocation().y));
    }
    
    if (getLocation().y > height) {
       setLocation(new PVector(getLocation().x, 0));
    } else if (getLocation().y < 0) {
        setLocation(new PVector(getLocation().x, height));
    }
  }
  
  private void updateRender() {
    noFill();
    stroke(255);
    //ellipse(getLocation().x, getLocation().y, getRadius(), getRadius());
    
    pushMatrix();
      translate(getLocation().x, getLocation().y);
      beginShape();
      vertex(-2 * drawScale, 0);
      vertex(-1 * drawScale, -1 * drawScale);
      vertex(-1 * drawScale, -2 * drawScale);
      vertex(1 * drawScale, -2 * drawScale);
      vertex(1 * drawScale, -1 * drawScale);
      vertex(1 * drawScale, -1 * drawScale);      
      vertex(2 * drawScale, 0);      
      vertex(1 * drawScale, 1 * drawScale);      
      vertex(0, 1 * drawScale);      
      vertex(-1 * drawScale, 1 * drawScale);      
      endShape(CLOSE);  
      line (-2 * drawScale, 0, 2 * drawScale, 0);
      line (-1 * drawScale, -1 * drawScale, 1 * drawScale, -1 * drawScale);
     // arc(0, -drawScale, drawScale*2, drawScale, -drawScale, PI);
    popMatrix();
  }
}