class ParticleExplosion {
  ArrayList<Particle> particles;
  
  ParticleExplosion(PVector _localization, float _duration, int _amount) {
    particles = new ArrayList<Particle>();
    float increment = TWO_PI / _amount;
    for (float i = 0; i < TWO_PI; i += increment) {
      PVector particleForce = new PVector(cos(i), sin(i)).mult(random(0.5));
      particles.add(new Particle(_localization, _duration, particleForce));
    }
  }
  
  public void update() {
    for (Particle particleIt : particles) {
      particleIt.update();
    }
  }
  
  public boolean isFinished() {
    for (Particle particleIt : particles) {
      if (!particleIt.isFinished()) {
        return false;
      }
    }
    
    return true;
  }
}