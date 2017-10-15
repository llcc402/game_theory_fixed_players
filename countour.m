
%------------------------ fixed parameters --------------------------------
N = 40;
R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi


neigRadius = 1;
iter_num = 100;

punish_prob = 0.1; % punish the bottom 10% players who contributes the least
reward_prob = 1 - punish_prob; % reward the top 10% players who contribute the most
punish_per_player = 0.1; % how much we punish each player whose contribution is smaller than punish_spot

%----------------------- parameters to change -----------------------------
T = [1.1 1.3 1.5 1.7 1.9];
K1 = [0.1 0.3 0.5 0.7 0.9]; % the weight in contribution

coop_result_mat = zeros(length(T), length(K1));

%----------------------- main loops ---------------------------------------
for k = 1:length(K1);
    for t = 1:length(T);
        % 初始化策略矩阵
        StrasMatrix = initStrasMatrix( N );
        % 博弈支付矩阵
        PayoffMatr = [R, S; T(t), P];

        % 邻居间博弈矩阵
        PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
        tic
        for i = 1:iter_num

            contributMat = Contribution(PaysMatrix, N, neigRadius);
            spots = quantile(contributMat(:), [punish_prob, reward_prob]);
            punish_ix = find(contributMat < spots(1));
            reward_ix = find(contributMat > spots(2));

            reward_pays = punish_per_player * length(punish_ix);
            reward_per_player = reward_pays / length(reward_ix);

            PaysMatrix(punish_ix) = PaysMatrix(punish_ix) - punish_per_player;
            PaysMatrix(reward_ix) = PaysMatrix(reward_ix) + reward_per_player;

            [StrasMatrix, ~] = Evolution( StrasMatrix, PaysMatrix, ...
                neigRadius, K, K1(k));  % 一次演化，更新各节点的策略

            PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

        end
        coop_result_mat(t, k) = sum(sum(StrasMatrix)) / N / N
        toc
    end
end



