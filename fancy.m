clear
clc

N = 40;
r = 0.2;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.9; % the weight for contribution
neigRadius = 1;
iter_num = 200;

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
StrasMatrix = zeros(N);
StrasMatrix(18 : 22, 18 : 22) = 1;
DrawStraMatrix(StrasMatrix)

% 
PayoffMatr = [R, S; T, P];

% 
PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

% accept
accept_rate = zeros(1, iter_num);

fq_coop = zeros(1, iter_num);

for i = 1:iter_num
    
    [StrasMatrix, accept_rate(i)] = Evolution( StrasMatrix, PaysMatrix, ...
        neigRadius, fix_coop_players, fix_betray_players, K, K1);  % 
    
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    
    if mod(i, 20) == 0
        figure(i / 20 + 1)
        DrawStraMatrix(StrasMatrix)
    end

end

% figure(3)
% DrawStraMatrix(StrasMatrix)
% title(['StrasMatrix after ', num2str(iter_num), ' iterations'])


