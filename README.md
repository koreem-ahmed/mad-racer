# Mad Racer
Mad Racer is a game where you choose your can and drivers name then you go race on 4 diffrent levels you have Monaco, Monza, Indy, SilverStone after finishing each race the next one will open and when you finnish all the raaces you will see the secret winning screen.

## The Demo


## Controls
move left and right with the 2 arrows
accelerate with the up key
press S to start the race
Press esc to go back from the race to the race menu

## How the game works
The game is mainly built on the retro style like and old arcade game also the assets is from , first of all the choose object node let the user to choose a car with the arrows and enter a name after that they are saved in the globalvars file and the texture is made bey a match case since i  didn't know another way from chaning the path in side the preload funciton so i made it with the preload function it self.

After that there is a global class called car which i inhereted Player car, CPU cars from it. it has like states for each thing the car do like the waiting for the race and the bounce for cracking and the slipping cause the oil and the driving which when you play normally i used tweens to make a simple animation for it

After finishing the race there is a signal to every node that the race is over so the cars stop and the results is desplayed in the same scene of the race thats all in short.

## AI cars geometry
This is the main idea: https://artofproblemsolving.com/wiki/index.php?title=Circumradius
It uses something called wayoiunts which i made like points on the track path and then based on the car skill the car deviate from the way point it self by calculating the distand and the wieght of each path by the link i provided above also the cars deviate in ratio with the diviaiton factor the way point place if it is on a sharp curve or not. 

## The Goal
the goal is to finnish all the races and go to the secret final ending.
