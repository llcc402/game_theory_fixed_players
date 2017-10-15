clear
clc

N = 40;
r = 0.2;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.5; % the weight for contribution
neigRadius = 1;
iter_num = 300;

punish_prob = [0.1 0.3 0.5 0.7 0.9]; % punish the bottom 10% players who contributes the least
reward_prob = 1 - punish_prob; % reward the top 10% players who contribute the most
punish_per_player = 0.5; % how much we punish each player whose contribution is smaller than punish_spot

% figure(1)
% DrawStraMatrix(StrasMatrix)
% title('Initial StrasMatrix')
% pause(0.01)

PayoffMatr = [R, S; T, P];

for pp = 1:5
    StrasMatrix = initStrasMatrix( N );
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    fq_coop = zeros(1, iter_num);

    for i = 1:iter_num

        contributMat = Contribution(PaysMatrix, N, neigRadius);
        spots = quantile(contributMat(:), [punish_prob(pp), reward_prob(pp)]);
        punish_ix = find(contributMat < spots(1));
        reward_ix = find(contributMat > spots(2));

        reward_pays = punish_per_player * length(punish_ix);
        reward_per_player = reward_pays / length(reward_ix);

        PaysMatrix(punish_ix) = PaysMatrix(punish_ix) - punish_per_player;
%         PaysMatrix(reward_ix) = PaysMatrix(reward_ix) + reward_per_player;

        [StrasMatrix, ~] = Evolution( StrasMatrix, PaysMatrix, ...
            neigRadius, K, K1);  % 

        PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

        fq_coop(i) = sum(sum(StrasMatrix));
        
    end
    fq_coop = fq_coop / (N * N);
    hold on
    plot(fq_coop, 'LineWidth', 2)
end

% figure(3)
% DrawStraMatrix(StrasMatrix)
% title(['StrasMatrix after ', num2str(iter_num), ' iterations'])


