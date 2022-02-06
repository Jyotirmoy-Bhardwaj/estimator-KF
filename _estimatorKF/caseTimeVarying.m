%Case-I: Estimation of water level in all the tanks. Here, we have
%observations of all the levels from the sensor nodes. No data is missing
%from sensor node.

close all;
clearvars;
T=1;
T2=200;
c=0.1;
r=0.05;
n=4; %number of tanks
alpha1=0.1; alpha2=0.1; alpha3=0.1; alpha4=0.1; %define liner approximation parameter
s1=1; s2=1; s3=0.5; s4=0.1; % Define the base dimensions of every tank in m^2
L=zeros(4,T); %L2=zeros(T,1); L3=zeros(T,1); L4=zeros(T,1); % Assigning level 
%vector to all the tanks  
L(1,1)=5; % Initial water level of Tank_1 in liters 
L(2,1)=5; % Initial water level of tank_2  in liters
L(3,1)=5; % Initial water level of tank_3 in liters
L(4,1)=10; % Initial water level of tank_4 in liters
c_s=0.1; %Refer equation 30 of the text. Use to initialise MSE

%Define equation 14 of the text given as f[n]=z[n]+u[n], where f[n]=[f1_in, f2_in, f3_out, f4_out]^T
%z[n]= [z_{1in}[n], z_{2in}[n], z_{3eout}[n], z_{4eout}[n]^T and {u[n]} is gaussian has mean 0 and variance Q, 


%where z1_in, z2_in, z3_eout and z4_eout with some mean
%value defined in meters as:
t=[0:T2]';
z1_in=1*abs(sin(2*pi*r*t)); z2_in=1*abs(sin(2*pi*r*t)); z3_eout=0.5*abs(sin(2*pi*r*t)); z4_eout=0.5*abs(sin(2*pi*r*t));


%In addition defining
t=[0:T2]';
q1=0.01*abs(sin(2*pi*r*t)); q2=0.01*abs(sin(2*pi*r*t)); q3=0.01*abs(sin(2*pi*r*t)); q4=0.01*abs(sin(2*pi*r*t)); 
c_s=0.1; %refer equation 30 of text for info
%so defining Q=[q1 0 0 0;0 q2 0 0; 0 0 q3 0;0 0 0 q4]; in matrix form



%Hence,
f1_in= z1_in+q1.*randn(T2+1,1); % In_flow rate of tank 1 in liters/sec or (m^3)/sec)
f2_in= z2_in+q2.*randn(T2+1,1); % In_flow rate of tank 1 in liters/sec or (m^3)/sec)
f3_eout=z3_eout+q3.*randn(T2+1,1); % Out_flow rate of tank 3
f4_eout=z4_eout+q4.*randn(T2+1,1);% % Out_flow rate of tank 4

f=[f1_in,f2_in,f3_eout,f4_eout]';

p1=T*alpha1/s1;
p2=T*alpha2/s2;
p3=T*alpha3/s3;
p4=T*alpha4/s4;

%Define A:State Transition Matrix
A=[(1-p1) 0 0 0;0 (1-p2) 0 0;T*alpha1/s3 T*alpha2/s3 (1-p3) 0;0 0 T*alpha3/s4 (1-p4)];

%Define G
G=[(T/s1) 0 0 0; 0 (T/s2) 0 0; 0 0 -(T/s3) 0; 0 0 0 -(T/s4)]; 
Z=[z1_in';z2_in';z3_eout';z4_eout'];
u=f-Z;
B=[T/s1 0 0 0; 0 T/s2 0 0; 0 0 -T/s3 0; 0 0 0 -T/s4];

for t=1:T2
    L(:,t+1)=A*L(:,t)+G*Z(:,t)+B*u(:,t); 
end

% Kalman equations
l_hat=zeros(n,4);
Mt=c_s*eye(4);%[0.1 0 0 0;0 0.1 0 0; 0 0 0.1 0; 0 0 0 0.1]; % Initialising observation covariance matrix
Ct=c*eye(4);% observation co-variance matrix
C=[c 0 0 0;0 c 0 0;0 0 c 0;0 0 0 c]; %Observation/measurement co-variance matrix 
Xt1=L(1,:)'+C(1,1)*randn(T2+1,1); %Observation for tank 1  
Xt2=L(2,:)'+C(2,2)*randn(T2+1,1); %Observation for tank 2  
Xt3=L(3,:)'+C(3,3)*randn(T2+1,1); %Observation for tank 3
Xt4=L(4,:)'+C(4,4)*randn(T2+1,1); %Observation for tank 4  
yt=[Xt1';Xt2';Xt3';Xt4']; 
Ht=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]; % Measurement Matrix


for t=1:T2
Z=[z1_in(t);z2_in(t);z3_eout(t);z4_eout(t)];
Q=[q1(t) 0 0 0;0 q2(t) 0 0;0 0 q3(t) 0;0 0 0 q4(t)];
l_hat_pre(:,t)=A*l_hat(:,t)+G*Z;
Mt_pre=A*Mt*A'+B*Q*B';
%
Kt=Mt_pre*Ht'*(Ht*Mt_pre*Ht'+Ct)^-1;
l_hat(:,t+1)=l_hat_pre(:,t)+Kt*(yt(:,t)-Ht*l_hat_pre(:,t));
Mt=(eye(n)-Kt*Ht)*Mt_pre;
end
l_hat(:,1:end-1)=l_hat(:,2:end); % To adjust the time lag of estimated values

figure(1);
plot(0:T2,l_hat(1,:),0:T2,yt(1,:),0:T2,L(1,:)) % Plot Estimation, Measurement and True-level of Tank 1 in (m)
legend('Estimation-Tank1','Measuerment-Tank1','True level-Tank1')
title('Estimation, Measurement and True-level of Tank 1 in (m)')
xlabel('Time Period in minutes') 
ylabel('Water Level in meters (m)') 

figure(2);
plot(0:T2,l_hat(2,:),0:T2,yt(2,:),0:T2,L(2,:)) % Plot estimation, measurement and level of Tank 2
legend('Estimation-Tank2','Measuerment-Tank2','True level-Tank2')
title('Estimation, Measurement and True-level of Tank-2 in (m)')
xlabel('Time Period in minutes') 
ylabel('Water Level in meters (m)') 


figure(3);
plot(0:T2,l_hat(3,:),0:T2,yt(3,:),0:T2,L(3,:)) % Plot estimation, measurement and level of Tank 3
legend('Estimation-Tank3','Measuerment-Tank3','True level-Tank3')
title('Estimation and True-level of Tank-3 in (m)')
xlabel('Time Period in minutes') 
ylabel('Water Level in meters (m)') 

figure(4);
plot(0:T2,l_hat(4,:),0:T2,yt(4,:),0:T2,L(4,:)) % Plot estimation, measurement and level of Tank 4
legend('Estimation-Tank4','Measuerment-Tank4','True level-Tank4')
title('Estimation, Measurement and True-level of Tank 4 in (m)')
xlabel('Time Period in minutes') 
ylabel('Water Level in meters (m)') 

