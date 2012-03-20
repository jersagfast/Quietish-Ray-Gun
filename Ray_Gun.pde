	/*
Raygun. Pillaged from Blink.
Pete Dokter, Halloween, 2011

All this code does is cycle through some LEDs (blue) while the trigger of the raygun is not active,
and cycle through some audio and all the LEDs (red and blue) when the trigger is active. This is bad
C code, optimized for the minimum time I needed to make it work (which is to say "not at all"). It does,
however, compile and load with Arduino 0022, which is what I used. If you use it in something that makes
money, you're crazy. But I invoke Beerware: if you use it , you may buy me a beer and we'll call it good.

 */

int trigger = 14;
int trigger_value = 0;
int a = 0;
int b = 0;
int c = 0;
int d = 0;
int pulse = 0;
int trip = 0;
int up = 1;

void setup() {                

  pinMode(2, OUTPUT);  //blue
  pinMode(3, OUTPUT);  //blue 
  pinMode(4, OUTPUT);  //blue
  pinMode(5, OUTPUT);  //blue
  pinMode(6, OUTPUT);  //red
  pinMode(7, OUTPUT);  //red
  pinMode(8, OUTPUT);  //red 
  pinMode(10, OUTPUT);  //sound
  
}

void loop() {
  
  //This while loop is redundant, given what "loop" is.
  //Old habits die hard.
  while(1)
  {
      //Initial read for the trigger
      trigger_value = analogRead(trigger);
      
      //If trigger is high, make noise and cycle LEDs. Once through this loop will play
      //a varying pitch, low to high, then set the LEDs
      while (trigger_value >512)
      {
          //This is the sound loop, covered by variables "b" and "c" below. The "c" variable 
          //determines how long to play a given frequency, the "b" variable changes the frequency.
          //As "b" increases, the frequency of the pitch increases.
          for (b = 0; b <=25; b++)
          {
              for (c = 0; c <= 6; c++)
              {
                  digitalWrite(10, HIGH);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, LOW);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, HIGH);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, LOW);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, HIGH);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, LOW);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, HIGH);
                  for (a = 0; a <=50-b; a++);
                  digitalWrite(10, LOW);
                
              }
          }
          
          //After playing the sound, the LEDs, both blue and red, are set to some pattern that I
          //chose almost arbitrarily. The "trip" variable is used to determine what the last pattern
          //was and what the next one will be.
          if (trip == 0)
          {
              digitalWrite(2, HIGH);
              digitalWrite(3, LOW);
              digitalWrite(4, HIGH);
              digitalWrite(5, LOW);
              digitalWrite(6, HIGH);
              digitalWrite(7, HIGH);
              digitalWrite(8, LOW);
              trip = 1;
          }
          
          else if (trip == 1)
          {
              digitalWrite(2, LOW);
              digitalWrite(3, HIGH);
              digitalWrite(4, LOW);
              digitalWrite(5, HIGH);
              digitalWrite(6, LOW);
              digitalWrite(7, HIGH);
              digitalWrite(8, HIGH);
              trip = 2;
          }
          
          else if (trip == 2)
          {
              digitalWrite(2, HIGH);
              digitalWrite(3, HIGH);

              digitalWrite(4, LOW);
              digitalWrite(5, LOW);
              digitalWrite(6, HIGH);
              digitalWrite(7, LOW);
              digitalWrite(8, HIGH);
              trip = 0;
          }
         
         //After the LEDs are cycled, we read the trigger value to see if we should stay in the loop
         //or bail out.
         trigger_value = analogRead(trigger);
         
         //Variables "d" and "pulse" are used in the non-trigger mode for pulsing the blue LEDs on
         //the side of the raygun. I set them to zero here so that it begins the pulse sequence
         //fresh if it drops out of the loop.
         d = 0;
         pulse = 0;
       
      }
      
      //Make sure the red LEDs are off, cuz we're not in the trigger loop
      digitalWrite(6, LOW);
      digitalWrite(7, LOW);
      digitalWrite(8, LOW);
      
      //The blue LED fade works like this: variable "d" keeps track of how many times we've been through
      //the loop, and is compared against the "pulse" variable. Every 50 times through the loop, "pulse"
      //is either incremented or decremented depending on whether it's fading up or down, as determined 
      //by the "up" variable.
      if (d <= pulse) 
      {
          digitalWrite(2, HIGH);  //Make sure they're on when they need to be...
          digitalWrite(3, HIGH);
          digitalWrite(4, HIGH);
          digitalWrite(5, HIGH);
        
      }
      
      else if (d > pulse)
      {
          digitalWrite(2, LOW);  //...and make sure they're off when they need to be.
          digitalWrite(3, LOW);
          digitalWrite(4, LOW);
          digitalWrite(5, LOW);
  
      }
      
      d++;  //increment the loop count
      
      if (d >= 50)  //If we're at the top of the loop count...
      {
          d = 0;    //...reset the loop count...
          
          //...and check to see if we're fading up or down. If we're fading up...
          if (up == 1)
          {
              pulse++; //Increment the pulse width
              if (pulse > 50) up = 0; //If we're at the top of the pulse width, change direction and go down
          }
          
          //Or if we're fading down...
          else if (up == 0)
          {
              pulse--; //Decrement the pulse width
              if (pulse <= 0) up = 1; //If we're at the bottom of the pulse width, change direction and go up
          }
      }
  
   }

}
