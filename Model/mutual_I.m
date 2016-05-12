
function [mI]=mutual_I(p_avg,nbins,bin_num) 
% The function  calculate mutual information between prediced laser power and actual laser power
% Input:
%   p_avg -- the average probability distribution (nbins x 200)
%   nbins - number of bins
% Output:
%   mI -- mutual information between prediced laser power and actual laser power
%(c) George Leung and Ilya Nemenman


      
      pxy = p_avg*(1/nbins);
      Hxy = -sum(pxy(:).*log2(pxy(:)));
      py = sum(p_avg,1)/nbins;
      Hy = -sum(py.*log2(py));
      Hx = log2(nbins);
      mI = Hx+Hy-Hxy;
      
end