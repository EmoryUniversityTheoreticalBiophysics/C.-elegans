function IpvsIa_plot(filename1,filename2,filename3)
% The function compare the predicted laser power vs actual laser power of
% three different data
% Input:
%   filename1,filename2,filename3 -- filename of three differen IpvsIa
%   dataset (string)
% Output:
%   A plot of 


    load(filename1)
    m1=p_avg*[1:200]';
    s1=sqrt(p_avg*(([1:200]').^2)-m1.^2)
    [val max1] = (max(p_avg'));
    [bin_num meanI1 ~]=data_bin(Iact, 5);
    
    
    
    load(filename2)
    m2=p_avg*[1:200]';
    s2=sqrt(p_avg*(([1:200]').^2)-m2.^2)
    [bin_num meanI2 ~]=data_bin(Iact, 5);
    [val max2] = (max(p_avg'));
    
        
    load(filename3)
    m3=p_avg*[1:200]';
    s3=sqrt(p_avg*(([1:200]').^2)-m3.^2)
    [bin_num meanI3 ~]=data_bin(Iact, 5);
    [val max3] = (max(p_avg'));
    
    
    figure()
    h1= errorbar(meanI1,m1,s1,'.')
    set(h1,'Color','black','LineWidth',1)
    hold
    h2= errorbar(meanI2,m2,s2,'.')
    set(h2,'Color','blue','LineWidth',1)
    h3= errorbar(meanI3,m3,s3,'.')
    set(h3,'Color','red','LineWidth',1)
    legend(filename1(8:18),filename2(8:18),filename3(8:13))
    title(['Expected laser power (' filename1(20:30) ' model)'])
    xlabel('Actual I')
    ylabel('Predicted I')
    
    
    figure()
    plot(meanI1,max1,'*',meanI2,max2,'+',meanI3,max3,'.')
    legend(filename1(8:18),filename2(8:16),filename3(8:13))
    title(['Most probable laser power (' filename1(20:30) ' model)'])
    xlabel('Actual I')
    ylabel('Predicted I')
    
end