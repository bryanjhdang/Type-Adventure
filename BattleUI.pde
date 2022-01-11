// Draws the entire battle system

class BattleUI{
  PFont monoFont = loadFont("Monospaced.plain-48.vlw");
  
  // transition
  float transition;
  boolean battleStartPlayed;
  
  // health bars
  final float X_HEALTH_OFFSET = width/6;
  final float Y_HEALTH_OFFSET = height - height/3.8;
  final float HEALTH_WIDTH = width/6;
  final float HEALTH_HEIGHT = height/22;
  float playerHealthWidth = width/6;
  float enemyHealthWidth = width/6;
  
  // HP text
  final float X_HEALTH_TEXT_OFFSET = X_HEALTH_OFFSET - HEALTH_WIDTH/2;
  final float Y_HEALTH_TEXT_OFFSET = Y_HEALTH_OFFSET - HEALTH_HEIGHT/1.5;
  
  // buttons
  final float X_BUTTON_OFFSET = width/2;
  final float Y_BUTTON_OFFSET = height - height/8;
  final float BUTTON_WIDTH = height/4;
  final float BUTTON_HEIGHT = height/13;
  final float OFFSET_BETWEEN_BUTTONS = width/5;
  boolean blur;
  
  // fight phase timer
  float startFightTimer;
  float currentFightTimer;
  final float maxTime = 12;
  
  // transition fight timer
  float startTransitionTimer = millis()/1000;
  float currentTransitionTimer;
  final float maxTransitionTime = 1.6;
  float transitionTextOffset;
  final float ogTransitionTextOffset = height/2 - height/12;
  
  // potion text timer
  float startPotionTextTimer = millis()/1000;
  float currentPotionTextTimer = 0;
  final float maxPotionTextTime = 0.8;
  boolean displayedCannotUsePotion;
  boolean hasUsedPotion;
  float potionTextOffset;
  final float ogPotionTextOffset = height/2 - height/12;
  
  // player conditions
  boolean canUsePotion;
  
  // stats
  float enemyHealth;
  float enemyMaxHealth;
  float enemyHealthPercentage;
  float enemyAtk;
  boolean isNPC;
  boolean isBoss;
  int enemyType;
  final int BANDIT = 1;
  final int GOBLIN = 2;
  final int DEMON = 3;
  
  // after battle earnings
  int expGain;
  int coinGain;
  
  // health calculations
  boolean decreasingHealth;
  float projectedHealth;
  int damageEnemy;
  
  // battle phase (0 = menu, 1 = fight, 2 = item)
  int battlePhase;
  boolean fightPhase;

  // buttons (0 = fight, 1 = items, 2 = run)
  int menuButton;

  // transition calculations
  boolean frozen;
  boolean finishedTransition;
  
  // call word class
  Word word;
  
  // animation
  int animationRate = 7;
  PImage playerImg;
  PImage enemyImg;
  int currFrame = 0;
  PImage[] activePlayerFrames;
  PImage[] activeEnemyFrames;
  
  BattleUI(int enemyType, float enemyHealth, float enemyAtk, int expGain, int coinGain, boolean isNPC, boolean isBoss){
    this.enemyType = enemyType;
    this.enemyHealth = enemyHealth;
    this.enemyMaxHealth = enemyHealth;
    this.enemyAtk = enemyAtk;
    this.expGain = expGain;
    this.coinGain = coinGain;
    this.isNPC = isNPC;
    this.isBoss = isBoss;
    
    transition = 255;
    finishedTransition = false;
    blur = false;
    
    startTransitionTimer = (float)millis()/1000;
    currentTransitionTimer = maxTransitionTime;
    
    startFightTimer = (float)millis()/1000;
    currentFightTimer = maxTime;
    
    startPotionTextTimer = 0;
    currentPotionTextTimer = maxPotionTextTime;
    displayedCannotUsePotion = true;
    hasUsedPotion = false;
    
    transitionTextOffset = ogTransitionTextOffset;
    potionTextOffset = ogPotionTextOffset;
    
    menuButton = 0;
    battlePhase = 0;
    decreasingHealth = false;
    
    canUsePotion = true;
    
    fightAudio.rewind();
    
    battleStartAudio.rewind();
    battleStartPlayed = false;
    
    activePlayerFrames = battlePlayerIdleFrames;
    playerImg = battlePlayerIdleFrames[0];
    
    if(enemyType == BANDIT){
      activeEnemyFrames = battleBanditIdleFrames;
      enemyImg = battleBanditIdleFrames[0];
    } else if (enemyType == GOBLIN){
      activeEnemyFrames = battleGoblinIdleFrames;
      enemyImg = battleGoblinIdleFrames[0];
    } else if (enemyType == DEMON){
      activeEnemyFrames = battleDemonIdleFrames;
      enemyImg = battleDemonIdleFrames[0];
    }
  }
  
  void update(){
    pauseAllNonBattleMusic();
    if(transition == 0) playMusic(fightAudio);
    if(!battleStartPlayed){
      battleStartAudio.play();
      battleStartPlayed = true;
    } 
    
    handleBattle();
    
    // draw UI elements
    drawFightButton();
    drawItemButton();
    drawRunButton();
    blurMenu();
    drawBorders();
    drawPlayerHealth();
    drawEnemyHealth();
    if(!blur) highlightButton();
    drawTimer();
    drawTransition();
    drawPotionDisplay();
    
    // updating stats
    updateEnemyHealthPercentage();
    
    // update timers
    if(frozen) { decreaseTransitionTimer(); }
    if(!canUsePotion) { decreasePotionTextTimer(); }
    if(!displayedCannotUsePotion) { decreasePotionTextTimer(); }
    
    // update health
    decreaseEnemyHealth();
    player.decreaseHealth();
    
    // draw characters
    drawPlayer();
    updatePlayerFrames();
    drawEnemy();
    
    if(!finishedTransition) drawIntro();
  }
  
  // draw the black screen transition at the start of a fight
  void drawIntro(){
    rectMode(CORNER);
    fill(0, transition);
    rect(0, 0, width, height);
    menuButton = 0;
    if(transition > 200){
      transition -= 3;
    } else if (transition > 0) {
      transition -= 20;
    } else {
      transition = 0;
      finishedTransition = true;
    }
  }
  
  // draw the border line that separates the fight and the menu
  void drawBorders(){
    // lines
    stroke(0);
    line(0, Y_HEALTH_OFFSET, width, Y_HEALTH_OFFSET); 
  }
 
  // draw player health bar
  void drawPlayerHealth(){
    textAlign(LEFT);
    textFont(monoFont);
    fill(0);
    textSize(40);
    text("HP "+(int)player.getHealth()+"/"+(int)player.getMaxHealth(), X_HEALTH_TEXT_OFFSET, Y_HEALTH_TEXT_OFFSET);
    
    // health bar backgronud (white)
    fill(255);
    rectMode(CENTER);
    strokeWeight(1.3);
    rect(X_HEALTH_OFFSET, Y_HEALTH_OFFSET, HEALTH_WIDTH, HEALTH_HEIGHT);
    strokeWeight(1);
    
    // player health (black)
    fill(0);
    rectMode(CORNER);
    rect(X_HEALTH_OFFSET-HEALTH_WIDTH/2, Y_HEALTH_OFFSET-HEALTH_HEIGHT/2, playerHealthWidth*player.getHealthPercentage(), HEALTH_HEIGHT);
  }
  
  // draw enemy health bar
  void drawEnemyHealth(){
    textAlign(RIGHT);
    textFont(monoFont);
    fill(0);
    textSize(40);
    text("HP "+(int)enemyHealth+"/"+(int)enemyMaxHealth, width - X_HEALTH_TEXT_OFFSET, Y_HEALTH_TEXT_OFFSET);
    
    // health bar background (white)
    fill(255);
    rectMode(CENTER);
    strokeWeight(1.3);
    rect(width - X_HEALTH_OFFSET, Y_HEALTH_OFFSET, HEALTH_WIDTH, HEALTH_HEIGHT);
    strokeWeight(1);
  
    // enemy health (black)
    fill(0);
    rectMode(CORNER);
    pushMatrix();
    translate(width-X_HEALTH_OFFSET+HEALTH_WIDTH/2, Y_HEALTH_OFFSET-HEALTH_HEIGHT/2);
    scale(-1,1);
    rect(0, 0, enemyHealthWidth*enemyHealthPercentage, HEALTH_HEIGHT);
    popMatrix();
  }
  
  // draw button that says "fight"
  void drawFightButton(){
    // button
    rectMode(CENTER);
    fill(255);
    rect(X_BUTTON_OFFSET - OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    // text
    fill(0);
    textAlign(CENTER);
    textFont(monoFont);
    textSize(35);
    text("Fight", X_BUTTON_OFFSET - OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET + BUTTON_HEIGHT/8);
  }
  
  // draw button that says "item"
  void drawItemButton(){
    // button
    rectMode(CENTER);
    fill(255);
    rect(X_BUTTON_OFFSET, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    // text
    fill(0);
    textAlign(CENTER);
    textFont(monoFont);
    textSize(35);
    text("Potion (" + player.getPotionAmount() + ")", X_BUTTON_OFFSET, Y_BUTTON_OFFSET + BUTTON_HEIGHT/8);
  }
  
  // draw button that says "run"
  void drawRunButton(){
    // button
    rectMode(CENTER);
    fill(255);
    rect(X_BUTTON_OFFSET + OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    fill(0);
    textAlign(CENTER);
    textFont(monoFont);
    textSize(35);
    text("Run", X_BUTTON_OFFSET + OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET + BUTTON_HEIGHT/8);
  }
  
  // hightlights the button the user is selecting in gray
  void highlightButton(){
    if(menuButton == 0){
      rectMode(CENTER);
      fill(100, 40);
      rect(X_BUTTON_OFFSET - OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    } else if (menuButton == 1){
      rectMode(CENTER);
      fill(100, 40);
      rect(X_BUTTON_OFFSET, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    } else if (menuButton == 2){
      rectMode(CENTER);
      fill(100, 40);
      rect(X_BUTTON_OFFSET + OFFSET_BETWEEN_BUTTONS, Y_BUTTON_OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT);
    }
  }
  
  // greys out the menu during times where the player shouldn't be able to pick (ie intro, battle)
  void blurMenu(){
    if(battlePhase == 1 || frozen){
      fill(100, 80);
      noStroke();
      rectMode(CORNER);
      rect(0, Y_HEALTH_OFFSET, width, height);
      blur = true;
    } else {
      blur = false;
    }
  }
  
  // draw the timer durng battle
  void drawTimer(){
    if(battlePhase == 1 && (float)currentFightTimer > 0){
      fill(0);
      textAlign(CENTER);
      textSize(55);
      text((int)currentFightTimer, width/2, height/3);
    }
  }
  
  // decrease the fight timer during a fight
  void decreaseFightTimer(){
    float temp = (float)millis()/1000 - (float)startFightTimer;
    currentFightTimer = maxTime - temp;
  }
  
  // getter
  float getFightTimer() { return currentFightTimer; }
  
  // reset the fight timer for when a fight is called
  void resetFightTimer(){
    currentFightTimer = maxTime;
    startFightTimer = (float)millis()/1000;
  }
  
  // after a fight phase, draw a transition that correspond to how much damage you did
  void drawTransition(){
    if(currentTransitionTimer > 0 && frozen){      
      textAlign(CENTER);
      textSize(40);
      
      // check how many mistakes and if it was perfect
      boolean perfect = word.getPerfect();
      int mistakes = word.getMistakeCount();
      
      // display elements
      if(perfect){
        fill(34,139,34);
        text("Perfect! +" +ceil(player.getAttack()*0.3) +" dmg", width/2, transitionTextOffset - height/14);
      } else {
        fill(0);
        text("No perfect bonus", width/2, transitionTextOffset - height/14);
      }
      if(currentFightTimer > 0){
        fill(34, 139, 34);
        int tempDmg = 0;
        if (battleUI.getFightTimer() > 4){
          tempDmg = ceil(player.getAttack()*0.4);
        } else if (battleUI.getFightTimer() > 2){
          tempDmg = ceil(player.getAttack()*0.3);
        } else if (battleUI.getFightTimer() > 0){
          tempDmg = ceil(player.getAttack()*0.2);
        }
    
        text("Speedy! +"+tempDmg+" dmg", width/2, transitionTextOffset);
      } else {
        fill(0);
        text("No time bonus", width/2, transitionTextOffset);
      }
      if(mistakes >= 5){
        int damageDecrease = mistakes/5;
        fill(255, 0, 0);
        text(mistakes+" mistakes! -"+damageDecrease+" dmg", width/2, transitionTextOffset + height/14);
      }
      
      textSize(45);
      if(mistakes >= 5){
        fill(0);
        text("DAMAGE: " + damageEnemy, width/2, transitionTextOffset + (height/14)*2);
      } else {
        fill(0);
        text("DAMAGE: " + damageEnemy, width/2, transitionTextOffset + height/14);
      }
      
      // make text move up
      transitionTextOffset -= 0.6;
    }
    
    // end transition
    if(currentTransitionTimer <= 0 && frozen){
      frozen = false;
      resetFightTimer();
      transitionTextOffset = ogTransitionTextOffset;
    }
  }
  
  // decrease the time of the transition screen after hitting an enemy / dealing damage
  void decreaseTransitionTimer(){
    float temp = (float)millis()/1000 - startTransitionTimer;
    currentTransitionTimer = maxTransitionTime - temp;
  }
  
  // reset the timer for transition screen (after hitting enemy)
  void resetTransitionTimer(){
    currentTransitionTimer = maxTransitionTime;
    startTransitionTimer = (float)millis()/1000;
  }
  
  // move menu button left
  void moveButtonLeft() {
    if (menuButton > 0) menuButton -= 1;
  }
  
  // move menu button right
  void moveButtonRight() { 
    if (menuButton < 2) menuButton += 1;
  }
  
  // draw the elements that pops up when clicking on potion button 
  void drawPotionDisplay(){
    if(currentPotionTextTimer > 0 && !displayedCannotUsePotion){ // can't use
      textAlign(CENTER);
      textSize(40);
      fill(0);
      text("Cannot heal right now!" , width/2, potionTextOffset);
      potionTextOffset -= 0.6;
    } else if(currentPotionTextTimer > 0 && !canUsePotion){ // can use
      textAlign(CENTER);
      textSize(40);
      fill(34, 139, 34);
      text("Healed for " + player.getRecoveryAmount() + " HP!" , width/2, potionTextOffset);
      potionTextOffset -= 0.6;
    }
    
    // end transition
    if(currentPotionTextTimer <= 0){
      potionTextOffset = ogPotionTextOffset;
      displayedCannotUsePotion = true;
    }
  }
  
  // decrease the time that potion text is on screen
  void decreasePotionTextTimer(){
    float temp = (float)millis()/1000 - startPotionTextTimer;
    currentPotionTextTimer = maxPotionTextTime - temp;
  }
  
  // reset the amount of time that potion text is on screen
  void resetPotionTextTimer(){
    currentPotionTextTimer = maxPotionTextTime;
    startPotionTextTimer = (float)millis()/1000;
  }
  
  // ---- BATTLE CALCULATIONS ----
  void handleBattle() {
    if (battlePhase == 1) {
      fightPhase();
      if (word.getFinished() == true) {
        // calculate damage to the player
        int damagePlayer = (int)random(enemyAtk-1, enemyAtk+1);
        if (damagePlayer <= 0) damagePlayer = 1;

        // calculate damage to the enemy
        damageEnemy = damageToEnemy();

        // decrease health bars
        projectedHealth = enemyHealth - damageEnemy;
        decreasingHealth = true;
        if (projectedHealth > 0) player.setDecreasingHealth(damagePlayer);

        frozen = true;
        battleUI.resetTransitionTimer();
        battlePhase = 0;
      }
    }
  }
  
  // calculate damage to enemy based on perfect / time / mistakes
  int damageToEnemy() {
    int damageEnemy = (int)random(player.getAttack()-ceil((float)player.getLevel()/2), player.getAttack()+ceil((float)player.getLevel()/2));
    if (word.getPerfect())             damageEnemy += ceil(player.getAttack()*0.3);
    
    if (battleUI.getFightTimer() > 5){
      damageEnemy += ceil(player.getAttack()*0.4);
    } else if (battleUI.getFightTimer() > 3){
      damageEnemy += ceil(player.getAttack()*0.3);
    } else if (battleUI.getFightTimer() > 0){
      damageEnemy += ceil(player.getAttack()*0.2);
    }
    
    if (word.getMistakeCount() >= 5)   damageEnemy -= word.getMistakeCount()/5;
    if (damageEnemy <= 0)              damageEnemy = 1;
    return damageEnemy;
  }
  
  
  // check if enemy is dead (health < 0) and give stats to player
  void checkDeath() {
    if (enemyHealth <= 0) {
      pauseAllMusic();
      
      // increase stats
      player.increaseExp(expGain);
      player.increaseCoins(coinGain);
      player.checkLevelUp();
      player.removeVel();
      player.setInteractingFalse();
      
      // set the player so they can't move and npc to not fight again
      player.setFrozen(true);
      if(isNPC){
        println("pass");
        fightNPC.setDead();
      }
      
      // create after battle button
      afterBattleStatus = new AfterBattleStatus(expGain, coinGain, player.getHasLeveledUp(), player.getAttackInc(), player.getHealthInc());
      state = tempBattleLocation; 
    }
  }
  
  // start a fight by loading in words
  void startFightPhase() {
    canUsePotion = true;
    word = new Word(new PVector(width/4, height/2), 1);
    battleUI.resetFightTimer();
    battlePhase = 1;
  }
  
  /// determine if the player can use a potion or not
  void usePotion(){
    if(canUsePotion && player.getHealth() < player.getMaxHealth() && player.getPotionAmount() > 0){
      playMusic(potionAudio);
      canUsePotion = false;
      resetPotionTextTimer();
      player.usePotion();
    } else {
      resetPotionTextTimer();
      displayedCannotUsePotion = false;
    }
  }
  
  // unfreeze the player, meaning that they can move stuff again (ie. buttons, etc)
  void endFrozen() { 
    frozen = false;
  }
  
  // create a new set of words for an attack
  void generateWords() {
    word.fillAttack();
  }

  // controls element in fight (count down fight timer, update words)
  void fightPhase() {
    battleUI.decreaseFightTimer();
    word.update();
  }

  // let the player leave battle and go back to where they were on the map
  void leave() {
    player.removeVel();
    player.setInteractingFalse();
    state = tempBattleLocation;
    fightAudio.pause();
  }
  
  // decrease the enemy health when they get attacked
  void decreaseEnemyHealth() {
    if (decreasingHealth) {
      if (enemyHealth > projectedHealth && enemyHealth > enemyMaxHealth/100) {
        if (enemyHealth <= projectedHealth + 0.1) {
          enemyHealth = projectedHealth;
          if (enemyHealth >= 0) player.checkDeath();
        } else {
          enemyHealth -= enemyMaxHealth/100;
        }
      } else if (enemyHealth <= enemyMaxHealth/100) {
        if(isNPC) fightNPC.setDead();
        checkDeath();
        enemyHealth = 0;
      } else if (enemyHealth <= projectedHealth) {
        enemyHealth = projectedHealth;
        decreasingHealth = false;
      }
    }
  }
  
  // dynamically update the health of the player to match the bar
  void updateEnemyHealthPercentage() { enemyHealthPercentage = enemyHealth/enemyMaxHealth; }
  
  
  // getters
  int getBattlePhase() { return battlePhase; }
  int getMenuButton() { return menuButton; }
  boolean getFrozen() { return frozen; }
  
  
  // ---- DRAW CHARACTERS ----
  void drawPlayer(){
    pushMatrix();
    translate(width/8, height/2.5);
    image(playerImg, -playerImg.width/2, -playerImg.height/2);    
    popMatrix();
  }
  
  void drawEnemy(){
    pushMatrix();
    translate(width - width/8, height/2.5);
    scale(-1, 1);
    image(enemyImg, -enemyImg.width/2, -enemyImg.height/2);
    popMatrix();
  }
  
  // update animation
  void updatePlayerFrames(){
    if (frameCount%animationRate==0) {
      if (currFrame < activePlayerFrames.length-1)
        currFrame++;
      else currFrame=0;
      playerImg=activePlayerFrames[currFrame];
      enemyImg=activeEnemyFrames[currFrame];
    }
  }
};
