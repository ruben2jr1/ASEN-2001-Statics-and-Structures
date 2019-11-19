%% Getting M(x) and V(x).
syms x p0 W % p0 L sigmaFail tauFail c Ib Ef Eb If Af W tb tf FOS

L = 0.9104;
% p0 = 714;
% q(x) is defined as.
q = -(0.1016*p0*sqrt(1 - (2*x/L)^2));
% F for the whole Beam is:
F = int(q,x,[-L/2 L/2]);
% F = int(q,x,[-L/2 0]);
% Therefore V(x) can be found from the shear diagram as.
V = -F/2 + int(q,x,[-L/2 x]);
% M(x) is then ...
% M = V*x + (int(x*q,x,[-L/2 x])) - F*L/4;
M = int(V,x,[-L/2 x]);

% fplot(M,[-L/2 L/2]);
%% Solving for p0
% Subbing x = 0;
M_0 = subs(M,x,0);
% We can then solve for Po:
%  found_P0 = solve((sigmaFail + (M_0*c/(Ib + (Ef/Eb)*If)))==0,p0);
% --- Note that is only in terms of constants.
% We know Sigma fail as: 
[SigmaFail,TauFail] = findSigmaAndTauFail();
% We can then define the constants within the sigmaFail and ...
% tauFail equations.
%==========================================================================
% In this case width (w) is assumed to be:
width = 0.1016;
% Define Modulus of Elasticity Of Balsa and Foam.
Ebalsa = 3.2953*10^9;
Efoam = 0.035483*10^9;

% Define tb tf and distace c -- thickness of material and distance from
% neutral axis.
tbalsa = 7.9357*10^(-4);
tfoam = 1.905*10^(-2);
cSub = (1/2)*tfoam + tbalsa;
% Area of Foam is then:
Afoam = width*tfoam;
% Find Ib -- 2nd Moment Of balsa.
Ibalsa = 2*width*((1/12)*tbalsa^3 + tbalsa*((tfoam + tbalsa)/2)^2);
Ifoam = (1/12)*width*tfoam^3;
%==========================================================================
% p0 is is then:
found_P0 = solve((SigmaFail + (M_0*cSub/(Ibalsa + (Efoam/Ebalsa)*Ifoam)))==0,p0);
% found_P0 = subs(found_P0,[sigmaFail,Ib,Ef,If,Eb,c,L],[SigmaFail,Ibalsa,Efoam,Ifoam,Ebalsa,cSub,length]);
found_P0 = simplify(found_P0);
found_P0 = double(found_P0);
%% Find W(x).
% Now that we have p0 we find w(x) almost in the same way.
% except instead of holding x as zero we let it roam through out the 
% fields of student tears.
% First solve for width function with respect to Moment requirements.
% found_P0 = 379;
FOS = 1.6;

% Saving p0 to access in other file.
save('p0','found_P0');

% Width by Bending.
M_Sub_P0 = subs(M,p0,found_P0);
W_Bending = solve((SigmaFail/FOS + M_Sub_P0*cSub/(W*(1/6*tbalsa^3 + 2*tbalsa*((tfoam + tbalsa)/2)^2 + Efoam/Ebalsa*1/12*tfoam^3)))==0,W);
% W_Bending = subs(W_Bending,[sigmaFail,FOS,c,tb,tf,Eb,Ef],[SigmaFail,FactorOfSafety,cSub,tbalsa,tfoam,Ebalsa,Efoam]);
W_Bending = simplify(W_Bending);
MaxW_BendingValue = double(subs(W_Bending,x,0));
% fplot(W_Bending,[0 L/2]); % There are 39.4 in in 1 meter
hold on

% Finding width by Shear.
V_Sub_P0 = subs(V,[p0 L],[found_P0 L]);
W_Shear = solve(TauFail/FOS + (3/2)*V_Sub_P0/(W*tfoam)==0,W);
% W_Shear = subs(W_Shear,[tauFail,FOS,tf],[TauFail,FactorOfSafety,tfoam]);
W_Shear = simplify(W_Shear);
MaxW_ShearValue = double(subs(W_Shear,x,-L/2));
% fplot(abs(W_Shear),[0 L/2]); % There are 39.4 in in 1 meter

% MaxW_General = double(subs((W_Bending + abs(W_Shear))/MaxW_BendingValue*(2/39.4),x,0.055));
% fplot((W_Bending + abs(W_Shear))/MaxW_BendingValue*(2/39.4),[0 length/2]);
% ylim([0 MaxW_General]);
% xlim([0 (length/2)]);
%% Evaluating Width functions.
X_Bending = linspace(0,L/2,10);
X_Shear = linspace(0,L/2,10);

Y_Bending = zeros(1,length(X_Bending));
Y_Shear = zeros(1,length(X_Bending)); % So we can tweek one number.

for i = 1:length(X_Bending)
    Y_Bending(1,i) = double(subs(W_Bending,x,X_Bending(1,i)));
    Y_Shear(1,i) = double(subs(W_Shear,x,X_Shear(1,i)));
end

% Converting to cm. --> Notice only plotting for top right corner of board.
Y_Bending = Y_Bending/MaxW_BendingValue*5.08;
Y_Shear = Y_Shear/MaxW_BendingValue*5.08;

X_Bending = X_Bending*(1/(L/2))*45.72;
X_Shear = X_Shear*(1/(L/2))*45.72;


scatter(X_Bending,Y_Bending);
hold on 
scatter(X_Shear,Y_Shear);

xlabel('Beam - 0 to L/2 (cm)');
ylabel('Beam - 0 to W/2 (cm)');
title('Overlayed Width Requirements');

%% Prediction of Force at failure. 
% Note this includes weight of tree 
% Becuase this is what the beam feels.
F = int(q,x,[-L/2 L/2]);
F_Fail_Prediction = double(subs(F,p0,found_P0)); %N

