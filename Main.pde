int currentTime;
int previousTime;
int deltaTime;

float nbAgent = int(random(10, 20));
ArrayList<Mover> agents;
Ship ship;
ArrayList<Projectile> bullets;
int maxBullets = 10;

void setup () 
{
  size (1080, 720);
  currentTime = millis();
  previousTime = millis();
  
  ship = new Ship();
  agents = new ArrayList<Mover>();
  bullets = new ArrayList<Projectile>();
  
  for (int i = 0; i < nbAgent; i++) 
  {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)));
    m.fillColor = color(random(255), random(255), random(255));
    agents.add(m);
  }
}

void draw () 
{
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();  
}

void update(int delta) 
{
  if (keyPressed) {
    switch (key) {
      case 'w':
        ship.thrust();
        break;
      case 'a':
         ship.pivote(-.03);
         break;
      case 'd':
         ship.pivote(.03);
        break;
    }
  }
  ship.update(delta);
  ArrayList<Mover> moversToRemove = new ArrayList<Mover>();
  ArrayList<Projectile> bulletsToRemove = new ArrayList<Projectile>();
  for ( Projectile p : bullets) {
    p.update(deltaTime);
    
    for (Mover m : agents) 
    {
      if (m.isColliding(p))
      {
        moversToRemove.add(m);
        bulletsToRemove.add(p);
      }
    }
  }
  bullets.removeAll(bulletsToRemove);
  agents.removeAll(moversToRemove);
  for (Mover m : agents) 
  {
    m.flock(agents);
    m.update(delta);
    if (ship.isColliding(m))
    {
      PVector respawnPoint = new PVector();
      boolean notFound = true;
      while(notFound)
      {
        respawnPoint.x = random(width);
        respawnPoint.y = random(height);
        
        boolean colliding = false;
        for(int i = 0; i < agents.size(); i++)
        {
          if(m.isCollidingZone(respawnPoint))
            colliding = true;
        }
        
        if (!colliding)
          notFound = false;
      }
      ship = new Ship();
      ship.location.x = respawnPoint.x;
      ship.location.y = respawnPoint.y;
    }
  }
}

void display () 
{
  background(0);
  
  
  for ( Projectile p : bullets) {
    p.display();
  }
  ship.display();
  

  
  for (Mover m : agents) 
  {
    m.display();
  }
}

void keyReleased() 
{
    switch (key) {
      case ' ':
        ship.noThrust();
        break;
    }  
}

void keyPressed()
{
  if (key == 'r')
  {
    setup();
  }
  if (key == ' ')
  {
    fire(ship); 
  }
}

void mouseClicked()
{
  Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)));
  m.fillColor = color(random(255), random(255), random(255));
  agents.add(m);
}

void fire(GraphicObject m) {
  Ship s = (Ship)m;
  
  if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = s.getCanonTip().copy();
    p.topSpeed = 10;
    p.velocity = s.getShootingVector().copy().mult(p.topSpeed);
   
    p.activate();
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = s.getCanonTip().x;
        p.location.y = s.getCanonTip().y;
        p.velocity.x = s.getShootingVector().x;
        p.velocity.y = s.getShootingVector().y;
        p.velocity.mult(p.topSpeed);
        p.activate();
        break;
      }
    }
  }  
}
