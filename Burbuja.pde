class Burbuja {
  PVector position;
  PVector velocity;
  
  float posX, posY;
  float diametro, radio, m;
  float r, g, b;
  
  int c;
  
  Burbuja (float x, float y) {
    this.diametro = 100;
    this.radio = this.diametro/2;
    
    this.position = new PVector(x, y);
    this.velocity = PVector.random2D();
    this.m = this.radio*.1;
  }
  
  void update() {
    this.position.add(velocity);
  }
  
  void colisiones() {
    if (this.position.x > width - radio) {
      this.position.x = width - radio;
      this.velocity.x *= -1;
    } else if (this.position.x < radio) {
      this.position.x = this.radio;
      this.velocity.x *= -1;
    } else if (this.position.y > height - this.radio) {
      this.position.y = height - this.radio;
      this.velocity.y *= -1;
    } else if (this.position.y < this.radio) {
      this.position.y = this.radio;
      this.velocity.y *= -1;
    }
  }
  
  void colisionesBurbuja(Burbuja otra) {
    PVector distanceVect = PVector.sub(otra.position, this.position);
    
    float distanceVectMag = distanceVect.mag();
    
    float minDistance = this.radio + otra.radio;
    
    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      otra.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the otra
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * otra.velocity.x + sine * otra.velocity.y;
      vTemp[1].y  = cosine * otra.velocity.y - sine * otra.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - otra.m) * vTemp[0].x + 2 * otra.m * vTemp[1].x) / (m + otra.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((otra.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + otra.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      otra.position.x = position.x + bFinal[1].x;
      otra.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      otra.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      otra.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
    
  }
  
  void display() {
    this.c = color(this.r, this.g, this.b);
    fill(c);
    
    noStroke();
    
    ellipse(this.position.x, this.position.y, this.diametro, this.diametro);
  }
}
