// NPCs
PImage nerdNPC;
PImage farmerNPC;
PImage potionNPC;
PImage villagerNPC;
PImage guardNPC;
PImage drunkNPC;
PImage banditNPCImg;
PImage goblinNPCImg;
PImage demonNPCImg;
PImage playerImg;

// scenes + displays
PImage wildAreaIcon;
PImage houseBuilding;
PImage tavernBuilding;
PImage houseBG;
PImage playerBaseBG;
PImage wilderness1BG;
PImage wilderness2BG;
PImage townBG;
PImage tavernBG;
PImage wilderness3BG;
PImage wilderness4BG;
PImage castle1BG;
PImage castle2BG;
PImage castle3BG;

// menu
PImage menuImg;
PImage cutscene1Img;
PImage cutscene2Img;
PImage cutscene3Img;
PImage endCutscene1Img;
PImage endCutscene2Img;
PImage gameOverImg;

// animations
PImage[] playerWalkFrames = new PImage[4];
PImage[] playerIdleFrames = new PImage[6];
PImage[] battlePlayerIdleFrames = new PImage[6];
PImage[] battleBanditIdleFrames = new PImage[6];
PImage[] battleGoblinIdleFrames = new PImage[6];
PImage[] battleDemonIdleFrames = new PImage[6];

// re-intialize bouncing balls
boolean canInitializeBalls;

// menu screen state
void menu(){
  background(255);
  image(menuImg, 0, 0);
  pushMatrix();
  translate(width/2, height/2);
  image(playerImg, -playerImg.width/2, -playerImg.height/2);
  popMatrix();
  
  // show movement instructions
  textFont(monoFont);
  textSize(30);
  fill(0);
  textAlign(LEFT);
  text("Controls: WASD to move, Enter to interact", width/24, height - height/16);
}

// intro state; show cutscenes
void introCutscene(){
  background(255);
  //playMusic(cutsceneAudio);
  //cutsceneAudio.play();
  cutsceneAudio.loop();
  
  if (introIdx == 1){
    image(cutscene1Img, 0, 0);
    showText("Ever since I was a kid, I could see words...\nI had a power, but the other kids just called me weird.");
  } else if (introIdx == 2){
    image(cutscene2Img, 0, 0);
    showText("Today, I'm just laying in my bed, listening to music.\nHuh? What's that noise?");
  } else if (introIdx == 3){
    image(cutscene3Img, 0, 0);
    showText("There's a knock at the door. I wonder what it is...?");
  } else if (introIdx == 4){
    cutsceneAudio.pause();
    state = PLAYER_HOUSE;
  }
}

// ------------------ EVERY SCENE ---------------------------
// inside house
void house(){
  background(255);
  image(houseBG, 0, 0);
  
  // update music
  overworldAudio.pause();
  
  // update rendering
  house.update();
  checkRender(PLAYER_HOUSE);
  playerMove(); 
}

// outside of house
void playerBase(){
  background(255);
  image(playerBaseBG, 0, 0);
  playMusic(overworldAudio);
  
  // update rendering 
  house.update();  
  checkRender(PLAYER_BASE);
  playerMove();
}

void wilderness1(){
  background(255);
  image(wilderness1BG, 0, 0);
  checkRandomEncounter(1);
  playMusic(overworldAudio);
  
  // update rendering 
  checkRender(WILDERNESS_1);
  playerMove();
  
  drawWildAreaIcon();
}

void wilderness2(){
  background(255);
  image(wilderness2BG, 0, 0);
  playMusic(overworldAudio);
  
  checkRandomEncounter(2);
  
  // update rendering 
  checkRender(WILDERNESS_2);
  playerMove();
  
  drawWildAreaIcon();
}

void town(){
  background(255);
  image(townBG, 0, 0);
  
  // handle audio
  tavernAudio.pause();
  playMusic(overworldAudio);
  
  // handle rendering
  tavern.update();
  checkRender(TOWN);
  playerMove();
}

void tavern(){
  background(255);
  image(tavernBG, 0, 0);

  // handle audio
  overworldAudio.pause();
  playMusic(tavernAudio);
  
  // handle rendering
  tavern.update();
  checkRender(TAVERN);
  playerMove();
}

void wilderness3(){
  background(255);
  image(wilderness3BG, 0, 0);
  playMusic(overworldAudio);
  checkRandomEncounter(3); 
  
  // handle rendering
  checkRender(WILDERNESS_3);
  playerMove();
  
  drawWildAreaIcon();
}

void wilderness4(){
  background(255);
  image(wilderness4BG, 0, 0);
  checkRandomEncounter(4);
  
  // handle audio
  castleAudio.pause();
  playMusic(overworldAudio);
  
  // handle rendering
  checkRender(WILDERNESS_4);
  playerMove();
  
  drawWildAreaIcon();
}

void castle1(){
  background(255);
  image(castle1BG, 0, 0);
  checkRandomEncounter(5);
  
  // handle audio
  overworldAudio.pause();
  playMusic(castleAudio);
  
  // set it so that you can re-intialize balls for next room
  canInitializeBalls = true;
  
  // handle rendering
  checkRender(CASTLE_1);
  playerMove();
  
  drawWildAreaIcon();
}

void castle2(){
  background(255);
  image(castle2BG, 0, 0);
  
  if(canInitializeBalls){
    initializeBouncingBalls();
    canInitializeBalls = false;
  }
  
  // handle audio
  overworldAudio.pause();
  playMusic(castleAudio);
  
  // handle rendering
  checkRender(CASTLE_2);
  playerMove();
  updateAllBalls();
}

void castle3(){
  if(((Enemy)npcs.get(8)).getDead()){
    pauseAllMusic();
    state = END_CUTSCENE;
  } else {
    playMusic(castleAudio);
    background(255);
    
    // set it so that you can re-intialize balls for previous room
    canInitializeBalls = true;
    
    // handle rendering
    if(!((Enemy)npcs.get(8)).getDead()){
      image(castle3BG, 0, 0);
      checkRender(CASTLE_3);
      playerMove();
    }
  }
}

// update fight in battleUI
void fight(){
  background(255);
  battleUI.update();
}

// show when game is complete
void complete(){
  background(255);
  playMusic(cutsceneAudio);
  
  // go through cutscene
  if (endIdx == 0){
    image(endCutscene1Img, 0, 0);
    showText("And with that, the demon lord was no more.\nPeace returned and I went back home.");
  } else if (endIdx == 1){
    image(endCutscene2Img, 0, 0);
    showText("... Time for a nap!");
  } else if (endIdx == 2){
    textAlign(CENTER);
    fill(0);
    textFont(monoFont);
    textSize(80);
    text("THE END", width/2, height/2);
    textSize(40);
    text("Press enter to play again", width/2, height/2 + height/10);
  } else if (endIdx == 3){
    resetAll();
  }
}

// show death screen
void death(){
  pauseAllMusic();
  image(gameOverImg, 0, 0);
  
  textAlign(CENTER);
  fill(255);
  textFont(monoFont);
  textSize(80);
  text("GAME OVER!", width/2, height/4);
  textSize(40);
  text("Press enter to play again", width/2, height - height/5);
}

// ----------- DISPLAYS ------------

void displayAfterBattleStatus(){
  // dont display the status menu after beating the final boss
  if(state == CASTLE_3 && afterBattleStatus != null){
    if(afterBattleStatus.getIsActive()){
      afterBattleStatus.disableDisplay();
    }
  }
  
  if(afterBattleStatus != null && state != CASTLE_3){
    afterBattleStatus.display();
  }
}

void displayInventory(){
  if(inventory != null){
    inventory.display();
  }
}

// see if render player or npc in front or behind
void checkRender(int currLocation){
  for(int i = 0; i < npcs.size(); i++){ // render npc behind
    NPC npc = npcs.get(i);
    if(player.isInFront(npc)){
      if(currLocation == npc.getLocation()){
        npc.update();
      }
    }
  }
  
  player.update();
   
  for(int i = 0; i < npcs.size(); i++){ // render npc in front
    NPC npc = npcs.get(i);
    if(!player.isInFront(npc)){
      if(currLocation == npc.getLocation()){
        npc.update();
      }
    }
  }
}

// player movement
void playerMove(){
  if(!player.getFrozen() && !showingAfterBattleStatus){
    if (up) player.accelerate(upAcc);
    if (left) player.accelerate(leftAcc);
    if (right) player.accelerate(rightAcc);
    if (down) player.accelerate(downAcc);
  } 
}

// generate random encounter
void checkRandomEncounter(int difficulty){
  if(!inventory.getIsActive() && (left || right || up || down) && (player.getVelX() != 0 || player.getVelY() != 0)){
    int temp = (int)random(0, 200);
    if(temp == 0){
      tempBattleLocation = state;
  
      // generate random encounter according to difficulty
      if(difficulty == 1){
        battleUI = new BattleUI(1, (int)random(5, 7), (int)random(2,3), 3, (int)random(1, 3), false, false);
      } else if (difficulty == 2){
        battleUI = new BattleUI((int)random(1,3), (int)random(6, 10), (int)random(2, 5), 4, (int)random(3, 5), false, false);
      } else if (difficulty == 3){
        battleUI = new BattleUI((int)random(1,4), (int)random(13, 18), (int)random(3, 6), 7, (int)random(5, 9), false, false);
      } else if (difficulty == 4){
        battleUI = new BattleUI(3, (int)random(16, 24), (int)random(4, 7), 9, (int)random(7, 11), false, false);
      } else if (difficulty == 5){
        battleUI = new BattleUI(1, (int)random(23, 30), (int)random(6, 11), 12, (int)random(9, 13), false, false);
      }
      
      inventory.setIsActiveFalse();
      state = FIGHT;
    }
  }
}

// go inside a building
void changeLocation(){
  tempPlayerPos = new PVector(player.getPosX(), player.getPosY());
  player.removeVel();
  player.setPosX(player.getWidth());
  player.setPosY(height/2 + height/4);
  player.setFacingRight();
}

void loadAllImages(){
  playerImg = loadImage("player_idle_1.png");
  playerImg.resize(playerImg.width/2, playerImg.height/2);
  
  // regular images
  wildAreaIcon = loadImage("skull.png");
  wildAreaIcon.resize(wildAreaIcon.width/6, wildAreaIcon.height/6);
  
  // load NPCs
  nerdNPC = loadImage("npc_nerd.png");
  nerdNPC.resize(nerdNPC.width/5, nerdNPC.height/5);
  farmerNPC = loadImage("npc_farmer.png");
  farmerNPC.resize(farmerNPC.width/5, farmerNPC.height/5);
  potionNPC = loadImage("npc_potion.png");
  potionNPC.resize(potionNPC.width/5, potionNPC.height/5);
  villagerNPC = loadImage("npc_villager.png");
  villagerNPC.resize(villagerNPC.width/5, villagerNPC.height/5);
  guardNPC = loadImage("npc_guard.png");
  guardNPC.resize(guardNPC.width/5, guardNPC.height/5);
  drunkNPC = loadImage("npc_drunk.png");
  drunkNPC.resize(drunkNPC.width/5, drunkNPC.height/5);
  // enemies
  banditNPCImg = loadImage("bandit_idle_1.png");
  banditNPCImg.resize(banditNPCImg.width/5, banditNPCImg.height/5);
  goblinNPCImg = loadImage("goblin_idle_1.png");
  goblinNPCImg.resize(goblinNPCImg.width/5, goblinNPCImg.height/5);
  demonNPCImg = loadImage("demon_idle_1.png");
  demonNPCImg.resize(demonNPCImg.width/5, demonNPCImg.height/5);
  
  // animation
  loadFrames(playerWalkFrames, "player_walk_");
  loadFrames(playerIdleFrames, "player_idle_");
  loadFrames(battlePlayerIdleFrames, "player_idle_");
  loadFrames(battleBanditIdleFrames, "bandit_idle_");
  loadFrames(battleGoblinIdleFrames, "goblin_idle_");
  loadFrames(battleDemonIdleFrames, "demon_idle_");
  
  // backgrounds
  houseBuilding = loadImage("house.png");
  tavernBuilding = loadImage("tavern.png");
  houseBG = loadImage("bg_house.png");
  playerBaseBG = loadImage("bg_outside_house.png");
  wilderness1BG = loadImage("bg_wilderness1.png");
  wilderness2BG = loadImage("bg_wilderness2.png");
  townBG = loadImage("bg_town.png");
  tavernBG = loadImage("bg_tavern.png");
  wilderness3BG = loadImage("bg_wilderness3.png");
  wilderness4BG = loadImage("bg_wilderness4.png");
  castle1BG = loadImage("bg_castle1.png");
  castle2BG = loadImage("bg_castle2.png");
  castle3BG = loadImage("bg_castle3.png");
  
  // menu / cutscenes
  menuImg = loadImage("display_menu.png");
  cutscene1Img = loadImage("display_cutscene1.png");
  cutscene2Img = loadImage("display_cutscene2.png");
  cutscene3Img = loadImage("display_cutscene3.png");
  endCutscene1Img = loadImage("display_endcutscene1.png");
  endCutscene2Img = loadImage("display_endcutscene2.png");
  gameOverImg = loadImage("bg_game_over.png");
}

// load animation frames
void loadFrames(PImage[] ar, String fname) {  
  for (int i=0; i<ar.length; i++) {
    PImage frame=loadImage(fname+i+".png");
    
    // change size if battle or not
    if (ar == playerWalkFrames) frame.resize(80, 160);
    if (ar == playerIdleFrames) frame.resize(80, 160);
    if (ar == battlePlayerIdleFrames) frame.resize(140, 280);
    if (ar == battleBanditIdleFrames) frame.resize(140, 280);
    if (ar == battleGoblinIdleFrames) frame.resize(140, 280);
    if (ar == battleDemonIdleFrames) frame.resize(140, 280);
    ar[i]=frame;
  }
}

// draw a pimage on screen
void drawWildAreaIcon(){
  pushMatrix();
  translate(width/15, height/10);
  image(wildAreaIcon, -wildAreaIcon.width/2, -wildAreaIcon.height/2);
  popMatrix();
}

// show text on screen
void showText(String s){
  textFont(monoFont);
  textSize(45);
  fill(0);
  textAlign(CENTER, CENTER);
  text(s, width/2, height-height/6);
}

void resetAll(){
  pauseAllMusic();
  bouncingBalls.clear();
  npcs.clear();
  setup();
}

// play a song
void playMusic(AudioPlayer music){
  if(!music.isPlaying()){
    music.play(0);
  }
}

// pause all songs
void pauseAllMusic(){
  cutsceneAudio.pause();
  overworldAudio.pause();
  tavernAudio.pause();
  castleAudio.pause(); 
  fightAudio.pause();
  battleStartAudio.pause();
  potionAudio.pause();
}

// pause all songs that aren't used in battle; used for battle purposes
void pauseAllNonBattleMusic(){
  cutsceneAudio.pause();
  overworldAudio.pause();
  tavernAudio.pause();
  castleAudio.pause(); 
}

// update the bouncing balls in castle 2 state
void updateAllBalls(){
  for(int i = 0; i < bouncingBalls.size(); i++){
    bouncingBalls.get(i).update();
  }
}

// intiailize bouncing balls
void initializeBouncingBalls(){
  bouncingBalls.clear();
  bouncingBalls.add(new BouncingBall(new PVector(width/6, 0), new PVector(0, 7), 75, 75));
  bouncingBalls.add(new BouncingBall(new PVector(width/2 - width/8, height/2), new PVector(0, 10), 75, 75));
  bouncingBalls.add(new BouncingBall(new PVector(width/2 + width/8, 0), new PVector(0, 7), 75, 75));
  bouncingBalls.add(new BouncingBall(new PVector(width - width/6, height/2), new PVector(0, 10), 75, 75));
}
