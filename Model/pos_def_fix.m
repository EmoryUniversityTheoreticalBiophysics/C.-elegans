function [sigmagtout] = pos_def_fix(sigmagt)
% this function test and make the covariance matrix to be positive definite

    [validflag,elementflag,diagflag]=pos_def_test(sigmagt);
    
    
    if validflag == 0
%         templist = find(diagflag == 0);
%         for i = 1:size(templist)
%             %copy the center diag element to the wrong element
%             deletelower = diag(diag(sigmagt,-templist(i)),-templist(i));
%             deleteupper = diag(diag(sigmagt,templist(i)),templist(i));
%             
%             diagterm = diag(sigmagt,0);
%             diagterm = diagterm(1:end-1);
%             
%             fixlower = diag(diagterm,-templist(i));
%             fixupper = diag(diagterm,templist(i));
%             
%             sigmagtout = sigmagtout - deletelower - deleteupper + fixlower + fixupper;
%         end

%         for i = 1:10
%             sigmagttemp = rescale_sigmagt(sigmagt,1/i);
%             mineigval(i) = min(eig(sigmagttemp));
%         end
        
        %find the off-diag scale that makes the eigenvalue positive
        opts2 = optimset('UseParallel','always');
       [scaleval,fval] = fminsearch(@(scale)abs(min(eig(rescale_sigmagt(sigmagt,scale)))),1,opts2);
       sigmagtout = rescale_sigmagt(sigmagt,scaleval);
       
    end
end