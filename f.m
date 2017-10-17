function xdot = f(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file                Author: Yuchun Li
%
% 
%
% Description: Flow map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% global data -----------
global A G h1 h2 h3

% states
n = length(A);
N = length(G);
xp      = x(1:n);               % state of the consensus variable
xo1     = x(n+1:2*n);
xo2     = x(2*n+1:3*n);
xo3     = x(3*n+1:4*n);
eta1    = x(4*n+1:5*n);
eta2    = x(5*n+1:6*n);
eta3    = x(6*n+1:7*n);
% timer  = x(end-1:end);

xpdot  = A*xp;
xo1dot = A*xo1 + eta1;
xo2dot = A*xo2 + eta2;
xo3dot = A*xo3 + eta3;
eta1dot = h1*eta1;
eta2dot = h2*eta2;
eta3dot = h3*eta3;
timerdot = -ones(N, 1);

xdot = [xpdot;...
        xo1dot;...
        xo2dot;...
        xo3dot;...
        eta1dot;...
        eta2dot;...
        eta3dot;...
        timerdot]; 
    
end