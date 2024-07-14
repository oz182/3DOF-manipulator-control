function [P_target] = SoftFingerGS(alpha)

t = 1; % shear stress
mu = 1;
W = 1; % width
H = 1; % hight

Lambda = alpha * (H / L) + 1;


P_target = (((2*t*mu)/(3*W*(Lambda-1)^2)) * (2*Lambda^3 - 3*Lambda^2 + 6*Lambda^-1 -3*Lambda^-2 -2)) + (((2*t)/H)*(Lambda - Lambda^-3));



end

