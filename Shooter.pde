enum ShooterOriginType {
  PLAYER, 
    ENEMY, 
    NONE
};

class Shooter {
  private Shoot[] shoots;
  private ShooterOriginType origin;
  private int maxShoots;

  public Shooter(ShooterOriginType _origin) {
    origin = _origin;
    maxShoots = _origin == ShooterOriginType.PLAYER ? 4 : 8;
    shoots = new Shoot[maxShoots];
    for (int i = 0; i < shoots.length; ++i) {
      shoots[i] = null;
    }
  }

  public void shoot(PVector _direction, PVector _location) {
    for (int i = 0; i < shoots.length; ++i) {
      if (shoots[i] == null) {
        PVector shootDirection = _direction.get().normalize();
        PVector shootLocation = _location.get(); 
        shoots[i] = new Shoot(shootLocation, shootDirection, true);
        break;
      }
    }
  }

  public void removeAllShots() {
    for (int i = 0; i < shoots.length; ++i) {
      shoots[i] = null;
    }
  }

  public void update() {
    updateLogic();
    updateCollisionChecks();
    updateRender();
  }

  private void updateLogic() {
    for (int i = 0; i < shoots.length; i++) {
      if (shoots[i] != null) {
        if (shoots[i].isFinished()) {
          shoots[i] = null;
        } else {
          shoots[i].updateLogic();
        }
      }
    }
  }

  private void updateCollisionChecks() {
    updateAsteroidCollisionChecks();
    updateOvniCollisionChecks();
    updateShipCollisionChecks();
  }

  private void updateAsteroidCollisionChecks() {
    for (int i = 0; i < shoots.length; i++) {
      if (shoots[i] != null) {
        for (Asteroid asteroid : asteroidField.asteroids) {
          if (asteroid != null && !asteroid.isHitted()) {
            if (MathUtils.checkIntersect(shoots[i].getLocation(), asteroid.getLocation(), 1, asteroid.getRadius())) {
              asteroid.setHitted(origin);
              shoots[i] = null;
              break;
            }
          }
        }
      }
    }
  }
  
  private void updateOvniCollisionChecks() {
    if (origin == ShooterOriginType.PLAYER) {
      Ovni currentOvni = ovniManager.getCurrentOvni();
      if (currentOvni != null) {
        for (int i = 0; i < shoots.length; i++) {
          if (shoots[i] != null) {
            if (MathUtils.checkIntersect(shoots[i].getLocation(), currentOvni.getLocation(), 1, currentOvni.getRadius())) {
              currentOvni.setDestroyedByShip();
              break;
            }
          }
        }
      }
    }
  }
  
  private void updateShipCollisionChecks() {
    if (origin == ShooterOriginType.ENEMY) {
      for (int i = 0; i < shoots.length; i++) {
        if (shoots[i] != null) {
          if (MathUtils.checkIntersect(shoots[i].getLocation(), ship.location, 1, ship.drawScale)) {
            ship.setDestroyed();
          }
        }
      }
    }
  }

  private void updateRender() {
    for (int i = 0; i < shoots.length; i++) {
      if (shoots[i] != null) {
        shoots[i].updateRender();
      }
    }
  }
}