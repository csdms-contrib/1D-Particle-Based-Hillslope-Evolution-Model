%% ZRP_FLUX
%
% This script is a variation of zrp.m, to illustrate how zrp.m can be
% modified to measure observables of interest--the empirical flux, in this 
% case. We leave out the video setup, because we're only interested in the
% flux.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

%% We specify the following.
p = 0.60;
L = 100;
H = 10000;
N = 100000;
h_init = init_x(H,L,0.51,'stat');
count = 1;

% Prepare the flux-related vectors. This one will watch a single site for 
% the duration of the simulation.
phi_i = zeros(N,1);

% This matrix will sample the flux at all of the sites during equilibrium,
% for a number of timesteps, T.
T = N/100;
phis = zeros(T,L);

% This is the hillslope profile we'll evolve over time.
h = h_init;

%% Make the gradient vectors from the height ones.
w = zeros(length(h)-1,1);

w(1,1) = H - h(2,1);
w(L-1,1) = h(L-1,1);

for i = 2:length(h)-2
    w(i,1) = h(i,1) - h(i+1,1);
end

for i = 1:N
    % Save the height so that you can calculate the empirical fluxes.
    h1 = h;
    
    % Sample the jump latencies and output the new h's.
    [w, h] = make_moves(p,w);
    
    % Keep track of the flux for a particle site at all times.
    phi_i(i,1) = calc_flux(h,h1,floor(L/2),0);
    
    % Grab a full set of flux observations.
    if mod(i,1000) == 0
        phis(count,:) = calc_fluxes(h,h1);
        count = count + 1;
    end
end

% We can plot the cumulative empirical flux over the course of the
% simulation as follows.
plot(cumsum(phi_i(2:end,:)));

