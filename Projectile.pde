class Projectile extends GraphicObject {
  boolean isVisible = false;
  int radius = 3;
  
  Projectile () {
    super();
    velocity = new PVector (0, 0);
    acceleration = new PVector (0 , 0);
  }
  
  void activate() {
    isVisible = true;
  }
  
  void setDirection(PVector v) {
    velocity = v;
  }
  
  
  void update(float deltaTime) {
    
    if (!isVisible) return;
    
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
    
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      isVisible = false;
    }
  }
  
  void display() {
    
    fill(255, 255, 0);
    if (isVisible) {
      pushMatrix();
        translate (location.x, location.y);
        
        ellipse (0, 0, radius, radius);
      popMatrix();
    }
  }
}
