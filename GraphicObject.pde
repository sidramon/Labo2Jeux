abstract class GraphicObject {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  color fillColor = color(255);
  color strokeColor = color(255);
  float strokeWeight = 1;
  float topSpeed = 100;
  
  abstract void update(float deltaTime);
  
  abstract void display();
  
}
