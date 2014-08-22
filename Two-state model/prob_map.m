
function [p_avg meanI]=prob_map(p_all,I,nbins,fname,saveflag) 
% The function plot probability map and predicted vs actual laser power from p_all
% Input:
%   p_all -- probability distribution of dataset i given laser power I.
%   (200 x worms)
%   I -- laser power (1 x worms)
%   nbins - number of bins
%   fname -- name of the data. If argument is empty then nothing will be
%   plotted.
%   saveflag -- if saveflag == 1, the figure will be saved to
%   .\result_temp\
% Output:
%   p_avg -- the average probability distribution

    
    
    plen = size(p_all,1);
    [bin_num meanI ~]=data_bin(I, nbins);
    
    p_avg = zeros(nbins,plen);
    

    for i = 1:nbins
        p_avg(i,:) = mean(p_all(:,bin_num==i),2)'; %average conditional probability distribution of bin i
    end
    

    if ~isempty(fname)
        figure()
        surf([p_avg ; zeros(1,plen)])
        colormap(gray)
        shading flat 
        % caxis([0 0.01])
        xlabel('Predicted laser power')
        ylabel('Actual laser power')
        view([-270 -90]);
         set(gca,'YTick',1:nbins)
        set(gca,'YTickLabel',meanI);
        colorbar
        title(fname)
        if saveflag == 1
            saveas(gca,[pwd '\results_temp\' fname '_probmap.png'])
        end
    end
    
    

    
    


end