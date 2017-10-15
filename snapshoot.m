N = 40;
r = 0.2;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.5; % the weight for contribution
neigRadius = 1;
iter_num = 100;

punish_prob = 0.6; % punish the bottom 10% players who contributes the least
reward_prob = 1 - punish_prob; % reward the top 10% players who contribute the most
punish_per_player = 0.4; % how much we punish each player whose contribution is smaller than punish_spot

%
StrasMatrix = zeros(N);
StrasMatrix(18 : 22, 18 : 22) = 1;
figure(1)
DrawStraMatrix(StrasMatrix)
% pause(0.01)


% 
PayoffMatr = [R, S; T, P];

% 
PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

CumPaysMat = zeros(N);

% accept
accept_rate = zeros(1, iter_num);

fq_coop = zeros(1, iter_num);

for i = 1:iter_num 
    contributMat = Contribution(PaysMatrix, N, neigRadius);
    spots = quantile(contributMat(:), [punish_prob, reward_prob]);
    punish_ix = find(contributMat < spots(1));
    reward_ix = find(contributMat > spots(2));
    
    reward_pays = punish_per_player * length(punish_ix);
    reward_per_player = reward_pays / length(reward_ix);
    
    PaysMatrix(punish_ix) = PaysMatrix(punish_ix) - punish_per_player;
    PaysMatrix(reward_ix) = PaysMatrix(reward_ix) + reward_per_player;
    
    [StrasMatrix, accept_rate(i)] = Evolution( StrasMatrix, PaysMatrix, ...
        neigRadius, K, K1);  % 
    
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    
    if mod(i, 10) == 0
        figure(i / 10 + 1)
        DrawStraMatrix(StrasMatrix)
    end
    
end
