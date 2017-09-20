class ExplosionManager {
  ArrayList<ParticleExplosion> explosions;

  ExplosionManager() {
    explosions = new ArrayList<ParticleExplosion>();
  }

  public void update() {
    for (ParticleExplosion particleExplosionIt : explosions) {
      particleExplosionIt.update();
    }
    for (int i = explosions.size() - 1; i >= 0; i--) {
      if (explosions.get(i).isFinished()) {
        explosions.remove(i);
      }
    }
  }
  public void createShipExplosion(PVector localization) {
    addExplosion(localization, 3, 8);
  }

  public void createBigAsteroidExplosion(PVector localization) {
    addExplosion(localization, 10, 35);
  }

  public void createMediumAsteroidExplosion(PVector localization) {
    addExplosion(localization, 8, 25);
  }

  public void createSmallAsteroidExplosion(PVector localization) {
    addExplosion(localization, 6, 15);
  }

  public void createNormalOvniExplosion(PVector localization) {
    addExplosion(localization, 15, 20);
  }

  public void createEliteOvniExplosion(PVector localization) {
    addExplosion(localization, 10, 13);
  }

  public void addExplosion(PVector localization, float duration, int amountParticles) {
    ParticleExplosion particleExplosion = new ParticleExplosion(localization, duration, amountParticles);
    explosions.add(particleExplosion);
  }
}