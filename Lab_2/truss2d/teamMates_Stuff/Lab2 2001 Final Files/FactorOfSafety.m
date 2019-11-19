u = 4.8;
s = 0.4;
P = 0.05;
Fdist = icdf('normal', P, u, s);
n = (u - Fdist)/s;
FOS = u/(u - (n*s));
