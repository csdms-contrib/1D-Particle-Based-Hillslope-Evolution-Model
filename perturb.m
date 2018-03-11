function w = perturb(w,a,b)
%% PERTURB implements the perturbations we'd like to apply to the 
% hillslope, as part of the main loop in zrp.m. This is likely the function 
% that will be played around with the most. 
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

% In its current form, perturb(w,a,b) removes one quarter of the gradient 
% particles from each of the sites a:b, and places them all at site a. In 
% terms of the hillslope profile, this corresponds to the hillslope 
% becoming much steeper at site a, as if washout occurred from a:b.

% Of course, any sort of perturbation can be placed here, so long as it
% conserves the number of gradient particles!

% Skim off roughly one-quarter of the gradient particles from sites a:b.
hunk = 0;
 
for j = a:b
    chip = floor(0.25*w(j));
    w(j) = w(j) - chip;
    hunk = hunk + chip;
end
 
% Place all the removed gradient particles at site a. 
drop_site = a;
w(drop_site,1) = w(drop_site,1) + hunk;

%% Another example.
% Remove a number of gradient particles, cut, from each site in a:b with at
% least that many particles, and place them randomly at a single site.
%indicators = w > cut;
%hunk = cut.*sum(indicators(a:b,1));
5w(a:b,1) = w(a:b,1) - cut.*indicators(a:b,1);

% Place the hunk of removed particles randomly.
%drop_site = randi(length(w),1);
%w(drop_site,1) = w(drop_site,1) + hunk;

end

