

N = 40;
r = 0.4;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.5; % the weight for contribution
neigRadius = 1;
iter_num = 300;

punish_prob = 0.6; % punish the bottom 10% players who contributes the least
reward_prob = 1 - punish_prob; % reward the top 10% players who contribute the most
punish_per_player = [0 0.05 0.1 0.15 0.2 0.25 0.3]; % how much we punish each player whose contribution is smaller than punish_spot

% 博弈支付矩阵
PayoffMatr = [R, S; T, P];




for pun = 1:length(punish_per_player)
    
    fq_coop = zeros(1, iter_num);
    StrasMatrix = initStrasMatrix( N );
    % 邻居间博弈矩阵
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    
    for i = 1:iter_num
        tic

        contributMat = Contribution(PaysMatrix, N, neigRadius);
        spots = quantile(contributMat(:), [punish_prob, reward_prob]);
        punish_ix = find(contributMat < spots(1));
        reward_ix = find(contributMat > spots(2));

        reward_pays = punish_per_player(pun) * length(punish_ix);
        reward_per_player = reward_pays / length(reward_ix);

        PaysMatrix(punish_ix) = PaysMatrix(punish_ix) - punish_per_player(pun);
        PaysMatrix(reward_ix) = PaysMatrix(reward_ix) + reward_per_player;

        [StrasMatrix, ~] = Evolution( StrasMatrix, PaysMatrix, ...
            neigRadius, K, K1);  % 一次演化，更新各节点的策略

        PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

        fq_coop(i) = sum(sum(StrasMatrix));

        toc
        fprintf(['iter ', num2str(i), ' done\n'])

    end
    fq_coop = fq_coop / (N * N);
    
    figure(1)
    hold on
    plot(fq_coop, 'LineWidth', 2)
end






