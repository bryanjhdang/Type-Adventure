// Please refer to README included

/* CREDIT
 Parisian Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0
 http://creativecommons.org/licenses/by/3.0/
 
 Windswept Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0
 http://creativecommons.org/licenses/by/3.0/
 
 Aurea Carmina - Full Mix Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0
 http://creativecommons.org/licenses/by/3.0/
 
 Rite of Passage Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0
 http://creativecommons.org/licenses/by/3.0/
 
 Master of the Feast Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0
 http://creativecommons.org/licenses/by/3.0/
 
 SFX (potion, battle start) provided here: https://mixkit.co/free-sound-effects/game/?page=2
 
 Wordlist provided here: https://mixkit.co/free-sound-effects/game/?page=2
 
 */

int state;
boolean showingAfterBattleStatus;
int introIdx;
int endIdx;

// minim stuff
import ddf.minim.*;
Minim minim;
AudioPlayer cutsceneAudio;
AudioPlayer overworldAudio;
AudioPlayer tavernAudio;
AudioPlayer castleAudio; 
AudioPlayer fightAudio;
AudioPlayer battleStartAudio;
AudioPlayer potionAudio;

// classes
Player player;
BattleUI battleUI;
AfterBattleStatus afterBattleStatus;
Inventory inventory;
ArrayList<BouncingBall> bouncingBalls = new ArrayList<BouncingBall>();
ArrayList<NPC> npcs = new ArrayList<NPC>();

// buildings
BEnterableBuilding building;
BHouse house;
BTavern tavern;

// temp variables
Enemy fightNPC;
int tempLocation;
PVector tempPlayerPos;
int tempBattleLocation;

// game states
// menus + battle
final int MENU = 0;
final int INTRO_CUTSCENE = -1;
final int END_CUTSCENE = -2; 
final int GAME_OVER = -3;
final int FIGHT = -4;
// rooms
final int PLAYER_BASE = 1;
final int PLAYER_HOUSE = 101;
final int WILDERNESS_1 = 2;
final int WILDERNESS_2 = 3;
final int TOWN = 4;
final int TAVERN = 401;
final int WILDERNESS_3 = 5;
final int WILDERNESS_4 = 6;
final int CASTLE_1 = 7;
final int CASTLE_2 = 8;
final int CASTLE_3 = 9;

// extra
String[] wordlist;
PFont monoFont;

Enemy enemyNPC;

void setup() {
  fullScreen();
  background(255);
  loadAllImages();

  wordlist = loadStrings("wordlist.txt");
  monoFont = loadFont("Monospaced.plain-48.vlw");

  player = new Player(playerIdleFrames[0], new PVector(width/2 + width/8, height/2+height/4), new PVector());
  initializeAllNPCS();

  house = new BHouse(houseBuilding, new PVector(width/4, height/2+height/7), width/16, height/20);
  tavern = new BTavern(tavernBuilding, new PVector(width/2, height/2 + height/7), width/16, height/20);

  inventory = new Inventory(0, 0, 0, 0, 0, 0, 0, 0, false);
  inventory.setIsActiveFalse();

  initializeBouncingBalls();

  minim = new Minim(this);
  cutsceneAudio = minim.loadFile("Kevin MacLeod - Windswept.mp3");
  overworldAudio = minim.loadFile("Kevin MacLeod - Master of the Feast.mp3");
  tavernAudio = minim.loadFile("Kevin MacLeod - Rite of Passage.mp3");
  castleAudio = minim.loadFile("Kevin MacLeod - Parisian.mp3");
  fightAudio = minim.loadFile("Kevin MacLeod - Aurea Carmina - Full Mix.mp3");
  battleStartAudio = minim.loadFile("Battle Start.wav");
  potionAudio = minim.loadFile("Potion.wav");
  pauseAllMusic();

  // menu
  introIdx = 0;
  endIdx = 0;

  // states
  tempLocation = PLAYER_BASE;
  tempPlayerPos = new PVector(width/4, height/2 + height/7); 
  state = MENU;
}

void draw() {
  // states
  switch(state) {
  case MENU:
    menu();
    break;
  case INTRO_CUTSCENE:
    introCutscene();
    break;
  case PLAYER_HOUSE:
    house();
    break;
  case PLAYER_BASE:
    playerBase();
    break;
  case WILDERNESS_1:
    wilderness1();
    break;
  case WILDERNESS_2:
    wilderness2();
    break;
  case TOWN:
    town();
    break;
  case TAVERN:
    tavern();
    break;
  case WILDERNESS_3:
    wilderness3();
    break;
  case WILDERNESS_4:
    wilderness4();
    break;
  case CASTLE_1:
    castle1();
    break;
  case CASTLE_2:
    castle2();
    break;
  case CASTLE_3:
    castle3();
    break;
  case FIGHT:
    fight();
    break;
  case END_CUTSCENE:
    complete();
    break;
  case GAME_OVER:
    death();
    break;
  }

  // displays
  displayAfterBattleStatus();
  displayInventory();
}
