%% ZRP
%
% The goal of this script is to perform simulations of the zero range
% process (ZRP) described in the accompanying paper for various choices 
% of rate function (implemented by calc_rates.m), rate asymmetry parameter
% (p), hillslope length (L), and hillslope height (H). Other settings
% include the initial hillslope profile (implemented by init_x.m), the
% number of simulation steps (N), and a constant playing the role of the
% flux entering the left boundary (phi_l).
%
% Copyright (C) 2018 Jacob Calvert
%
% Developer can be contacted at:
%   Dept. of Statistics
%   University of California, Berkeley
%   451 Evans Hall, Berkeley, CA 94709
%   Phone: (+1) 314-435-3961
%   Email: jacob_calvert@berkeley.edu.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation; either version 2 of the License, or (at your 
% option) any later version. This program is distributed in the hope that 
% it will be useful, but WITHOUT ANY WARRANTY; without even the implied 
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
% GNU General Public License for more details. You should have received a 
% copy of the GNU General Public License along with this program; if not, 
% write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth 
% Floor, Boston, MA 02110-1301 USA.

%% We need to specify the following.
% These parameters will likely be used in every simulation. Note that, for
% the call to init_x, we could pass a value other than p. This corresponds
% to setting the initial hillslope to be different from the equilibrium
% profile desired by the dynamics.
p = 0.55;
L = 100;
H = 100;
N = 500000;
h_init = init_x(H,L,p,'stat');

% We can also initialize a reference profile, which can later be used to
% measure the rate of the hillslope settling down to equilibrium (this is
% useful when h_init is not made with the same p as the dynamics).
h_ref = init_x(H,L,p,'stat');

% We may also be interested in setting a constant flux through the left
% boundary.
phi_l = 0;

% This is the profile we'll evolve over time.
h = h_init;

% This is where we save all of the heights, so we can plot their absolute
% difference with h_init or perform some other calculation in the main 
% loop.
h_save = zeros(length(h),N);

%% Setup video.
%
% If we'd like to make a video of the profile's evolution, we can uncomment
% the following lines as well as the plotting section (including the calls
% to getframe and writevideo) and the close(writerObj) call at the end of
% the script.

%t = fix(clock);
%video_name = sprintf('zrp-%d,%i,%i,%i,%i.mp4',p,L,H,N,t(6));

%writerObj = VideoWriter(video_name,'MPEG-4');
%writerObj.FrameRate = 25;
%open(writerObj);

%% Make the gradient vectors from the height ones.
%
% We began by specifying the initial hillslope height profiles and proceed
% by calculating the associated gradient profile--the object on which the
% dynamics are actually specified.

% The gradient vector is shorter than the height vector.
w = zeros(length(h)-1,1);

% First the left and right boundaries.
w(1,1) = H - h(2,1);
w(L-1,1) = h(L-1,1);

% Then the bulk.
for i = 2:length(h)-2
    w(i,1) = h(i,1) - h(i+1,1);
end

%% Perform the simulation.
for i = 1:N
    % Plot w and h every now and then. Note that the following must be
    % uncommented if we'd like to make a video.
     
    %if mod(i,50000) == 0
    %    figure(1)
    %    
    %    subplot(2,1,1)
    %    bar(w)
    %    ylabel('Gradient','FontSize',18)
    %    xlabel('Site','FontSize',18)
    %    ylim([0,2000]);
    %    
    %    subplot(2,1,2)
    %    bar(h)
    %    ylabel('Height','FontSize',18)
    %    xlabel('Site','FontSize',18)
    %    xlim([0,L]);
    %    
    %    pause(0.001)
    %   
    %    % Write the figure frame to the video file.
    %    frame = getframe(1);
    %    writeVideo(writerObj,frame);
    %end
    
    % As a side note, if we'd like to conduct a simulation where we first
    % allow the hillslope to equilibrate over, say, 1M steps before
    % perturbing it periodically according to perturb.m and eventually
    % ending after a total of 6M steps, we can do the following.
    
    %if (i>1000000) && (mod(i,499999) == 0) && (i < 6000000)
    %    w = perturb(w,25,75);
    %end
    
    % More simply, if we'd like to perturb once, after the hillslope has
    % equilibrated over 1M steps, we can do the following.
     
    %if i == 1000000
    %    w = perturb(w,25,75);
    %end
    
    % We can save the height before applying the dynamics for calculating 
    % some fluxes later.
    h1 = h;
    
    % Sample the jump latencies and output the new h's. This is where we
    % actually administer the dynamics to the gradient profile and get the
    % new gradient and height profiles.
    [w, h] = make_moves(p,w);
    
    % It is sometimes worth saving the new height to apply toward a
    % calculation (e.g. the h_diffs calculation shown below).
    %h_save(:,i) = h;
    
    % We can keep track of the flux for a particle site at all times or for
    % all sites at each time (using calc_flux.m).Supposing we set L=100 
    % earlier and initialized a vector phi_50, we would gather fluxes 
    % through this site as follows.
    %phi_50(i,1) = calc_flux(h,h1,50,phi_l);
    
end

%% Working with observables of interest.
% If we're interested in measuring how similar the evolving height profile
% was to the reference profile saved in h_ref, we can initialize a vector,
% h_diffs and perform do the following.
h_diffs = zeros(N,1);

for i=1:N
    h_diffs(i,1) = sum(abs(h_ref - h_save(:,i)));
end

% This can be used as a straightforward measure of convergence to an 
% equilibrium hillslope profile, given we set h_ref to be an equilibrium
% profile we knew from the outset.
h_diffs_scaled = h_diffs./max(h_diffs);

% If we were interested in particle fluxes as above (i.e. at site 50 where
% L was set to 100), now would be a good time to summarize the fluxes in
% the following way.
b50 = cumsum(phi_50);

% If we made a video, now is the time to close the associated writerObj.
%close(writerObj);