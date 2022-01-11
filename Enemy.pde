// Subclass of NPC and subsubclass of Character
// At the end of the text index, calls a fight
// Has a different StringList message after enemy is defeated

class Enemy extends NPC {
  float health;
  float maxHealth;
  float attackDmg;
  PFont monoFont = loadFont("Monospaced.plain-48.vlw");
  boolean dead;
  boolean isBoss;
  int enemyType;
  
  // give player after being defeated
  int expGain;
  int coinGain;
  
  // conversation text
  int textIndex;
  StringList deadConvo;

  Enemy(PImage img, PVector pos, float health, float attackDmg, int expGain, int coinGain, int location, StringList convo, StringList deadConvo, boolean isBoss, int enemyType) {
    super(img, pos, location, convo);
    this.health = health;
    this.maxHealth = health;
    this.attackDmg = attackDmg;
    
    this.expGain = expGain;
    this.coinGain = coinGain;
    
    this.convo = convo;
    this.deadConvo = deadConvo;
    
    dead = false;
    this.isBoss = isBoss;
    this.enemyType = enemyType;
  }

  void drawMe() {
    pushMatrix();
    translate(pos.x, pos.y);
    scale(-1, 1);
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }

  // start a battle and move state to FIGHT
  void startFight() {
    tempBattleLocation = state;
    battleUI = new BattleUI(enemyType, health, attackDmg, expGain, coinGain, true, isBoss);
    state = FIGHT;
    textIndex = -1;
  }

  // check if the player is talking to npc, and display conversation stringlist if so
  void checkConversation() {
    if (player.getInteraction()) {
        // regular text
        if(!dead && textIndex < convo.size()){
          if(textIndex != -1){
            drawTextBox();
            fill(0);
            textFont(monoFont);
            textAlign(LEFT);
            textSize(40);
            String s = convo.get(textIndex);
            text(s, width/8+20, height/8+20, width-(width/8)*2-40, height/3-40);
          }
        }
        
        // text if dead
        if(dead && textIndex < deadConvo.size()){
          if(textIndex != -1){
            drawTextBox();
            fill(0);
            textFont(monoFont);
            textAlign(LEFT);
            textSize(40);
            String s = deadConvo.get(textIndex);     
            text(s, width/8+20, height/8+20, width-(width/8)*2-40, height/3-40);
          }
        }

        // start battle
        if(!dead && textIndex == convo.size()){
          textIndex = -1;
          if (!dead) startFight();
        } else if (dead && textIndex == deadConvo.size()){
          textIndex = -1;
          player.setTalking(false);
        }
    } else {
      textIndex = -1;
    }
  }
  
  // draw the box that contains the npc text
  void drawTextBox(){
    fill(255);
    strokeWeight(1.3);
    rectMode(CORNER);
    rect(width/8, height/8, width-(width/8)*2, height/3);
    strokeWeight(1);
  }

  void update() {
    super.update();
  }

  // conversation + conversatoin when dead
  void increaseTextIndex() {
    if(!dead && textIndex < convo.size()) textIndex++;
    if(dead && textIndex < deadConvo.size()) textIndex++;
  }
  
  // set the enemy to dead; used for determining if able to fight and also show second StringList for being defeated
  void setDead() { 
    dead = true; 
  }

  // getters
  float getHealth() { return health; }
  float getMaxHealth() { return maxHealth; }
  float getAtk() { return attackDmg; }
  float getHealthPercentage() { return health/maxHealth; }
  boolean getDead() { return dead; }
}
