% Code for finding weight positioning.
% Tree Test.

syms x

% Positioning for wiffle tree is every L/8.
% Where L is:
L = 0.914;
p0 = load('p0','found_P0');
p0 = p0.found_P0;

q = -(0.1016*p0*sqrt(1 - (2*x/L)^2));


L1 = 0.1524;
L2 = 0.3048;
L3 = L1 + L2;

F1 = int(q,x,[-4*L/8 (-4*L/8 + L/8)]);
c1 = int(x*q,x,[-4*L/8 (-4*L/8 + L/8)])/int(q,x,[-4*L/8 (-4*L/8 + L/8)]);
F1 = double(F1);
c1 = double(c1)*39.4;

F2 = int(q,x,[-3*L/8 (-3*L/8 + L/8)]);
c2 = int(x*q,x,[-3*L/8 (-3*L/8 + L/8)])/int(q,x,[-3*L/8 (-3*L/8 + L/8)]);
F2 = double(F2);
c2 = double(c2)*39.4;

% Distance from outer bar to inner bar. 1 level wiffle tree.

L1_1 = F2*L1/(F1 + F2)*39.4; %

F3 = int(q,x,[-2*L/8 (-2*L/8 + L/8)]);
c3 = int(x*q,x,[-2*L/8 (-2*L/8 + L/8)])/int(q,x,[-2*L/8 (-2*L/8 + L/8)]);
F3 = double(F3);
c3 = double(c3)*39.4; % there are 39.4 inches in 1 meter.

F4 = int(q,x,[-L/8 (-L/8 + L/8)]);
c4 = int(x*q,x,[-L/8 (-L/8 + L/8)])/int(q,x,[-L/8 (-L/8 + L/8)]);
F4 = double(F4);
c4 = double(c4)*39.4; %

L1_2 = F4*L1/(F3 + F4)*39.4; %

% Wiffle tree second level.
F5 = F1 + F2;
F6 = F3 + F4;
L2_1 = F6*L2/(F5 + F6)*39.4; %