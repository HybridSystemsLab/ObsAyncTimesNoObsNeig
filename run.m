%%% simulation of intermittent observer
%%% plant is 3d, unstable 
%%% three agents are connected through circular graph
%%% no one can reconstruct the state without communication

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file                Author: Yuchun Li
%
% Main function
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% global data -----------
clear all
global G A H1 H2 H3 K11 K12 K13 K21 K22 K23 K31 K32 K33 gamma 
global T11 T12 T21 T22 T31 T32 h1 h2 h3 dropoutrate

% plant information 
A  = [0.1 0 0;0 0.1 0;0 0 0.1]; 
H1 = [1 0 0]; 
H2 = [0 1 0];
H3 = [0 0 1];

%%% parameters 
T11 = 0.1; T12 = 0.3;
T21 = 0.3; T22 = 0.4;
T31 = 0.2; T32 = 0.5;
K11 = [-2.5 -0 -0]';
K12 = [0 -.2 -0]';
K13 = zeros(3,1);
K21 = zeros(3,1);
K22 = [-0 -3 -0]';
K23 = [-.2 -0.3 -0.4]';
K31 = [-.2 0 -0.3]';
K32 = zeros(3,1);
K33 = [-0 -0 -2.5]';
gamma = -0.7;
h1 = -2.1;
h2 = -2.1;
h3 = -2.1;
dropoutrate = -1; % no dropout for -1, complete drop out for 1

%%%% Graph - 3 agents, circular graph
G = [0 1 0;0 0 1;1 0 0];

%%% -----------------------
% IC for plant states
xp0 = [1 1 1]';

% IC for agent1;
xo10 = [1 1 1]';
eta10 = [1 1 1]';
timer10 = 0.1;

% IC for agent2;
xo20 = [-1 1 -1]';
eta20 = [-1 -1 -1]';
timer20 = 0.2;

% IC for agent3;
xo30 = [-1 -1 -1]';
eta30 = [-1 1 -1]';
timer30 = 0.3;

y0 = [xp0; xo10; xo20; xo30; eta10; eta20; eta30; timer10; timer20; timer30]; 

% simulation horizon
TSPAN = [0 60];
JSPAN = [0 200000];

% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;

options = odeset('RelTol',1e-1,'MaxStep',1e-2);

% simulate
[t y j] = hybridsolver(@f,@g,@C,@D,y0,TSPAN,JSPAN,rule,options,1);

    e11 = (y(:,1) - y(:,4));
    e12 = (y(:,2) - y(:,5));
    e13 = (y(:,3) - y(:,6));
    
    e21 = (y(:,1) - y(:,7));
    e22 = (y(:,2) - y(:,8));
    e23 = (y(:,3) - y(:,9));
    
    e31 = (y(:,1) - y(:,10));
    e32 = (y(:,2) - y(:,11));
    e33 = (y(:,3) - y(:,12));

    e = sqrt(e11.^2 + e12.^2 + e13.^2 + e21.^2 + e22.^2 + e13.^2 + ...
        e31.^2 + e32.^2 + e33.^2);
    
    figure(1)
    clf
    plot(t,e)
    hold on 
    
K12 = [0 -0.2 -0.2]'*0;    
K23 = [0.2 -0.3 0]'*0;
K31 = [-0.2 0 -0.3]'*0;
    
    [t y j] = hybridsolver(@f,@g,@C,@D,y0,TSPAN,JSPAN,rule,options,1);

    e11 = (y(:,1) - y(:,4));
    e12 = (y(:,2) - y(:,5));
    e13 = (y(:,3) - y(:,6));
    
    e21 = (y(:,1) - y(:,7));
    e22 = (y(:,2) - y(:,8));
    e23 = (y(:,3) - y(:,9));
    
    e31 = (y(:,1) - y(:,10));
    e32 = (y(:,2) - y(:,11));
    e33 = (y(:,3) - y(:,12));

    e = sqrt(e11.^2 + e12.^2 + e13.^2 + e21.^2 + e22.^2 + e13.^2 + ...
        e31.^2 + e32.^2 + e33.^2);    
    
    
    figure(1)
    plot(t,e)
    legend('Kik neq 0', 'Kik = 0')
    return

%% plot components estimation error
figure(2)
clf
rate = 20;
subplot(3,1,1)
% plot(t(1:rate:end), y(1:rate:end,1),'r','linewidth',2)
hold on
plot(t(1:rate:end), y(1:rate:end,4)-y(1:rate:end,1),'r-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,7)-y(1:rate:end,1),'b-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,10)-y(1:rate:end,1),'g-','linewidth',1.5)
grid on; box on  
set(gca,'FontSize',20)
legend('x11', 'x21', 'x31')
axis([0 5 -25, 25])
xlabel('t')
subplot(3,1,2)
% plot(t(1:rate:end), y(1:rate:end,2),'r','linewidth',2)
hold on
plot(t(1:rate:end), y(1:rate:end,5)-y(1:rate:end,2),'r-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,8)-y(1:rate:end,2),'b-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,11)-y(1:rate:end,2),'g-','linewidth',1.5)
grid on; box on  
set(gca,'FontSize',20)
legend('x12', 'x22', 'x32')
axis([0 5 -25, 25])
xlabel('t')
subplot(3,1,3)
% plot(t(1:rate:end), y(1:rate:end,3),'r','linewidth',2)
hold on
plot(t(1:rate:end), y(1:rate:end,6)-y(1:rate:end,3),'r-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,9)-y(1:rate:end,3),'b-','linewidth',1.5)
plot(t(1:rate:end), y(1:rate:end,12)-y(1:rate:end,3),'g-','linewidth',1.5)
grid on; box on 
set(gca,'FontSize',20)
legend('x13', 'x23', 'x33')
axis([0 5 -25, 25])
xlabel('t')

return
%% plot timer
figure
subplot(3,1,1)
plotHarcT(t,j,y(:,end-2),'b')
grid on; set(gca,'FontSize',20); legend('tau1')
axis([0 5 0 0.65]); xlabel('t')

subplot(3,1,2)
plotHarcT(t,j,y(:,end-1),'b')
grid on; set(gca,'FontSize',20); legend('tau2')
axis([0 5 0 0.65]); xlabel('t')
subplot(3,1,3)
% plot(t(1:rate:end), y(1:rate:end,3),'r','linewidth',2)
hold on
plotHarcT(t,j,y(:,end),'b')
grid on; set(gca,'FontSize',20); legend('tau3')
axis([0 5 0 0.65]); xlabel('t')