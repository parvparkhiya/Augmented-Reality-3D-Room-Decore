function [msk_im,trg_im] = create_mask_target(orig_im,ch_im,cent,dist)
    %resizing factor for chair image
    cent=floor(cent);
    global scale_factor;

    alpha=(sqrt(dist)*scale_factor)/1000;
    color_tresh=235/255;
    ch_new=imresize(ch_im,alpha);
    %create msk_im
    [wid,len,nu]=size(ch_new);
    wid=floor(wid/2)*2;
    len=floor(len/2)*2;
    cent(1)=cent(1)-floor(wid/3);
    temp_im=ones(size(orig_im,1),size(orig_im,2));
     %corner point for patch
    tx1=cent(1,1)-floor(wid/2)+1;sx1=tx1;spx1=1;
    tx2=cent(1,1)+floor(wid/2);sx2=tx2;spx2=wid;
    ty1=cent(1,2)-floor(len/2)+1;sy1=ty1;spy1=1;
    ty2=cent(1,2)+floor(len/2);sy2=ty2;spy2=len;
    if tx1<=0
        sx1=1;
        spx1=spx1+abs(tx1)+1;
    end
    if tx2>size(temp_im,1)
        sx2=size(temp_im,1);
        spx2=spx2+size(temp_im,1)-tx2;
    end
    if ty1<=0
        sy1=1;spy1=spy1+abs(ty1)+1;
    end
    if ty2>=size(temp_im,2)
        sy2=size(temp_im,2);
        spy2=spy2+size(temp_im,2)-ty2;
    end

    temp_im(sx1:sx2,sy1:sy2)=(ch_new(spx1:spx2,spy1:spy2,1)+ch_new(spx1:spx2,spy1:spy2,2)+ch_new(spx1:spx2,spy1:spy2,3))/3;
 
    
    %imshow(temp_im);
    msk_im=temp_im > color_tresh;
    msk_im=1-msk_im;
    SE = strel('disk',1);
    msk_im = imerode(msk_im,SE);
    %create trg_img
    trg_im=zeros(size(orig_im));
    r=ret_trg(orig_im(:,:,1),ch_new(:,:,1),cent).*msk_im;
    g=ret_trg(orig_im(:,:,2),ch_new(:,:,2),cent).*msk_im;
    b=ret_trg(orig_im(:,:,3),ch_new(:,:,3),cent).*msk_im;
    trg_im(:,:,1)=r;trg_im(:,:,2)=g;trg_im(:,:,3)=b;
    
    %  figure;imshow(trg_im);
    %  figure;imshow(msk_im);

end