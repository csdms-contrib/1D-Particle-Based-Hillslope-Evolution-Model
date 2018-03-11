function rates = calc_rates(p,w)
%% CALC_RATES implements the rate function, which determines how colocated
% particles affect the dynamics. The rate asymmetry parameter p leads to
% differences in the leftward and rightward hopping rates.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

q = 1-p;

% Create a matrix to hold all the rates, where each row corresponds to a
% site on the lattice.
rates = zeros(length(w),2);

% Adopt the convention that the first column is for left, the second for
% right.

%% Rate calculation.
% Remember your p's and q's.
qs = q.*ones(length(w),1);
ps = p.*ones(length(w),1);

% If we choose a constant rate function (commented below), we'll want to
% have nonzero rates only at sites where there are gradient particles.
%rs = w > 0;

% Fill in the left- and right-moving rates. For non-constant rate
% functions, we don't need to include the rs vector. Consider, for example,
% the linear rate implemented here.
rates(:,1) = bsxfun(@times,qs,w);
rates(:,2) = bsxfun(@times,ps,w);

% Constant rate can be implemented like so.
%rates(:,1) = bsxfun(@times,qs,rs);
%rates(:,2) = bsxfun(@times,ps,rs);

% Gradient particles are not allowed to jump out of the boundaries, so
% these rates are set to 0.
rates(1,1) = 0;
rates(end,2) = 0;

end


