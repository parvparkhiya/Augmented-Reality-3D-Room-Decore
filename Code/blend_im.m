function blended_image = blend_im(img_tar,img_src,img_mask)

    global py_level;
    k=py_level;

    img_src=imresize(img_src,[(size(img_src,1)-mod(size(img_src,1),2^py_level)) (size(img_src,2)-mod(size(img_src,2),2^py_level))]);    
    img_tar=imresize(img_tar,[(size(img_tar,1)-mod(size(img_tar,1),2^py_level)) (size(img_tar,2)-mod(size(img_tar,2),2^py_level))]);    
    img_mask=imresize(img_mask,[(size(img_mask,1)-mod(size(img_mask,1),2^py_level)) (size(img_mask,2)-mod(size(img_mask,2),2^py_level))]);    
    

    rows=size(img_src,1);
    cols=size(img_src,2);


    img_src_lap_py=lap_py(img_src,k);
    img_tar_lap_py=lap_py(img_tar,k);
    img_mask_lap_py=gauss_py(img_mask,k);

    % figure;
    % subplot(1,3,1);
    % imshow(img_src_lap_py);
    % subplot(1,3,2);
    % imshow(img_tar_lap_py);
    % subplot(1,3,3);
    % imshow(img_mask_lap_py);

    img_src_lap_py(:,:,1)=img_src_lap_py(:,:,1).*img_mask_lap_py;
    img_src_lap_py(:,:,2)=img_src_lap_py(:,:,2).*img_mask_lap_py;
    img_src_lap_py(:,:,3)=img_src_lap_py(:,:,3).*img_mask_lap_py;

    img_tar_lap_py(:,:,1)=img_tar_lap_py(:,:,1).*(1-img_mask_lap_py);
    img_tar_lap_py(:,:,2)=img_tar_lap_py(:,:,2).*(1-img_mask_lap_py);
    img_tar_lap_py(:,:,3)=img_tar_lap_py(:,:,3).*(1-img_mask_lap_py);


    blended_image_raw=img_src_lap_py+img_tar_lap_py;
    blended_image=re_lap_py(blended_image_raw,k,rows,cols);

end