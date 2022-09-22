class Ship extends GraphicObject
{
  float angularVelocity = 0.0;
  float angularAcceleration = 0.0;
  
  float angle = 0.0;  
  float heading = 0.0;
  
  float shootingAngle = QUARTER_PI;
  float angleIncrement = PI/60;
  
  float w = 20;
  float h = 10;
  
  float mass = 1.0;
  
  float speedLimit = 5;
  boolean thrusting = false;
  
  PVector shootingVector = new PVector();
  PVector canonTip = new PVector();
  
  Ship() {
    initValues();
  }
  
  PVector getCanonTip() {
    
    return canonTip;
  }
  
  PVector getShootingVector() {
    return shootingVector;
  }
  
  void initValues() {
    location = new PVector(width/2, height/2);
    velocity = new PVector();
    acceleration = new PVector();
  }
  
  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);
  }
  
  void checkEdges() {
    if (location.x < -size) location.x = width + size;
    if (location.y < -size) location.y = height + size;
    if (location.x > width + size) location.x = -size;
    if (location.y > height + size) location.y = -size;
  }
  
  void thrust(){
    float angle = heading - PI/2;
    
    PVector force = new PVector (cos(angle), sin(angle));
    force.mult(0.1);
    
    applyForce(force);
    
    thrusting = true;    
  }
  
  void update(float deltaTime) {
    checkEdges();
    
    velocity.add(acceleration);
    
    velocity.limit(speedLimit);
    
    location.add(velocity);
    
    acceleration.mult(0);
    
    angularVelocity += angularAcceleration;
    angle += angularVelocity;
    
    angularAcceleration = 0.0;
    
    shootingVector.y = -cos(heading);
    shootingVector.x = sin(heading);
    shootingVector.normalize();
    canonTip.x = location.x + shootingVector.x * w;
    canonTip.y = location.y + shootingVector.y * w - 3;
  }
  
  float size = 20;
  
  void display() 
  {
    pushMatrix();
      translate (location.x, location.y);
      rotate (heading);
      
      fill(200);
      noStroke();
      
      beginShape(TRIANGLES);
        vertex(0, -size);
        vertex(size, size);
        vertex(-size, size);
      endShape();
      
      if (thrusting) {
        fill(200, 0, 0);
      }
      rect(-size + (size/4), size, size / 2, size / 2);
      rect(size - ((size/4) + size/2), size, size / 2, size / 2);
      
    popMatrix();
  }
  
  void pivote(float angle) {
    heading += angle;
  }
  
  void noThrust() {
    thrusting = false;
  }
  
  boolean isColliding(Mover m)
  {
    boolean result = false;
    
    float distance = PVector.dist(location, m.location);
    
    if ((w + m.r) >= distance) 
      result = true;
    
    return result;
  }

}
