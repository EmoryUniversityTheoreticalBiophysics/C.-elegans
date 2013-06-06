%%calculate the change in direction of finalvec wiht respect to initvec
%
%Input:
%initvec = (x,y)
%finalvec = (x,y)

% Output:
% 180 to -180 degrees
% clockwise = -ve
% output = NaN if vector length = 0

function [ angle_f ] = angle_change( initvec,finalvec )
    %calculate distance of the vectors
    len1 = sqrt(initvec(1)^2 + initvec(2)^2);
    len2 = sqrt(finalvec(1)^2 + finalvec(2)^2);
    
    
    if len1*len2 > 0
    
        vector1t = initvec;
        vector1t(3) = 0;
        vector2t = finalvec;
        vector2t(3) = 0;

        %calculate dot and cross product
        dotp = dot(initvec,finalvec)/(len1*len2);
        crossp = cross(vector1t,vector2t)./(len1*len2);
        crossp = crossp(3);

        %separate into four quadrant
         if (crossp < 0) && (dotp < 0) % 3rd quadrant
                angle_f = asind(-crossp)-180;
            else 
                if (crossp > 0) && (dotp < 0) % 2nd quadrant
                    angle_f = acosd(dotp);
                else
                    angle_f = asind(crossp); % 1st and 4th quadrant
                end
         end
    else
%       if any of the vector has zero length then output NaN
        angle_f = NaN;
    end
end

