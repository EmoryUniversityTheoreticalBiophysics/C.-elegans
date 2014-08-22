function []=plot_vels(fspeed, I, I1, factor1, fnametag,figureidx)
% Plotting the collasped and the uncollapsed speeds
% Input:
%   fspeed -- filtered velocity profiles (times x worms)
%   I -- corresponding laser powers (1 x worms)
%   I1 -- parameters of the scaling function
%   factor1 -- the model of the collapse
%   fnametag -- tag to add to the standard file name for saving the plot;
%      if the tag doesn't exist, the plot won't be saved

    % standard output files
    fname = './collapsed_vel/collapsed_vel_';
    try
        mkdir(fname)
    end
    nbins = 5; % five ranges of the current used for plotting

    vdf = fspeed'./(factor1(I,I1)'*ones(size(fspeed,1),1)');
    vdf = vdf';
    [idx meanI] = data_bin(I,nbins);

    %plotting unscaled data
    try
        clf(figureidx)
    end
    figure(figureidx)
    subplot(2,1,1);
    hold
    legtext = [];
    colors =colormap(lines(nbins));
    for i=1:nbins
        h(i) = plot(mean(fspeed(:,idx==i),2), 'Color', colors(i,:), ...
    'DisplayName', ['Mean I = ' num2str(meanI(i))]);
    end
    title('unscaled data')
    hleg = legend(h,'Location','NorthEast');
    xlabel('time')
    ylim([-60 20])

    %plotting scaled data
    subplot(2,1,2);
    hold
    for i=1:nbins
        h2(i) = plot(mean(vdf(:,idx==i),2)*(factor1(100,I1)), 'Color', colors(i,:), ...
    'DisplayName', ['Mean I = ' num2str(meanI(i))]);
    end
    hleg2 = legend(h2,'Location','NorthEast');
    title('collasped data')
    xlabel('time')
    ylim([-60 20])

    %if the tag exists, save the plot
    if(exist('fnametag','var'))
        eval(['print -dpdf ' fname fnametag]); 
    end
    
end