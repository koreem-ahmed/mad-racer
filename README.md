# Mad Racer
Mad Racer is a game where you choose your car and driver's name then you go race on 4 different levels you have Monaco, Monza, Indy, Silverstone after finishing each race the next one will open and when you finish all the races you will see the secret winning screen.
## The Demo
http://koreem-ahmed.itch.io/mad-racer

## Controls
move left and right with the 2 arrows <br>
accelerate with the up key <br>
press S to start the race <br>
Press esc to go back from the race to the race menu <br>

## How the game works
The game is mainly built on the retro style like and old arcade game also the assets is from , first of all the choose object node let the user to choose a car with the arrows and enter a name after that they are saved in the globalvars file and the texture is made bey a match case since i  didn't know another way from chaning the path in side the preload funciton so i made it with the preload function it self.
<br>
After that there is a global class called car which i inhereted Player car, CPU cars from it. it has like states for each thing the car do like the waiting for the race and the bounce for cracking and the slipping cause the oil and the driving which when you play normally i used tweens to make a simple animation for it
<br>
After finishing the race there is a signal to every node that the race is over so the cars stop and the results is desplayed in the same scene of the race thats all in short.
<br>
## AI cars mechanism
AI cars use waypoints which are vectors with x and y coordinates this gives them like a specific path to go on it and there is a deviation factor so it doesn't feel like an AI. <br>
It uses something called waypoints which I made like points on the track path and then based on the car skill the car deviates from the waypoint itself by calculating the distance and the weight of each path by the link I provided above also the cars deviate in ratio with the deviation factor the waypoint place if it is on a sharp curve or not. <br>
This is the main idea: https://artofproblemsolving.com/wiki/index.php?title=Circumradius

## The Goal
the goal is to finnish all the races and go to the secret final ending.
