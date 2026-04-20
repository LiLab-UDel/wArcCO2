function ndesc = fun_ndesc(nval)

% display nval by adding thousands separator ','
% Usage:
%   ndesc = fun_ndesc(nval)
% Input:
%   nval   a numerical number
% Output:
%   ndesc  string of input number with thousands separator added
%
%            Tianyu Zhou, UDel, 3/21/2026

ndesc = num2str(nval,'%.i');
if nval>=1e3; ndesc=[ndesc(1:end-3) ',' ndesc(end-2:end)]; end
return;
