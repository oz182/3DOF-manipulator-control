syms q1 q2 q3 q1_p q2_p q3_p q1_pp q2_pp q3_pp tau1 tau2 tau3
syms L1 L2 L3 m1 m2 m3 I1_zz I2_zz I3_zz

%% Crate Dynamic equations



%L1 = 1;
%L2 = 1;
%L3 = 1;

Lc1 = L1/2;
Lc2 = L2/2;
Lc3 = L3/2;

%m1 = 1;
%m2 = 1;
%m3 = 1;

%I1_zz = 1;
%I2_zz = 1;
%I3_zz = 1;

Pc1 = [Lc1*cos(q1) ; Lc1*sin(q1); 0];
Pc2 = [L1*cos(q1)+Lc2*cos(q1+q2) ; L1*sin(q1)+Lc2*sin(q1+q2) ; 0];
Pc3 = [L1*cos(q1)+L2*cos(q1+q2)+Lc3*cos(q1+q2+q3) ; L1*sin(q1)+L2*sin(q1+q2)+Lc3*sin(q1+q2+q3) ; 0];

fprintf('\nCalculating Jacobians... ');

Jv1 = [diff(Pc1, q1) diff(Pc1, q2) diff(Pc1, q3)];
Jv2 = [diff(Pc2, q1) diff(Pc2, q2) diff(Pc2, q3)];
Jv3 = [diff(Pc3, q1) diff(Pc3, q2) diff(Pc3, q3)];

Jw1 = [0,0,0;
       0,0,0;
       1,0,0;];
Jw2 = [0,0,0;
       0,0,0;
       1,1,0;];
Jw3 = [0,0,0;
       0,0,0;
       1,1,1;];
   
fprintf('DONE');

fprintf('\nConstructing Mass Matrix... ');
   
IC1 = [0 0 0 ;
    0 0 0;
    0 0 I1_zz];
IC2 = [0 0 0 ;
    0 0 0;
    0 0 I2_zz];
IC3 = [0 0 0 ;
    0 0 0;
    0 0 I3_zz];

mv1 = transpose(Jv1)*Jv1*m1;
mv2 = transpose(Jv2)*Jv2*m2;
mv3 = transpose(Jv3)*Jv3*m3;

mw1 = transpose(Jw1)*IC1*Jw1;
mw2 = transpose(Jw2)*IC2*Jw2;
mw3 = transpose(Jw3)*IC3*Jw3;

M_q = mv1 + mv2 + mv3 + mw1+ mw2 + mw3;

fprintf('DONE');
fprintf('\nConstructing Centrifugal and Coriolis Matrices... ');

q = [q1;q2;q3];
n = length(q);
for i = 1:1:n
    for j = 1:1:n
        for k = 1:1:n
            m_ijk = diff(M_q(i,j),q(k));
            m_ikj = diff(M_q(i,k),q(j));
            m_jki = diff(M_q(j,k),q(i));
            b(i,j,k) = 1/2*(m_ijk+m_ikj-m_jki);
            %C_q(i,j) = b(i,j,j); % Centrifugal matrix C(q)
            %B_q(i,j) = 2*b(i,j,j);
        end
    end
end
C_q = [b(1,1,1) b(1,2,2) b(1,3,3);
       b(2,1,1) b(2,2,2) b(2,3,3);
       b(3,1,1) b(3,2,2) b(3,3,3)];
B_q = 2*[b(1,1,2) b(1,1,3) b(1,2,3);
        b(2,1,2) b(2,1,3) b(2,2,3);
        b(3,1,2) b(3,1,3) b(3,2,3)];

V_q = C_q*[q1_p^2; q2_p^2; q3_p^2] + B_q*[q1_p*q2_p; q1_p*q3_p; q2_p*q3_p];
fprintf('DONE');

fprintf('\nConstructing Gravity Matrix... ');

L1 = 4;
L2 = 3;
L3 = 2;
m1 = 20;
m2 = 15;
m3 = 10;
I1_zz = 0.5;
I2_zz = 0.2;
I3_zz = 0.1;

g = 9.81;
G_q = -(transpose(Jv1)*[0; -m1*g; 0] + transpose(Jv2)*[0; -m2*g; 0] + transpose(Jv3)*[0; -m3*g; 0]);

fprintf('DONE');
fprintf('\nCalculating Tau Vector... ');

eq_tau = [tau1; tau2; tau3] == M_q*[q1_pp; q2_pp; q3_pp] + V_q + G_q;

fprintf('DONE');
fprintf('\nSolving for q_pp''s... ');

sol = solve(eq_tau, q1_pp, q2_pp, q3_pp);
q1_pp = simplify(sol.q1_pp);
q2_pp = simplify(sol.q2_pp);
q3_pp = simplify(sol.q3_pp);

fprintf('DONE');
fprintf('\nSolving for tau''s... ');

sol = solve(eq_tau, tau1, tau2, tau3);
tau1 = simplify(sol.tau1);
tau2 = simplify(sol.tau2);
tau3 = simplify(sol.tau3);

fprintf('DONE');


