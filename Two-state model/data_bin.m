
function [bin_num meanI bin_range]=data_bin(I, nbins)
% partitions all of the data into equiprobable bins
% Input:
%    I -- laser power (1 x worms)
%    nbins -- number of bins in the partitioning, scalar
% Output:
%    bin_num -- bin index, in which the datum is put
%    meanI -- mean I in each bin
%    bin_range -- largest value of data of each bin, in acsending order (1 x nbins)

nWorms = length(I);     % number of worms
nperbin = floor(length(I)/nbins);  % number of data points in each bin
  
[sortI idx] = sort(I);  % sorted values of I
bin_num = zeros(size(I)); % initializing the output index assignments

for i=1:(nbins-1)
    bin_range(i) = max(I(idx((i-1)*nperbin +1 : i*nperbin)));
    bin_num(idx((i-1)*nperbin +1 : i*nperbin))=i;
end
bin_num(idx((nbins-1)*nperbin +1 :end))=nbins;
bin_range(nbins) = max(I);

meanI=zeros(1,nbins);
for i=1:nbins
    meanI(i)= mean(I(bin_num==i));
end
end    




