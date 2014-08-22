
function [mI]=mutual_I(p_avg,nbins) 
% The function  calculate mutual information between prediced laser power and actual laser power
% Input:
%   p_avg -- the average probability distribution (nbins x 200)
%   nbins - number of bins
% Output:
%   mI -- mutual information between prediced laser power and actual laser power
%(c) George Leung and Ilya Nemenman


      Hyx = 0;
      for i = 1:size(p_avg,1)  %%REWRITE
          for j = 1:size(p_avg,2)
            Hyx = Hyx - p_avg(i,j)*log2(p_avg(i,j));
          end
      end
      pt = mean(p_avg,1);
      Hy = 0;
      for i = 1:size(pt,2)
           Hy = Hy - pt(i)*log2(pt(i));
      end
      mI = Hy - Hyx/nbins;
end