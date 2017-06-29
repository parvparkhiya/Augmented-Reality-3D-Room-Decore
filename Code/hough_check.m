function [ang1,ang2] = hough_check(E)
    [H,T,R]=hough(E);
    rows=size(H,1);
    cols=size(H,2);

    min_angle_var=20;
    count_1=0;
    count_2=0;
    max1=0;
    max2=0;
    max1_address=[0,0];
    max2_address=[0,0];

    for i=1:rows
        for j=1:cols
            current=H(i,j);
            if(current>=max1)
                if (max1==0)
                    max1_address=[i,j];
                    max1=current;
                    count_1=1;
                elseif (abs(T(j)-T(max1_address(2)))>min_angle_var)
                    max2=max1;
                    max2_address=max1_address;
                    max1_address=[i,j];
                    max1=current;
                    count_2=count_1;
                    count_1=1; 
                else
                    count_1=count_1+1;
                end
            elseif(current>=max2)
                if (max2==0)
                    max2_address=[i,j];
                    max2=current;
                    count_2=1;
                elseif (abs(T(j)-T(max2_address(2)))>min_angle_var && abs(T(j)-T(max1_address(2)))>min_angle_var)
                    max2_address=[i,j];
                    max2=current;
                    count_2=1;
                elseif abs(T(j)-T(max2_address(2)))<=min_angle_var
                    count_2=count_2+1;
                elseif abs(T(j)-T(max1_address(2)))<=min_angle_var
                    count_1=count_1+1;    
                end
            end
        end
    end
    ang1=T(max1_address(2));
    ang2=T(max2_address(2));    

end