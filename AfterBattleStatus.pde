// After a fight, draws a status menu that displays the things that the player has earned.
// This could be exp, coins, or even when the player levels up.

class AfterBattleStatus{
  // stat gains
  int expGain;
  int coinGain;
  boolean levelUp;
  int increaseInAtk;
  int increaseInHealth;
  
  // use to check if display or not
  boolean isActive;
  
  // dimensions
  float rectWidth = width/1.8;
  float rectHeight = height/1.8;
  float buttonWidth = width/8;
  float buttonHeight = height/13;
  float buttonOffset = width/9;
  float topTextHeight = height/2 - rectHeight/2 + buttonHeight + buttonHeight/4;
  float offsetBetweenText = height/15;
  float offsetBetweenLevelUp = height/18;
  float levelUpTextOffset = offsetBetweenText + height/12;
  
  AfterBattleStatus(int expGain, int coinGain, boolean levelUp, int increaseInAtk, int increaseInHealth){
    this.expGain = expGain;
    this.coinGain = coinGain;
    this.levelUp = levelUp;
    this.increaseInAtk = increaseInAtk;
    this.increaseInHealth = increaseInHealth;
    
    isActive = true;
  }
  
  // show ui elements
  void display(){
    if(isActive){
      if(levelUp){
        // rectangle
        drawRectangle();
        
        // button
        drawButton();
        
        // text
        textFont(monoFont);
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(40);

        text("Gained " + expGain + " exp!", width/2, topTextHeight);
        text("Gained " + coinGain + " coins!", width/2, topTextHeight + offsetBetweenText);
        text("Level Up!", width/2, topTextHeight + levelUpTextOffset);
        text("+" + increaseInHealth + " HP", width/2, topTextHeight + levelUpTextOffset + offsetBetweenLevelUp);
        text("+" + increaseInAtk + " Attack", width/2, topTextHeight + levelUpTextOffset + offsetBetweenLevelUp*2);
      }
      
      if(!levelUp){  
        // rectangle
        drawRectangle();
        
        // button
        drawButton();
        
        // text
        textFont(monoFont);
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(40);

        text("Gained " + expGain + " exp!", width/2, height/2 - offsetBetweenText);
        text("Gained " + coinGain + " coins!", width/2, height/2);
        
      }
    }
  }
  
  // draw an empty rectangle
  void drawRectangle(){
    fill(255);
    rectMode(CENTER);
    rect(width/2, height/2, rectWidth, rectHeight);
  }
  
  // draw button
  void drawButton(){
    fill(100, 40);
    rectMode(CENTER);
    rect(width/2, height/2 + buttonOffset, buttonWidth, buttonHeight);
    textFont(monoFont);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("OK", width/2, height/2 + buttonOffset);
  }
  
  // call this to remove the status on screen
  void disableDisplay(){
    isActive = false;
    player.setHasLeveledUpFalse();
  }
  
  // getters / setters
  boolean getIsActive() { return isActive; }
  void setIsActiveFalse() { isActive = false; }
};
