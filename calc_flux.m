function phi_i = calc_flux(h,h1,i,phi_l)
%% CALC_FLUX can be called in zrp.m to determine where changes at site i of
% the hillslope height profile h1, relative to a reference profile h,
% indicate particle flux through site i. phi_l is a constant flux
% originating from the left boundary, which can be set to 0.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

if i == 1
    phi_i = phi_l;
elseif i == length(h)
    phi_i = 0;
else
    del = h-h1;
    phi_i = phi_l + sum(del(i+1:end,1));
end

end
