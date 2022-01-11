// Bouncing ball used in state = castle 2 to show off physics

class BouncingBall{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector gravity;
  float ballWidth;
  float ballHeight;
  
  // holds original speed for resetting purposes
  float ogVelY;
  
  BouncingBall(PVector pos, PVector vel, float ballWidth, float ballHeight){
    this.pos = pos;
    this.vel = vel;
    this.ballWidth = ballWidth;
    this.ballHeight = ballHeight;
    
    acc = new PVector(0, 0);
    gravity = new PVector(0, .1);
  }
  
  void drawMe(){
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    strokeWeight(3);
    ellipse(0, 0, ballWidth, ballHeight);
    strokeWeight(1);
    popMatrix();
  }
  
  // sends the player to the start if hit
  void detectPlayer(){
    if((abs(pos.x-player.pos.x)<ballWidth && abs(pos.y-player.pos.y)<ballHeight*1.5)){
      player.setPosX(width/12);
      player.setPosY(height/2 + height/5);
    }
  }
  
  // the ball will bounce depending on collision
  void bounce(){
    if(pos.y + ballHeight/2 >= height - height/8){  // go back up
      vel.y *= -1;
    }
  }
  
  // move the ball
  void move(){
    acc.set(gravity); // gravity to drag it down
    vel.add(acc);
  }
  
  void update(){
    drawMe();
    detectPlayer();
    bounce();
    
    move();
    pos.add(vel);
  }
}
