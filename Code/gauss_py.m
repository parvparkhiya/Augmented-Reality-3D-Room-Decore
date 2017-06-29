function [img_gauss_py] = gauss_py(img,k)

    rows=size(img,1);
    cols=size(img,2);
    img_gauss_py=ones(rows*2,cols,size(img,3));
    sigma=1;
    img_gauss_py(1:rows,:,:)=img;
    pointer=rows+1;

    temp_image=img;
    for i=1:(k-1)
        temp_image=imgaussfilt(temp_image,sigma);
        temp_down=temp_image(1:2:end,1:2:end,:);
        r1=size(temp_down,1);
        c1=size(temp_down,2);
        img_gauss_py(pointer:pointer+r1-1,1:c1,:)=temp_down;
        clear temp_image;
        temp_image=temp_down;
        clear temp_down;
        pointer=pointer+r1;
    end

end