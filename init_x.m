function h = init_x(k,L,p,str)
%% INIT_X initializes hillslope profiles. Pass 'stat' as str to initialize
% with the stationary hillslope profile associated to the linear rate
% dynamics with asymmetry parameter p.
%
% Copyright (C) 2018 Jacob Calvert
% License information located in the preabmle of zrp.m

h = zeros(L,1);

switch str
    case 'slant'
        h(1:L,1) = (k:-1:k-L+1)';
        h(L) = 0;
    case 'stat'
        a = p./(1-p);
        for i = 1:L
            h(i,1) = ceil(k.*(a^i - a^(L+1))./(a - a^(L+1)));
            %h(i,1) = k.*(a^i - a^(L+1))./(a - a^(L+1));

        end
    otherwise
        error('Invalid input string.')
end

end

