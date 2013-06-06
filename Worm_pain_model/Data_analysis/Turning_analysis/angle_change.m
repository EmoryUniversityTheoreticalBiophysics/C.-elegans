%%calculate the change of angle between two vectors
%%180 to -180 degrees

%%vector1 = (y,x)
%%vector2 = (y,x)
%%anticlockwise = +ve
%%

function [ angle_f ] = angle_change( vector1,vector2 )

    len1 = sqrt(vector1(1)^2 + vector1(2)^2);
    len2 = sqrt(vector2(1)^2 + vector2(2)^2);
    
    if len1*len2 > 0
    
        vector1t = vector1;
        vector1t(3) = 0;
        vector2t = vector2;
        vector2t(3) = 0;

        dotp = dot(vector1,vector2)/(len1*len2);
        crossp = cross(vector1t,vector2t)./(len1*len2);
        crossp = crossp(3);


         if (crossp < 0) && (dotp < 0) % third quad
                angle_f = asind(-crossp)-180;
            else 
                if (crossp > 0) && (dotp < 0) % 2nd quad
                    angle_f = acosd(dotp);
                else
                    angle_f = asind(crossp);
                end
         end
    else
        angle_f = NaN;
    end
end

