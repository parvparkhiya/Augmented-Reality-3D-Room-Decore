function img_re = re_lap_py(img_lap_py,k,rows,cols)

    r=rows;
    r1=1;
    c=cols;

    for i=1:k-1
        r1=r1+r;
        r=(r/2);
        c=(c/2);
    end

    temp_base=img_lap_py(r1:r1+r-1,1:c,:);

    for i=1:k-1
        temp_up=imresize(temp_base,2);
        r=r*2;
        c=c*2;
        r1=r1-r;
        clear temp_base;
        
        if i~=k-1
            temp_base=temp_up+img_lap_py(r1:r1+r-1,1:c,:);
        else
            img_re=temp_up+img_lap_py(r1:r1+r-1,1:c,:);
        end

        clear temp_up;
    end


end