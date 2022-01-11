// Used to display screen / inventory elements when 'E' button is pressed
// Shows off fields present in the class

class Inventory{
  // stats
  int level;
  int experience;
  int expUntilNextLvl;
  float health;
  float maxHealth;
  int attack;
  int coins;
  int amountOfPotions;
  boolean hasItemOne;
  
  // use to check if display or not
  boolean isActive;
  
  // dimensions
  float rectWidth = width/2;
  float rectHeight = height/1.4;
  float offsetAgainstWall = rectWidth/15;
  float offsetBetweenTextUpper = height/14;
  float offsetBetweenTextLower = height/18;
  
  Inventory(int level, int experience, int expUntilNextLvl, float health, float maxHealth, int attack, int coins, int amountOfPotions, boolean hasItemOne){
    this.level = level;
    this.experience = experience;
    this.expUntilNextLvl = expUntilNextLvl;
    this.health = health;
    this.maxHealth = maxHealth;
    this.attack = attack;
    this.coins = coins;
    this.amountOfPotions = amountOfPotions;
    this.hasItemOne = hasItemOne;
    
    isActive = true;
  }
  
  // display inventory if the class isActive
  void display(){
    if(isActive){
      player.setFrozen(true);
      
      fill(255);
      rectMode(CENTER);
      rect(width/2, height/2, rectWidth, rectHeight);
      line(width/2 - rectWidth/2, height/2, width/2 + rectWidth/2, height/2);
      
      // draw stats
      textFont(monoFont);
      fill(0);
      textAlign(LEFT, CENTER);
      textSize(40);
      text("ID CARD - ME", width/2 - rectWidth/2 + offsetAgainstWall, height/2 - offsetBetweenTextUpper*4);
      if(level < 10) text("LVL: " + level, width/2 - rectWidth/2 + offsetAgainstWall, height/2 - offsetBetweenTextUpper*3);
      textSize(30);
      if(level < 10) text(" ("+expUntilNextLvl+" exp until next)", width/2 - rectWidth/2 + offsetAgainstWall + rectWidth/6, height/2 - offsetBetweenTextUpper*3);
      textSize(40);
      if(level == 10) text("LVL: MAX", width/2 - rectWidth/2 + offsetAgainstWall, height/2 - offsetBetweenTextUpper*3);
      text("HP: " + (int)health + "/" + (int)maxHealth, width/2 - rectWidth/2 + offsetAgainstWall, height/2 - offsetBetweenTextUpper*2);
      text("ATK: " + (attack-ceil((float)level/2)) + "-" + (attack+ceil((float)level/2)), width/2 - rectWidth/2 + offsetAgainstWall, height/2 - offsetBetweenTextUpper);
      
      // draw items
      textSize(35);
      text("CRUD IN MY BAG", width/2 - rectWidth/2 + offsetAgainstWall, height/2 + offsetBetweenTextLower);
      text(coins + " coins", width/2 - rectWidth/2 + offsetAgainstWall, height/2 + offsetBetweenTextLower*2);
      text(amountOfPotions + " potions (+" +player.getRecoveryAmount()+" HP)", width/2 - rectWidth/2 + offsetAgainstWall, height/2 + offsetBetweenTextLower*3);
      if(hasItemOne) text("Some water bottles", width/2 - rectWidth/2 + offsetAgainstWall, height/2 + offsetBetweenTextLower*4);
    }
  }
  
  // call this to stop the display
  void disableDisplay(){
    isActive = false; 
  }
  
  boolean getIsActive() { return isActive; }
  void setIsActiveFalse() { isActive = false; }
}
