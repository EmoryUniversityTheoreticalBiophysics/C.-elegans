

function [ speed_f2 ] = filter_function(speed,windowSize)
%Apply moving gaussian filter on the input data
%Make sure the start and the end is correct
%speed : speed vs time data (or any other data)
%windowSize : full size of the window

        if size(speed,1)<size(speed,2)
            speed = speed';
        end

        windowSize = 2*round(windowSize/2);
        num = -round(windowSize/2):1:round(windowSize/2);
        a = 1;
        c = 40;
        gnum = a*(exp(-(num.^2)/c));
        gnum = gnum./sum(gnum);
        
        %%filtering algorithm 
        %speed
        for i = 1:length(speed)
            if i-(windowSize/2)<1
                speed_f2(i) = sum(speed(1:i+(windowSize/2)).*gnum(end-i-(windowSize/2)+1:end)')/sum(gnum(end-i-(windowSize/2)+1:end));
            else if i+(windowSize/2)>length(speed)
                   speed_f2(i) = sum(speed(i-(windowSize/2):end).*gnum(1:(windowSize/2)+1+length(speed)-i)')/sum(gnum(1:(windowSize/2)+1+length(speed)-i)); 
                else
                    speed_f2(i) = sum(speed(i-(windowSize/2):i+(windowSize/2)).*gnum');
                end
            end
        end

end
