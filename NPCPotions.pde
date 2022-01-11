// Subclass of NPC
// After reaching max text index of the conversation, the player loses money and gets a potion

class NPCPotions extends NPC{
  
  NPCPotions(PImage img, PVector pos, int location, StringList convo){
    super(img, pos, location, convo);
  }
  
  // override check conversation to include giving potions to player at the end
  void checkConversation() {
    if (player.getInteraction()) {
        // regular text
        if(textIndex < convo.size()){
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

        // end of conversation
        if(textIndex == convo.size()){
          
          // if player has less than 5 potion and 20 coins, give potion and take away 20 coins
          if(player.getPotionAmount() < 5 && player.getCoins() >= 20){
            player.decreaseCoins(20);
            player.gainPotion();
          }
          
          textIndex = -1;
          hasBeenTalkedTo = true;
        }
    } else {
      textIndex = -1;
    }
  }
}
