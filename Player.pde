// Player subclass of Character
// Handles entire player (collision, walking, leveling, etc)

class Player extends Character{
  float damp = 0.9;
  PVector vel;
  
  int currFrame = 0;
  PImage[] activeFrames;
  int animationRate = 7;
  boolean facingRight;
  
  // stats
  int level;
  int experience;
  float health;
  float maxHealth;
  int attack;
  
  // levels
  final int LEVEL_TWO = 10;
  final int LEVEL_THREE = 25;
  final int LEVEL_FOUR = 40;
  final int LEVEL_FIVE = 60;
  final int LEVEL_SIX = 80;
  final int LEVEL_SEVEN = 100;
  final int LEVEL_EIGHT = 130;
  final int LEVEL_NINE = 160;
  final int LEVEL_TEN = 200;
  
  // items
  int coins;
  int potionAmount;
  final int recoveryAmount = 10;
  boolean hasItemOne;
  
  // interaction
  boolean interacting;
  boolean talking;
  boolean frozen;
  
  // health calculations
  boolean decreasingHealth;
  float projectedHealth;
  
  // stat increase
  int healthInc;
  int attackInc;
  boolean hasLeveledUp;
  int expUntilNextLevel;

  Player(PImage img, PVector pos, PVector vel){
    super(img, pos);
    this.vel = vel;
    
    // stats
    health = 5;
    maxHealth = 10;
    attack = 3; // change back to 3
    level = 1;
    experience = 0;
    coins = 0;
    
    // items
    potionAmount = 3;
    hasItemOne = false;
    
    // interactions
    interacting = false;
    talking = false;
    frozen = false;
    
    // animation
    activeFrames = playerIdleFrames;
    facingRight = true;
  }
  
  void move(){
    pos.add(vel);
    vel.mult(damp);
  }
  
  void accelerate(PVector acc){
    vel.add(acc);
  }
  
  // call to check if there is no one where the player is standing
  // used for opening / closing textboxes and exclamation points
  void checkNoCollision(){
    boolean hasInteracted = false;
    for(int i = 0; i < npcs.size(); i++){
      NPC npc = npcs.get(i);
      if((abs(pos.x-npc.pos.x)<img.width && abs(pos.y-npc.pos.y)<img.height) && npc.getLocation() == state){
        npc.drawCollisionExclamation();
        hasInteracted = true;
      } 
    }
    interacting = hasInteracted;
  }
  
  // call to check if there is an npc where the player is standing
  // used for conversations
  void checkInteraction(NPC npc){
    // detect if thing is actually here
    if(abs(pos.x-npc.pos.x)<img.width && abs(pos.y-npc.pos.y)<img.height){
      interacting = true;
    }
  }
  
  void drawMe(){
    pushMatrix();
    translate(pos.x, pos.y);
    if(facingRight) scale(1, 1);
    if(!facingRight) scale(-1, 1);    
    image(img, -img.width/2, -img.height/2);    
    popMatrix();
  }
  
  // update animation
  void updateFrames(){
    // frameCount is built in variable for # frames since sketch start 
    if(frameCount%animationRate==0) {
      // every x frames, increase currFrame, and if max, set it back to 0
      if (currFrame < activeFrames.length-1){
        currFrame++;
      } else {
        currFrame=0;
      }
      
      // Updates the img that is drawn to be the current frame
      img=activeFrames[currFrame];
      
      // Updates the img that is drawn to be the current frame
      //img = playerIdleFrames[currFrame];
    }
  }
  
  // change player animation to walking / idle
  void checkActiveFrames(){
    if(vel.x != 0 || vel.y != 0){
      activeFrames = playerWalkFrames;
    } else if (vel.x == 0 && vel.y == 0){
      activeFrames = playerIdleFrames;
    }
  }
  
  // check if the player is in front by comparing their feet
  boolean isInFront(NPC npc){
    if(pos.y+img.height/2 > npc.pos.y+npc.img.height/2){
      return true;
    }
    return false;
  }
  
  // handle the player moving into walls
  void handleWalls(){
    // main pathways
    if(state < PLAYER_HOUSE){
      // blockages
      if(pos.x < 0 && state == PLAYER_BASE) pos.x = 0;
      if(pos.x > width && state == CASTLE_3) pos.x = width;
      if(pos.x > width && state == TOWN && !hasItemOne) pos.x = width;
      if(pos.x > width && state == WILDERNESS_4 && !((Enemy)npcs.get(7)).getDead()) pos.x = width;
    
      // move right through screens
      if(state >= PLAYER_BASE && state < CASTLE_3 && state < 10){
        if(pos.x > width){
            state++;
            pos.x = img.width/2;
        }
      }
      
      // move left through screens
      if(state > PLAYER_BASE && state <= CASTLE_3 && state < 10){
        if(pos.x < 0){
          state--;
          pos.x = width-img.width/2;
        }
      }
    }
    
    // handle case if user is in a building
    if(state >= PLAYER_HOUSE){
      if(pos.x > width) pos.x = width;
      if(pos.x < 0){
        state = tempLocation;
        pos.x = tempPlayerPos.x;
        pos.y = tempPlayerPos.y;
      }
    }
   
    // handle top / down direction 
    if (pos.y < height/2 + height/8 - img.height/4)  pos.y = height/2 + height/8 - img.height/4;
    if (pos.y > height - img.height/2)               pos.y = height - img.height/2;
  }
  
  void update(){
    super.update();
    move();
    handleWalls();
    
    // update animation
    updateFrames();
    checkActiveFrames();
    
    // check to update lvl
    updateExpUntilNextLvl();
    
    // set current temp location to state if not in a house (this is used to determine where to bring player when they leave a house)
    if(state >= 1 && state < PLAYER_HOUSE) tempLocation = state;
    
    if(!interacting) talking = false;
    
    // check if player defeated bandit
    if(((Enemy)npcs.get(6)).getDead()){
      hasItemOne = true;
    }
    
    checkNoCollision();
  }
  
  // set state to GAME OVER if the player dies
  void checkDeath(){
    if(health <= 0.1){
      state = GAME_OVER;
    }
  }
  
  // decrease the player's health ; called in battleUI
  void decreaseHealth(){
    if(decreasingHealth){
        if(health > projectedHealth && health > 0.1){
          if(health <= projectedHealth + 0.1){
            health = projectedHealth;
          } else {
            health -= maxHealth/100;
          }
        } else if (health <= 0.1){
          health = 0;
          state = GAME_OVER;
        } else if(health <= projectedHealth) {
          health = projectedHealth;
          decreasingHealth = false;
        }
     }
  }
  
  // increase the player's health
  void usePotion(){
    if(potionAmount > 0){
      potionAmount--;
      if(health + recoveryAmount > maxHealth){
        health = maxHealth;
      } else {
        health += recoveryAmount;
      }
    }
  }
  
  // increase all stats of the player
  void increaseStats(){
    level++;
    hasLeveledUp = true;
    attackInc = (int)random(1,3);
    attack += attackInc;
    healthInc = (int)random(2,5);
    maxHealth += healthInc;
    health += healthInc;
  }
  
  // check if the player has leveled up, increase stats if so 
  void checkLevelUp(){
    if(experience >= LEVEL_TEN && level == 9){
      increaseStats();
    } else if (experience >= LEVEL_NINE && level == 8){
      increaseStats();
    } else if (experience >= LEVEL_EIGHT && level == 7){
      increaseStats();
    } else if (experience >= LEVEL_SEVEN && level == 6){
      increaseStats();
    } else if (experience >= LEVEL_SIX && level == 5){
      increaseStats();
    } else if (experience >= LEVEL_FIVE && level == 4){
      increaseStats();
    } else if (experience >= LEVEL_FOUR && level == 3){
      increaseStats();
    } else if (experience >= LEVEL_THREE && level == 2){
      increaseStats();
    } else if (experience >= LEVEL_TWO && level == 1){
      increaseStats();
    }
  }
  
  // update the user's experience until next; shown in inventory
  void updateExpUntilNextLvl(){
    if(level == 1) expUntilNextLevel = LEVEL_TWO - experience;
    if(level == 2) expUntilNextLevel = LEVEL_THREE - experience;
    if(level == 3) expUntilNextLevel = LEVEL_FOUR - experience;
    if(level == 4) expUntilNextLevel = LEVEL_FIVE - experience;
    if(level == 5) expUntilNextLevel = LEVEL_SIX - experience;
    if(level == 6) expUntilNextLevel = LEVEL_SEVEN - experience;
    if(level == 7) expUntilNextLevel = LEVEL_EIGHT - experience;
    if(level == 8) expUntilNextLevel = LEVEL_NINE - experience;
    if(level == 9) expUntilNextLevel = LEVEL_TEN - experience;
  }
  
  // setters
  void setDecreasingHealth(float dmgTaken) { 
    decreasingHealth = true; 
    projectedHealth = health - dmgTaken;
  }
  void increaseExp(int expGain){ experience += expGain; }
  void increaseCoins(int coinGain){ coins += coinGain; }
  void decreaseCoins(int coinLoss){ coins -= coinLoss; }
  void gainPotion() { potionAmount += 1; }
  void setFrozen(boolean isFrozen) { frozen = isFrozen; }
  void removeVel(){
    vel.x = 0;
    vel.y = 0;
  }
  void setHasLeveledUpFalse() { hasLeveledUp = false; }
  void setHasItemOneTrue() { hasItemOne = true; }
  void setInteractingFalse() { interacting = false; }
  void setPosX(float posX) { pos.x = posX; }
  void setPosY(float posY) { pos.y = posY; }
  void setFacingLeft() { facingRight = false; }
  void setFacingRight() { facingRight = true; }
  void setTalking(boolean bool) { talking = bool; }
  
  // getters
  int getLevel() { return level; }
  int getExperience() { return experience; }
  int getExpUntilNextLevel() { return expUntilNextLevel; }
  int getAttack() { return attack; }
  boolean getInteraction() { return interacting; }
  boolean getTalking() { return talking; }
  float getHealth() { return health; }
  float getMaxHealth() { return maxHealth; }
  float getHealthPercentage() { return health/maxHealth; }
  boolean getDecreasingHealth() { return decreasingHealth; }
  int getPotionAmount() { return potionAmount; }
  int getRecoveryAmount() { return recoveryAmount; }
  boolean getHasItemOne() { return hasItemOne; }
  int getCoins() { return coins; }
  boolean getFrozen() { return frozen; }
  int getHealthInc() { return healthInc; }
  int getAttackInc() { return attackInc; }
  boolean getHasLeveledUp() { return hasLeveledUp; }
  int getWidth() { return img.width; }
  float getPosX() { return pos.x; }
  float getPosY() { return pos.y; }
  float getVelX() { return vel.x; }
  float getVelY() { return vel.y; }
}
