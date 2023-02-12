# 3DOF-manipulator-control




https://user-images.githubusercontent.com/91877982/217915156-cac6acad-f66c-40ae-a3db-041c95ef3dc1.mp4





https://user-images.githubusercontent.com/91877982/217915211-b0f023fb-47d0-4c53-ba39-dfa67ef691a5.mp4





Dynamic modeling and position control of 3DOF manipulator, using simulink.

The objective of this part of the project is to gain a hands-on understanding of the control and dynamics of robot’s manipulator with 3 degrees of freedom. In this part, I will present a simulation of the arm, with and without control.

The selected robot arm configuration is a 2 dimensional, “RRR” type of arm, as shown in the picture below:

<img width="154" alt="image" src="https://user-images.githubusercontent.com/91877982/217912857-4558fbd1-32ad-499b-a20d-01e1609f8152.png">

## Dynamics equations

We can derive the robot’s dynamic equations of motion using the Lagrange equation of the form (assuming no external forces applied and no friction):

![image](https://user-images.githubusercontent.com/91877982/217913413-742c67cc-e7ba-4a27-b415-df655ce5615f.png)

Using the numeric solution of this equation, we get the vector τ ̅, which is the torque that needs to be applied on motor of each joint.

Every part of the equation will be constructed using the following methods:

Inertia matrix – To calculate this matrix, we need to find the velocities Jacobians (forward and angular) of each joint. We do that by derive each joint’s center of mass expression (P_c) with every joint’s angle.

![image](https://user-images.githubusercontent.com/91877982/217913557-72c4dd66-e67a-431a-b613-b3ad714dbc60.png)

Because the arm is two-dimensional in this case, the angular Jacobian will be much simple and contain “1” only on the Z values (since the rotation is only around Z axis).

After we calculate the Jacobians for each joint, we can calculate the matrix using the next expression:

![image](https://user-images.githubusercontent.com/91877982/217913621-bd577ed0-70da-498e-a3eb-22fe20ab0bde.png)


Centrifugal and Coriolis matrix – I’ve applied these two matrices, using the following method: First, for 3DOF RRR robotic arm, Matrix C (Centrifugal) and matrix B (Coriolis) are expressed in the following way:

![image](https://user-images.githubusercontent.com/91877982/217913689-191fd37a-95a4-4080-86d0-7eb29d5aff7f.png)


When:

![image](https://user-images.githubusercontent.com/91877982/217913731-a38fb977-17f3-44ff-a75a-820e6f3690c9.png)

![image](https://user-images.githubusercontent.com/91877982/217913773-ca4ec07b-5cc3-4513-a583-182e4808327e.png)


This method is technically applied by 3 nested “for” loops (thus constructing the b matrix).

Gravity matrix – The gravity matrix shows the forces experienced by the robot in the negative y – direction (acceleration due to gravity).

![image](https://user-images.githubusercontent.com/91877982/217913813-8614ac06-7ee8-4140-afdd-ef979d369efe.png)


The equations of my project can be found in the project’s google drive (in the link attached in the introduction). To see the equations, it is necessary to run the “My3Rarm_DynamicEquations.m” MATLAB file. I didn’t write the equations in this document since it is too long. 

## Simulink model

<img width="751" alt="image" src="https://user-images.githubusercontent.com/91877982/217913922-921d542f-e2f6-46f5-ba6f-229e0e60d229.png">


## Model parts

The Simulink model is consisting of the following parts:

•	Manipulator parameters – This block contains the parameters that define each link of the robotic arm (wight, length, inertia). By changing those parameters, the dynamic equations will change as well and affect the behavior of the arm.

•	PD controller – The left part of this simulation (as can be seen in the picture), is the controller of the robotic arm of type PD. It controls directly on the torque for the arm’s motors (3 values – each torque value for each joint). The feedback for the controller is the position and the velocity of each joint. The desired position is given by a preset values (appears on the most left part of the model)

•	Activate control switch – When pressing on this switch, the model will no longer have an active controller (PD controller), instead the arm will move only according to the external forces (in this case, just the gravity).  

•	Ode45 solver – to solve the equations on each time interval, I’ve used the built-in Simulink “Runge-Kutta” solver type called ode45.


## Simulation

•	No control simulation - In this simulation, I’ve added an option to simulate the movement of the arm with no control but the effects of the gravity. The purpose was to show the real dynamics of the arm as well as the effects of the joint’s characteristics (Inertia, mass, length). An animation of this simulation can be found in the project’s google drive (from the link in the introduction), under the name “RRRGravityNOfriction”.

•	“Effects of the PD controller - Now the simulation contains the control of the motor’s torque of each joint. I will present this simulation with several different sets of values (P and D values). The movement will go from the start position (left) to the goal position (right) when the red joint is the base joint: 

<img width="162" alt="image" src="https://user-images.githubusercontent.com/91877982/217914418-d8efc748-9764-4cec-a465-cdb67c16d56e.png"> <img width="179" alt="image" src="https://user-images.githubusercontent.com/91877982/217914433-bd08edb0-4d53-4551-9719-0b96bc5c13d6.png">


<img width="468" alt="image" src="https://user-images.githubusercontent.com/91877982/217914496-feb8c123-243f-426b-ad3b-ed4eba2c4fcd.png">






