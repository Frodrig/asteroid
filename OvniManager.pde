class OvniManager {
  private int nextSpawnTime;
  private Ovni currentOvni;

  OvniManager() {
    nextSpawnTime = calculeNextSpawnTime();
    currentOvni = null;
  }

  public void reset() {
    nextSpawnTime = calculeNextSpawnTime();
    currentOvni = null;
  }

  public boolean existCurrentOvni() {
    return currentOvni != null;
  }
  
  public Ovni getCurrentOvni() {
    return currentOvni;
  }

  public void update() {
    if (currentOvni != null) {
      if (currentOvni.isDestroyed()) {
        currentOvni = null;
      } else {
        currentOvni.update();
      }
    }  
    
    if (millis() > nextSpawnTime) {
      nextSpawnTime = calculeNextSpawnTime();
      if (currentOvni == null) {
        OvniType type = OvniType.NORMAL;
        if (hud.score > 10000 && random(1) > 0.5) {
          type = OvniType.ELITE;
        }
        currentOvni = new Ovni(type, new PVector(width, height/3));
      }
    }
  }

  public void destroyCurrentOvni() {
    currentOvni = null;
  }

  private int calculeNextSpawnTime() {
    return millis() + 1000 * 10;
  }
}