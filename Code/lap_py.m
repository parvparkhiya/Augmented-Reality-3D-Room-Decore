function [img_lap_py] = lap_py(img,k)

    rows=size(img,1);
    cols=size(img,2);
    img_lap_py=ones(rows*2,cols,size(img,3));
    sigma=0.1;
    pointer=1;

    temp_image=img;

    for i=1:(k-1)
        temp_image_new=imgaussfilt(temp_image,sigma);
        temp_down=temp_image_new(1:2:end,1:2:end,:);
        temp_up=imresize(temp_down,2);
        r1=size(temp_up,1);
        c1=size(temp_up,2);
        img_lap_py(pointer:pointer+r1-1,1:c1,:)=temp_image-temp_up;
        
        clear temp_up;
        clear temp_image_new;
        clear temp_image;
        temp_image=temp_down;
        clear temp_down;
        pointer=pointer+r1;
    end

    img_lap_py(pointer:pointer+size(temp_image,1)-1,1:size(temp_image,2),:)=temp_image;
    

end