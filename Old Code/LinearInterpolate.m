function y = LinearInterpolate(x, x1, y1, x2, y2)
% Linear interpolation routine, with limiters added 
% incase x isn't within the range range x1 to x2 
% Limits updated to allow descending x values
% x = input value
% x1 = MINIMUM BOUNDS ( minimum x )
% y1 = MINIMUM VALUE ( output value at MINIMUM BOUNDS )
% x2 = MAXIMUM BOUNDS ( maximum x )
% y2 = MAXIMUM VALUE ( output value at MAXIMUM BOUNDS )

% This procedure extrapolates the y value for the x position
% on a line defined by x1,y1; x2,y2
    if ( (x1 < x2) && ((x <= x1) || (x >= x2)) ) % ascending x values
        if (x <= x1) 
            y = y1; 
        else
            y = y2;
        end
    elseif ( (x1 > x2) && ((x >= x1) || (x <= x2)) ) % descending x values
        if (x >= x1) 
            y = y1; 
        else
            y = y2;
        end    
    else
        m = (y2 - y1) / (x2 - x1);  %calculate the gradient m
        c = y1 - m * x1;            %calculate the y-intercept c
        y = m * x + c;              %the final calculation
    end
end
