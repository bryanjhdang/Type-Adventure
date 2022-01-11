// Used to create a list of words that depend on the user inputs to sift through

class Word{
  PVector pos;
  PFont monoFont = loadFont("Monospaced.plain-48.vlw");
  
  // initialize array
  int amount = 10;
  StringList attack;
  char[] attackChar;
  
  // current letter / char and index
  char currentLetter;
  int index;
  
  // character calculations
  boolean inc;
  boolean onSpace;
  boolean afterSpace;
  boolean finished;
  boolean missed;
  
  // string of words
  String fullAttackStr = "";
  float attackStrOffset;
  float fontWidth;
  int charCounter;
  
  // determine accuracy
  boolean perfect;
  int mistakeCounter;
  
  Word(PVector pos, int difficulty){
    this.pos = pos;
    
    attack = new StringList();
    if(difficulty == 1){
      for(int i = 0; i < 10; i++) attack.append(wordlist[(int)random(1000)]);
    }
    if(difficulty == 2){
      for(int i = 0; i < 20; i++) attack.append(wordlist[(int)random(1000)]);
    }

    attackChar = (attack.get(0)).toCharArray();
    inc = false;
    onSpace = false;
    afterSpace = false;
    finished = false;
    missed = false;
    index = 0;
    charCounter = 0;
    
    attackStrOffset = 0;
    for(int i = 0; i < attack.size(); i++){
      fullAttackStr += attack.get(i);
      fullAttackStr += " ";
    }
    
    perfect = true;
    mistakeCounter = 0;
  }
  
  // draw two rectangles covering the sides so that user can't see as it goes past
  void displayWordCover(){
    // white rectangles "cover"
    noStroke();
    fill(255, 200);
    rect(0, 0, width/2, height);
    fill(255);
    rect(0, 0, width/4, height); 
    rect(width - width/4, 0, width/3, height);
    strokeWeight(1);
    stroke(0);
  }
  
  // display the word on the screen
  void displayWord(){  
    textSize(45);
    textAlign(LEFT);
    fill(0);
    if(attack.size() > 0){
      textFont(monoFont);
      text(fullAttackStr, width/2 - attackStrOffset, height/2 - height/12);
      if(missed){
        fill(255, 0, 0);
        stroke(255, 0, 0);
      } else {
        fill(0);
        stroke(0);
      }
      text(currentLetter, width/2, height/2 - height/12);
      fontWidth = textWidth("a");
      rect(width/2 + 2, height/2 - height/13, 25, 1);
    }
  }
  
  // check if the player is typing the correct character
  void checkTyping(){
    if(inc == true){
      if(attack.size() > 0 && index < attack.get(0).length()){
        index++;
      }
      inc = false;
    }
  
    // set current keypress to current char
    if(attack.size() > 0){
      if (index == attack.get(0).length() && afterSpace) {
        resetChar();
      } else if (index == attack.get(0).length()){
        if(attack.size() == 1){
           resetChar();
           finished = true;
        } else {
          currentLetter = ' ';
        }
        onSpace = true;
      } else {
        currentLetter = attackChar[index];
      }
    }
  }
  
  // remove the current character and replace it with the next one in the array
  void resetChar(){
    attack.remove(0);
    if(attack.size() > 0) attackChar = (attack.get(0)).toCharArray();
    afterSpace = false;
    index = 0;
  }
  
  void update(){
    rectMode(CORNER);
    displayWord();
    displayWordCover();
    checkTyping();
  }
  
  // setter
  void setInc() { inc = true; }
  void setOnSpace() { onSpace = true; }
  void setAfterSpace() { afterSpace = true; }
  void increaseAttackStrOffset() { attackStrOffset += fontWidth; }
  void setMissedTrue() { missed = true; }
  void setMissedFalse() { missed = false; }
  void increaseCharCount() { charCounter++; }
  void increaseMistakeCount() { mistakeCounter++; }
  void notPerfect() { perfect = false; }
  
  // getters
  char getCurrentLetter(){ return currentLetter; }
  boolean getFinished() { return finished; }
  int getCharCount() { return charCounter; }
  boolean getPerfect() { return perfect; }
  int getMistakeCount() { return mistakeCounter; }
  
  void clearAttack() { attack.clear(); }
  void fillAttack() { for(int i = 0; i < 10; i++) attack.append(wordlist[(int)random(1000)]); }
};
