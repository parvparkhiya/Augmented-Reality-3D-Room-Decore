function temp_im =ret_trg(orig_im,ch_new,cent)
    [wid,len,nu]=size(ch_new);
    wid=floor(wid/2)*2;
    len=floor(len/2)*2;
    temp_im=zeros(size(orig_im,1),size(orig_im,2));
    tx1=floor(cent(1,1))-floor(wid/2)+1;sx1=tx1;spx1=1;
    tx2=floor(cent(1,1))+floor(wid/2);sx2=tx2;spx2=wid;
    ty1=floor(cent(1,2))-floor(len/2)+1;sy1=ty1;spy1=1;
    ty2=floor(cent(1,2))+floor(len/2);sy2=ty2;spy2=len;
    if tx1<=0
        sx1=1;spx1=spx1+abs(tx1)+1;
    end
    if tx2>size(temp_im,1)
        sx2=size(temp_im,1);spx2=spx2+size(temp_im,1)-tx2;
    end;
    if ty1<=0
        sy1=1;spy1=spy1+abs(ty1)+1;
    end
    if ty2>=size(temp_im,2)
        sy2=size(temp_im,2);spy2=spy2+size(temp_im,2)-ty2;
    end
    temp_im(sx1:sx2,sy1:sy2)=ch_new(spx1:spx2,spy1:spy2);
    %figure;
    %imshow(temp_im);
end