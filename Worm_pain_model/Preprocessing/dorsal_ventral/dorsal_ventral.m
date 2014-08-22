function []=dorsal_ventral(speedfpath, speedfname, datafpath,datafname,threshold,laseron)


% function []=dorsal_ventral(speedfpath, speedfname, datafpath,datafname,threshold,laseron)
% 
% This function calculates the  curvature of the first 1/3 part of the body
% before the laser was fired. Then determine which side of the body the head
% was bending(dorsal/ventral).
% 
% Input:
%  speedfpath -- path to the file with the centroid 
% 	speed data
%  speedfname -- filename of the centroid speed data file,
% 	extension '.mat' is assumed
%  datafpath -- path to the file with the centroid 
% 	position data
%  datafname -- filename of the centroid position data file,
% 	extension '.mat' is assumed
%  threshold -- threshold of dorsal/ventral selection (recommended value:
%  0.01)
%  laseron -- frame no. when the laser was fired
% 
% Input file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
%   data{k} -- cell array of trial k containing:
%       centroid (i,j) -- Centroid position of the worm. i represents time and j represents x (j = 1) and y (j = 2) coordinates. 
% 
% Output:
%  no output variables
% 
% Output File:
%  speed data will be stored in a file named 'speedfname'_D.mat and 'speedfname'_V.mat in 
% 	the directory specified by speedfpath.
%  raw data will be stored in a file named 'datafname'_D.mat and 'datafname'_V.mat in 
% 	the directory specified by datafpath
.
% Output file structure:
% 	fspeed (i,j) -- filtered centroid velocity at time i of trial j.
%   nfspeed (i,j) -- filtered and normalized centroid veloctiy at time i of trial j.
%   I(i) -- laser power of worm i.
%   headbend (i) -- the side where the head was bending to. (D: dorsal
%   side, V: ventral side)
% 
% Dependency:
% bin_plot.m
% 
% (c) George Leung, Ilya Nemenman, Emory University, 2011-2013



%%calculate and identify dorsal and ventral side of the worm



%load data
load([datafpath '\' datafname])


%calculate curvature of different part of the body at different time.
for i = 1:length(data)
    
    xpos = data{i}.wormskelx;
    ypos = data{i}.wormskely;
    xpos = xpos(:,1:3:41);
    ypos = ypos(:,1:3:41);

    for j = 1:size(xpos,1)
    txpos = xpos(j,:)';
    typos = ypos(j,:)';
    xe = [txpos(3);txpos;txpos(end-2)]; ye = [typos(3);typos;typos(end-2)];
    dx = diff(xe); dy = diff(ye);
    dxb = dx(1:end-1); dyb = dy(1:end-1);
    dxf = dx(2:end); dyf = dy(2:end);
    d2x = xe(3:end)-xe(1:end-2); d2y = ye(3:end)-ye(1:end-2);
    curv{i}(j,:) = 2*(dxb.*dyf-dyb.*dxf)./ sqrt((dxb.^2+dyb.^2).*(dxf.^2+dyf.^2).*(d2x.^2+d2y.^2));

    end
    
end


headbend = cell(length(data),1);
switchcondition = cell(length(data),1);
headcurv = zeros(length(data),size(data{1}.wormskelx,1));
startheadcurv = zeros(length(data),1);
for i = 1:length(data)
    
%Calculate the head curvature by averaging the curvature of the first 1/3
%part of the body. Then average the head curvature in the 10 frames before
%the laser is fired
    headcurv(i,:) = mean(curv{i}(:,2:5),2);
    startheadcurv(i) = mean(headcurv(i,laseron-10:laseron));
    
    
%Determinating the direction of head bend using side and head
%curvature. There are 4 cases:
% 1. Worm crawl on right side & head curvature is +ve : the head bend to
% dorsal side. headbend = 'D'.
% 2.  Worm crawl on right side & head curvature is -ve : the head bend to
% ventral side. headbend = 'V'.
% 3.  Worm crawl on left side & head curvature is -ve : the head bend to
% dorsal side. headbend = 'D'.
% 4.  Worm crawl on left side & head curvature is +ve : the head bend to
% ventral side. headbend = 'V'.
    
    if startheadcurv(i) > threshold
        switchcondition{i} = 'P';
        else if startheadcurv(i) < -threshold
        switchcondition{i} = 'N';
            else
                switchcondition{i} = 'Z';
        end
    end        
    switchcondition{i} = [side{i} switchcondition{i}];
    
    headbend{i} = 'N';
    switch switchcondition{i}
        case 'RN'
            headbend{i} = 'V';
        case 'RP'
            headbend{i} = 'D';
        case 'LN'
            headbend{i} = 'D';
        case 'LP'
            headbend{i} = 'V';
    end
    
end


%dorsal side
%saving speed data
load([speedfpath '\' speedfname])
nfspeed = nfspeed(:,find(strcmp('D', headbend)));
fspeed = fspeed(:,find(strcmp('D', headbend)));
filename2{:} = filename{find(strcmp('D', headbend))};
I = I(find(strcmp('D', headbend)));

save([speedfpath '\' speedfname '_D'],'nfspeed','I','fspeed','headbend')

%saving data file
load([datafpath '\' datafname])
I = I(find(strcmp('D', headbend)));
data = data(find(strcmp('D', headbend)));
filename = filename(find(strcmp('D', headbend)));
side = side(find(strcmp('D', headbend)));
save([datafpath '\' datafname '_D'],'data','I','filename','side')

%Ventral side
%saving speed data
load([speedfpath '\' speedfname])
nfspeed = nfspeed(:,find(strcmp('V', headbend)));
fspeed = fspeed(:,find(strcmp('V', headbend)));
I = I(find(strcmp('V', headbend)));
save([speedfpath '\' speedfname '_V'],'nfspeed','I','fspeed','headbend')

%saving data file
load([datafpath '\' datafname])
I = I(find(strcmp('V', headbend)));
data = data(find(strcmp('V', headbend)));
filename = filename(find(strcmp('V', headbend)));
side = side(find(strcmp('V', headbend)));
save([datafpath '\' datafname '_V'],'data','I','filename','side')

end