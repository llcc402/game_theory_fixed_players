clear
clc

N = 40;
r = 0.2;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.9; % the weight for contribution
neigRadius = 1;
iter_num = 300;

% special parameters for this setting
fix_coop_prob = 0.1;
fix_betray_prob = 0.1;

% init fixed players
fix_coop_players = rand(N);
fix_betray_players = rand(N);

% generate fixed players
fix_coop_players(fix_coop_players < fix_coop_prob) = 1;
fix_coop_players(fix_coop_players ~= 1) = 0;
fix_betray_players(fix_betray_players < fix_betray_prob) = 1;
fix_betray_players(fix_betray_players ~= 1) = 0;

%
StrasMatrix = initStrasMatrix( N );
% figure(1)
% DrawStraMatrix(StrasMatrix)
% title('Initial StrasMatrix')
% pause(0.01)

% 
PayoffMatr = [R, S; T, P];

% 
PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

% accept
accept_rate = zeros(1, iter_num);

fq_coop = zeros(1, iter_num);

for i = 1:iter_num
    tic
    
    [StrasMatrix, accept_rate(i)] = Evolution( StrasMatrix, PaysMatrix, ...
        neigRadius, fix_coop_players, fix_betray_players, K, K1);  % 
    
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    
    fq_coop(i) = sum(sum(StrasMatrix));
    
    toc
    fprintf(['iter ', num2str(i), ' done\n'])
end


fq_coop = fq_coop / (N * N);
figure(2)
plot(fq_coop, 'LineWidth', 2)
title('Proportion of cooperators in each iteration')

% figure(3)
% DrawStraMatrix(StrasMatrix)
% title(['StrasMatrix after ', num2str(iter_num), ' iterations'])


