function [foutput]=Func_I1(I1,I,speed) 
    
    Nworms=size(speed,2);
   
    %calculate u(t)
    factor = (1./(I1+I));
    u = (speed*factor')/Nworms;
    temp2= speed -u*(1./factor);
    sigmagt=std(temp2,0,2);

    foutput=-(sum(sum(-temp2.^2./(sigmagt*ones(1,Nworms)))) ...
        -sum(log(sigmagt))*Nworms);   
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    