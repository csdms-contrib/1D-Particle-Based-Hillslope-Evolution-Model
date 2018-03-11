function phi = calc_fluxes(h,h1)
%% CALC_FLUXES can be called in zrp.m to determine where changes in the
% hillslope height profile h1, relative to a reference profile h,
% indicate particle fluxes.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

phi = zeros(length(h),1);
del = h-h1;

for i = 2:length(h)-1
    phi(i,1) = -1*sum(del(1:i-1,1));
end

phi = phi';

end
