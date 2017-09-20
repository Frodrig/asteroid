 static class MathUtils {

  static boolean checkIntersect(PVector _location1, PVector _location2, float radius1, float radius2) {
    float distance = PVector.sub(_location2, _location1).mag();
    boolean intersect = distance < (radius1 + radius2);
    return intersect;
  }
  
  static boolean isAlmostEqual(double a, double b) {
    boolean isAlmost = Math.abs(a - b) < 0.001;
    
    return isAlmost;
  }
}