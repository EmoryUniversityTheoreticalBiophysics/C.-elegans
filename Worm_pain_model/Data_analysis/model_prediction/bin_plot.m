function [avgy,SDy,I_x]=bin_plot(yinput,I,binlength,maxI)

    diff =  maxI/binlength;
    I(find(isnan(yinput))) = [];
    yinput(find(isnan(yinput))) = [];
    
    for i = 1:binlength
        temp = find(I<(i*diff) & I>((i-1)*diff));
        avgy(i) = mean(yinput(temp));
        SDy(i) = sqrt(var(yinput(temp)));
        I_x(i) = (i+i-1)*diff/2;
    end
    
    figure()
    errorbar(I_x,avgy,SDy/2,'xr')

end