StringList nerdNPCText;
StringList farmerNPCText;
StringList potionNPCText;
StringList villagerNPCText;
StringList drunkNPCText;
StringList GuardNPCText;
StringList banditNPCText;
StringList banditNPCDeathText;
StringList goblinNPCText;
StringList goblinNPCDeathText;
StringList demonNPCText;
StringList demonNPCDeathText;

void initializeAllNPCS(){
  // nerd
  nerdNPCText = new StringList();
  nerdNPCText.append("HEYYY!");
  nerdNPCText.append("Recently, the demon king woke up from his slumber and bad guys have followed suit. They're terrorizing the citizens!");
  nerdNPCText.append("I asked around, and some people told me there was a weird dude living in this house who could maybe stop them.");
  nerdNPCText.append("Please get rid of him for us!");
  npcs.add(new NPC(nerdNPC, new PVector(width/2, height/2+height/5), PLAYER_BASE, nerdNPCText));
  
  // farmer 
  farmerNPCText = new StringList();
  farmerNPCText.append("Hi there! My name's Dwight, and I'm a farmer.");
  farmerNPCText.append("I got some tips for you. Did you know you can use E to open your inventory? Crazy! Also...");
  farmerNPCText.append("If you ever see that skull in the top left corner, it means that monsters can spawn.");
  farmerNPCText.append("It's dangerous out here, since bandits are running loose. Stay safe!");
  npcs.add(new NPC(farmerNPC, new PVector(width/5, height/2 + height/10), WILDERNESS_1, farmerNPCText));
  
  // potion seller
  potionNPCText = new StringList();
  potionNPCText.append("Oh hey! You seem like a fighter.");
  potionNPCText.append("I sell potions, one for 20 gold!");
  potionNPCText.append("Oh, but if you have 5 then I can't sell anymore. Demand is high these days.");
  potionNPCText.append("Well? How about it? 1 potion for 20 gold sound like a good deal?\n\nENTER TO BUY");
  npcs.add(new NPCPotions(potionNPC, new PVector(width/4 + width/16, height/2 + height/9), WILDERNESS_2, potionNPCText));
  
  // guard 
  GuardNPCText = new StringList();
  GuardNPCText.append("Hey, there. I'm the town guard.");
  GuardNPCText.append("A bandit has been going around town stealing people's water bottles!");
  GuardNPCText.append("Nobody is allowed to leave the town until we find out who it is.");
  GuardNPCText.append("You can pass when he's caught. If you see him, beat him up, will you?");
  npcs.add(new NPC(guardNPC, new PVector(width - width/12, height/2 + height/5), TOWN, GuardNPCText));
  
  // villager
  villagerNPCText = new StringList();
  villagerNPCText.append("Hello!");
  villagerNPCText.append("You're from out of town? That's so cool!");
  villagerNPCText.append("We've had a bandit problem recently... Maybe you could do something about it?");
  npcs.add(new NPC(villagerNPC, new PVector(width/2 - width/6, height/2 + height/3), TOWN, villagerNPCText));
  
  // drunkard
  villagerNPCText = new StringList();
  villagerNPCText.append("HuuhHUuhH?? What are ya staring at! Let me enjoy my drink...");
  villagerNPCText.append("Just between you and me though, I saw that guy over there come in with a clear liquid in a plastic bottle!");
  villagerNPCText.append("Bit suspicous if you ask me...");
  villagerNPCText.append("Huh? Water? What in the world is that? I only know my alcohol, son.");
  npcs.add(new NPC(drunkNPC, new PVector(width/2 - width/6, height/2 + height/8 - 71), TAVERN, villagerNPCText));
  
  // bandit 
  banditNPCText = new StringList();
  banditNPCText.append("Heheheh... I stole all these water bottles!!!");
  banditNPCText.append("Once I create a shortage, I can start selling these at high prices and become rich!");
  banditNPCText.append("... Wait, who are you?!? If you're gonna take this water back, you'll have to fight me for it!\n\nFIGHT");
  
  banditNPCDeathText = new StringList();
  banditNPCDeathText.append("Ugh, why did you do that??? Now my plans are all ruined...");
  banditNPCDeathText.append("I need to call my mom to pick me up.");
  npcs.add(new Enemy(banditNPCImg, new PVector(width/2 + width/6, height/2 + height/8 - 72), 30, 5, 15, 20, TAVERN, banditNPCText, banditNPCDeathText, true, 1));
  
  // goblin 
  goblinNPCText = new StringList();
  goblinNPCText.append("RAAAAWWWWRRRRRRR");
  goblinNPCText.append("I don't actually roar, but the demon king told me to scare off anyone who came here.");
  goblinNPCText.append("I'm being paid for this, so I can't let him down! If it's a fight you want, you can get it!\n\nFIGHT");
  
  goblinNPCDeathText = new StringList();
  goblinNPCDeathText.append("Damn, you're pretty good.");
  goblinNPCDeathText.append("Well, uh, you can pass. I'm not trying to risk my life for a paycheck here.");
  npcs.add(new Enemy(goblinNPCImg, new PVector(width - width/10, height/2 + height/4), 60, 6, 25, 30, WILDERNESS_4, goblinNPCText, goblinNPCDeathText, true, 2));  
  
  // demon 
  demonNPCText = new StringList();
  demonNPCText.append("So you are the one who has been defeating all the monsters lately...");
  demonNPCText.append("We finally meet.");
  demonNPCText.append("You're wondering why I unleashed all these evil beings out into the world?");
  demonNPCText.append("Foolish question! Obviously, for world domination! And if I do, maybe my wife will come back... Anyways!");
  demonNPCText.append("If you want to stop me, I'm prepared to risk my life!");
  demonNPCText.append("We have arrived at this final battle! Bring it!" + "\n\nFIGHT");
  
  demonNPCDeathText = new StringList();
  demonNPCDeathText.append("empty");
  npcs.add(new Enemy(demonNPCImg, new PVector(width/2 + width/6, height/2+height/5), 80, 8, 15, 15, CASTLE_3, demonNPCText, demonNPCDeathText, true, 3));

}
