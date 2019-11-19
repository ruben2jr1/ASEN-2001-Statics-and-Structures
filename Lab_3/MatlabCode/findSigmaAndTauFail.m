% parsing Data given.
function [MeanSigmaFail,MeanTauFail] = findSigmaAndTauFail()
data = xlsread('TestData.xlsx');
data([4,16,19,24,9,7,14],:) = [];
% test number - Force Applied - a - w - f_d
F = data(:,2);
a = data(:,3);
w = data(:,4);
f_d = abs(data(:,5));

% Define Modulus of Elasticity Of Balsa and Foam.
Eb = 3.2953*10^9;
Ef = 0.035483*10^9;

% Define tb tf and distace c -- thickness of material and distance from
% neutral axis.
tb = 7.9357*10^(-4);
t = 0.0206375;
tf = t - 2*tb;
c = t/2;
% Area of Foam is then:
Af = w*tf;
% Find Ib -- 2nd Moment Of balsa.
Ib = 2*w*((1/12)*tb^3 + tb*((tf + tb)/2)^2);
If = (1/12)*w*tf^3;

% indeces Of test which broke in moment.
IM = find(a < f_d);
% indeces of test which broke in shear.
IS = find(a > f_d);

% Moment Failure.
Mfail = a(IM,1).*F(IM,1)/2;
% Shear Failure.
Vfail = F(IS,1)/2;

% Final Sigma and Tau failures.
% SigmaFail
 % figure();
SigmaFail = -Mfail*c./(Ib(IM,1) + Ef/Eb*If(IM,1));
 % scatter(1:length(SigmaFail),SigmaFail);
 % hold on 
MeanSigmaFail = (mean(SigmaFail));
 % plot(1:length(SigmaFail),MeanSigmaFail*ones(length(SigmaFail),1));
% TauFail
 % figure();
TauFail = (3/2)*Vfail./Af(IS,1);
 % scatter(1:length(TauFail),TauFail);
 % hold on
MeanTauFail = (mean(TauFail));
 % plot(1:length(TauFail),MeanTauFail*ones(length(TauFail),1));
end