function [ugt,sigmagt]=calc_go_profile_v3(I_go,speed_go,factor1,I1)
% This function calculate the average and variance of speed profile  for go worms.
% Version 3: ugt = sum(fv)/sum(f^2)
% Input:
%   I_go -- Laser power data of go worms ( 1 x number of go worms)
%   speed_go -- speed profile of go worms ( time x number of go worms)
%   factor1 -- anonymous function defining the rescaling model for the go worms
%   I1 -- parameters of the model (go velocity rescaling)
% Output:
%   sigmagt -- variance of the go worm speed profile (1 x time)
%   ugt -- speed profile template of go worms (1 xtime)]

    T=size(speed_go,1); %time length of the speed profile
    
    if size(I_go,1)<size(I_go,2)
        I_go=I_go(:)';
    end
    
    factor1val  = factor1(I_go,I1);
    
    %calculate the template
    ugt_up = sum(speed_go.*(ones(size(speed_go,1),1)*factor1val),2);
    
    ugt_down = sum(factor1val.^2);
    ugt = ugt_up./ugt_down;
    
    %calculate the variance
    sigmagt= std(speed_go-ugt*(factor1val),0,2);
end 