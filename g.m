function xplus = g(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file               Author: Yuchun Li
%
% 
%
% Description: Jump map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global A H1 H2 H3 K11 K12 K22 K23 K31 K33 gamma dropoutrate
global T11 T12 T21 T22 T31 T32
% states
n = length(A);
xp      = x(1:n);               % state of the consensus variable
xo1     = x(n+1:2*n);
xo2     = x(2*n+1:3*n);
xo3     = x(3*n+1:4*n);
eta1    = x(4*n+1:5*n);
eta2    = x(5*n+1:6*n);
eta3    = x(6*n+1:7*n);
timer  = x(end-2:end);


xpplus  = xp; 
xo1plus = xo1;
xo2plus = xo2;
xo3plus = xo3;
eta1plus = eta1;
eta2plus = eta2;
eta3plus = eta3;
timerplus = timer;

% noise
% m1 = rand + sin(rand);
% m2 = rand + cos(rand);
m1 = 0; m2 = 0; m3 = 0;

if rand <= dropoutrate
    drop = 0;
else
    drop = 1;
end

% measurement
yy1 = H1*xp + m1;
yy2 = H2*xp + m2;
yy3 = H3*xp + m3;

index = find(timer <= 0, 1, 'first');

if index == 1
    timerplus(index) = T11 + (T12 - T11)*rand;
    eta1plus = K11*(H1*xo1 - yy1) + drop*K12*(H2*xo2 - yy2) + drop*gamma*(xo1 - xo2);
end

if index == 2
    timerplus(index) = T21 + (T22 - T21)*rand;
    eta2plus = K22*(H2*xo2 - yy2) + drop*K23*(H3*xo3 - yy3)+ drop*gamma*(xo2 - xo3);
end

if index == 3
    timerplus(index) = T31 + (T32 - T31)*rand;
    eta3plus = drop*K31*(H1*xo1 - yy1) + K33*(H3*xo3 - yy3)+ drop*gamma*(xo3 - xo1);
end


xplus = [xpplus;...
         xo1plus;...
         xo2plus;...
         xo3plus;...
         eta1plus;...
         eta2plus;...
         eta3plus;...
         timerplus];
             
end