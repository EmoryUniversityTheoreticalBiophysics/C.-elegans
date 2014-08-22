function [S]=gopause(fspeed)
% finding the go and paused worms 
% Input:
%   fspeed -- filtered velocity profiles (times x worms)
% Output:
%   S -- boolean index representing go or paused worms. Pause = 1 and go = 0. (1 x worms)
%
%(c) George Leung, Ilya Nemenman

% Verified OK, June 12, 2014

    threshold = -10;  % the threshold for the maximum escape (negative) velocity
        % the maximum escape velocity must be over the threshold for this
        % to be considered a go-worm
        
    val = min(fspeed);
    S = val>threshold; %Paused state = 1, Go state = 0
end