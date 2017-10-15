function [ newStrasMatrix , accept_rate] = Evolution( StrasMatrix, PaysMatrix, ...
        neigRadius, fix_coop_players, fix_betray_players, K, K1)

N = length(StrasMatrix);

newStrasMatrix = StrasMatrix;

accept_rate = 0;

for i = 1:N
    for j = 1:N
        myPayoff = PaysMatrix(i,j);
        myStra = StrasMatrix(i,j);
        neighSet = FindAllNeighs(i, j, N, neigRadius);
        newStra_ij = UpdateStra( myPayoff, myStra, neighSet, neigRadius,... 
               StrasMatrix, PaysMatrix, N, K, K1);
        if myStra ~= newStra_ij
            accept_rate = accept_rate + 1;
        end

        if fix_coop_players(i,j) == 1
            newStrasMatrix(i,j) = 1;
        elseif fix_betray_players(i,j) == 1
            newStrasMatrix(i,j) = 0;
        else
            newStrasMatrix(i,j) = newStra_ij;
        end
%          newStrasMatrix(i,j) = newStra_ij;

    end
end

accept_rate = accept_rate / size(StrasMatrix, 1) / size(StrasMatrix, 1);


