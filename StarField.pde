class StarField {
  ArrayList<PVector> stars;
  float deep;
  
  StarField(int size, float deepLayer) {
    stars = new ArrayList<PVector>();
    deep = deepLayer;
    for (int i = 0; i < size; i++) {
      PVector star = new PVector(random(width), random(height), random(deep));
      stars.add(star);
    }
  }
  
  void update() {
    for (PVector star : stars) {
      // movement
      star.x += star.z;
      
      // edges
      if (star.x > width) {
        star.x = -1;
        star.z = random(deep);
      }
      
      // draw
      noFill();
      stroke (255, 55 + 200 * star.z);
      ellipse(star.x, star.y, 1, 1);
    }
  }  
}