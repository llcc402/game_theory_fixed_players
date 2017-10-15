clear
clc

N = 40;
r = 0.2;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.9; % the weight for contribution
neigRadius = 1;
iter_num = 300;
PayoffMatr = [R, S; T, P];

% special parameters for this setting
prob = [0.05 0.1 0.15 0.2 0.25];

for kk = 1:5
    fix_coop_prob = prob(kk);
    fix_betray_prob = prob(kk);

    % init fixed players
    fix_coop_players = rand(N);
    fix_betray_players = rand(N);

    % generate fixed players
    fix_coop_players(fix_coop_players < fix_coop_prob) = 1;
    fix_coop_players(fix_coop_players ~= 1) = 0;
    fix_betray_players(fix_betray_players < fix_betray_prob) = 1;
    fix_betray_players(fix_betray_players ~= 1) = 0;

    StrasMatrix = initStrasMatrix( N );

    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

    % accept
    accept_rate = zeros(1, iter_num);

    fq_coop = zeros(1, iter_num);

    for i = 1:iter_num

        [StrasMatrix, accept_rate(i)] = Evolution( StrasMatrix, PaysMatrix, ...
            neigRadius, fix_coop_players, fix_betray_players, K, K1);  % 

        PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

        fq_coop(i) = sum(sum(StrasMatrix));

    end

    fq_coop = fq_coop / (N * N);
    hold on
    plot(fq_coop, 'LineWidth', 2)

end



