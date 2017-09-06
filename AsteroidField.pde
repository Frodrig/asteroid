class AsteroidField {
  ArrayList<Asteroid> asteroids;
  ArrayList<Integer> asteroidsToDestroy;
  int velocityRange;
  int minRadiusToDestroyAsteroid = 25;
  
  AsteroidField(int amount, int maxAsteroidSize, int velocityRange) {
    generateAsteroids(amount, maxAsteroidSize, velocityRange);
  }
  
  void generateAsteroids(int _amount, int _maxAsteroidSize, int _velocityRange) {
    asteroids = new ArrayList<Asteroid>();
    for (int i = 0; i < _amount; i++) {
      
      float size = 25;
      float sizeDice = random(1);
      if (sizeDice > 0.6) {
        size = 100;
      } else if (sizeDice > 0.2) {
        size = 50;
      }
      
      Asteroid asteroid = new Asteroid(this, size, _velocityRange);
      asteroids.add(asteroid);
    }
    velocityRange = _velocityRange;
  }
  
  boolean isFieldEmpty() {
    return asteroids.size() == 0;
  }
  
  Asteroid findAsteroidAtPosition(PVector position) {
    for (Asteroid asteroidIt : asteroids) {
      if (asteroidIt.checkIntersect(position)) {
        return asteroidIt;
      }
    }
    return null;
  }
  
  Asteroid findAsteroidAtPosition(PVector position, float radius) {
    for (Asteroid asteroid : asteroids) {
      PVector dist = PVector.sub(asteroid.location, position);
      float sumRadius = radius + asteroid.circleColliderRadius;
      boolean existCollision = dist.mag() < sumRadius;
      if (existCollision) {
        return asteroid;
      }
    }
    return null;
  }
 
  void update() {
    updateHittedAsteroids();
    updateCurrentAsteroids();
  }
  
  void updateHittedAsteroids() {
    ArrayList<Asteroid> newAsteroids = new ArrayList<Asteroid>();
    for (int i = asteroids.size() - 1; i >= 0; i--) {
      Asteroid asteroidIt = asteroids.get(i);
      if (asteroidIt.hitted) {
    
        if (asteroidIt.circleColliderRadius > minRadiusToDestroyAsteroid) {
          int numNewAsteroids = 2;
          int radiusOfNewAsteroids = int(asteroidIt.circleColliderRadius) / 2;
          float destroyAngleDirInitial = random(0, TWO_PI);
          for (int newAsteroidCounter = 0; newAsteroidCounter < numNewAsteroids; ++newAsteroidCounter) {
            Asteroid newAsteroid = new Asteroid(this, radiusOfNewAsteroids, velocityRange, asteroidIt.location);
            newAsteroid.resetForces();
            PVector newAsteroidPartDir = new PVector(cos(destroyAngleDirInitial + newAsteroidCounter * HALF_PI) , sin(destroyAngleDirInitial + newAsteroidCounter * HALF_PI)).normalize();
            newAsteroid.applyForce(newAsteroidPartDir.mult(random(velocityRange/2, velocityRange)));
            newAsteroid.fadeAlpha = 55;
            newAsteroids.add(newAsteroid);
          }
        }
        hud.addPointsByDestroyAsteroid(asteroidIt.circleColliderRadius);  //<>//
        asteroids.remove(i);
      }
    }
    
    for (Asteroid newCreatedAsteroid : newAsteroids) {
      asteroids.add(newCreatedAsteroid);    
    }
  }
  
  void updateCurrentAsteroids() {
    for (Asteroid asteroid : asteroids) {
      asteroid.update();
    }
  }
}