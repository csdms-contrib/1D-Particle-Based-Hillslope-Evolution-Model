function [w,h] = make_moves(p,w)
%% MAKE_MOVES administers the dynamics to the gradient profile w.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

% Calculate the rates.
rates = calc_rates(p,w);

% Generate a random vector.
u = rand(size(rates));

% Calculate the jump latencies. Note that the times matrix has three
% columns.
times = -1.*log(u)./(rates);

% Pick the smallest latency.
[min_row_times,col_choice_by_row] = min(times,[],2);

% Determine the move to which this corresponds. Note that move = 1 means
% left, move = 2 means right.

[~,row_of_min_time] = min(min_row_times);
move = col_choice_by_row(row_of_min_time);

%% Update the gradient vector.
r = row_of_min_time;

% If you're at the left boundary...
if r == 1
    if move == 1
        w(r,1) = w(r,1) - 1;
    elseif move == 2
        w(r,1) = w(r,1) - 1;
        w(r+1,1) = w(r+1,1) + 1;
    end
% If you're at the site just before the right boundary...
elseif r == length(w)
    if move == 1
        w(r,1) = w(r,1) - 1;
        w(r-1,1) = w(r-1,1) + 1;
    elseif move == 2
        w(r,1) = w(r,1) - 1;
    end  
else
    if move == 1
        w(r,1) = w(r,1) - 1;
        w(r-1,1) = w(r-1,1) + 1;
    elseif move == 2
        w(r,1) = w(r,1) - 1;
        w(r+1,1) = w(r+1,1) + 1;
    end
end

%% Update the height vector.
h = zeros(length(w)+1,1);

for j = length(w):-1:1
    h(j,1) = w(j,1) + h(j+1,1);
end