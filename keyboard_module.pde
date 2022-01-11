PVector upAcc = new PVector(0, -1);
PVector downAcc = new PVector(0, 1);
PVector leftAcc = new PVector(-1, 0);
PVector rightAcc = new PVector(1, 0);
boolean up, down, left, right;

final int LOWER_TO_UPPER= 'a'-'A';

void keyPressed(){
  if(keyCode=='A' || keyCode=='a'){
    left = true;
    if(state != FIGHT) player.setFacingLeft();  // used to determine where player is facing
  }
  if(keyCode=='W' || keyCode=='w') up = true;
  if(keyCode=='S' || keyCode=='s') down = true;
  if(keyCode=='D' || keyCode=='d'){
    right = true;
    if(state != FIGHT) player.setFacingRight();  // used to determine where player is facing
  }
  
  // menu
  if(state == MENU){
    if(keyCode==ENTER){
      state = INTRO_CUTSCENE;
    }
  }
  
  // go through intro cutscenes
  if(state == INTRO_CUTSCENE){
    if(keyCode==ENTER){
      introIdx++;
    }
  }
  
  // go through ending cutscenes
  if(state == END_CUTSCENE){
    if(keyCode==ENTER){
      endIdx++;
    }
  }
  
  // reset from death
  if(state == GAME_OVER){
    if(keyCode==ENTER){
      resetAll();
    }
  }

  // NPC interaction
  for(int i = 0; i < npcs.size(); i++){
    NPC npc = npcs.get(i);
      if(keyCode==ENTER && state != FIGHT && !player.getFrozen()){
          player.checkInteraction(npc);
          player.setTalking(true);
          if(player.getInteraction() && npc.checkCollision()){
            if(npc instanceof Enemy){
              //println(npc);
              fightNPC = (Enemy)npc;
            }
            if(npc.checkCollision()) npc.increaseTextIndex();
          }
      }
  }
  
  // Building interaction  
  if(keyCode==ENTER && state != FIGHT && !player.getFrozen()){
    if(house.getDetectPlayer()){
      changeLocation();
      house.setDetectPlayerFalse();
      state = PLAYER_HOUSE;
    }
    if(tavern.getDetectPlayer()){
      changeLocation();
      tavern.setDetectPlayerFalse();
      state = TAVERN;
    }
  }
  
  // open / close inventory
  if(keyCode=='E' || keyCode=='e'){
    if(inventory != null && state >= 1  && (!player.getTalking())){
      if(inventory.getIsActive()){     // close inventory
        inventory.setIsActiveFalse();
        player.setFrozen(false);
      } else if (!inventory.getIsActive()){      // open inventory
        inventory = new Inventory(player.getLevel(),
                                  player.getExperience(),
                                  player.getExpUntilNextLevel(),
                                  player.getHealth(),
                                  player.getMaxHealth(),
                                  player.getAttack(),
                                  player.getCoins(), 
                                  player.getPotionAmount(),
                                  player.getHasItemOne());
        player.setFrozen(true);
      }
    }
  }
  
  // unfreeze after battle status button
  if(afterBattleStatus != null && afterBattleStatus.getIsActive()){
    if(keyCode == ENTER){
      afterBattleStatus.disableDisplay();
      player.setFrozen(false);
    }
  }
  
  // battle typing
  if(state == FIGHT){
    // menu phase
    if(battleUI.getBattlePhase() == 0 && !battleUI.getFrozen()){
      if(keyCode=='A' || keyCode=='a') battleUI.moveButtonLeft();
      if(keyCode=='D' || keyCode=='d') battleUI.moveButtonRight();
      
      if(keyCode==ENTER && battleUI.getMenuButton() == 0) battleUI.startFightPhase();
      if(keyCode==ENTER && battleUI.getMenuButton() == 1) battleUI.usePotion();
      if(keyCode==ENTER && battleUI.getMenuButton() == 2) battleUI.leave();
    }
    
    // fight phase
    if(battleUI.getBattlePhase() == 1){
      if(keyCode==battleUI.word.getCurrentLetter()||keyCode==(battleUI.word.getCurrentLetter() - LOWER_TO_UPPER)){
        battleUI.word.setInc();
        battleUI.word.increaseAttackStrOffset();
        if(battleUI.word.getCurrentLetter() == ' '){
          battleUI.word.setOnSpace();
          battleUI.word.setAfterSpace();
        }
        battleUI.word.setMissedFalse();
        battleUI.word.increaseCharCount();
      } else if (keyCode!=battleUI.word.getCurrentLetter()||keyCode!=(battleUI.word.getCurrentLetter() - LOWER_TO_UPPER)){
        if(!(battleUI.word.getCharCount() == 0 && keyCode == ENTER)){
          battleUI.word.setMissedTrue();
          battleUI.word.increaseMistakeCount();
          battleUI.word.notPerfect();
        }
      }  
    }
  }
}

void keyReleased(){
  if(keyCode=='A' || keyCode=='a') left = false;
  if(keyCode=='W' || keyCode=='w') up = false;
  if(keyCode=='S' || keyCode=='s') down = false;
  if(keyCode=='D' || keyCode=='d') right = false;
  if(!left && !up && !down && !right){
    player.removeVel(); // get rid of velocity when player is not holding anything
  }
}
