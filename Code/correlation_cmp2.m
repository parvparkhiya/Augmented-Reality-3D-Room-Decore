function len = correlation_cmp2(im,patch,d)

    an=false;
    len=0;

    if(size(im,1)>size(patch,1) && size(im,2)>size(patch,2))
        threshold=4;
        p=size(patch,1)/7;
        p2=ceil(size(patch)/2);
        temp=imfilter(im,patch);
        m=floor(size(im)/2);
        ro=size(im,1);
        co=size(im,2);

        tx=max(m(1)-2*d,p2(1));
        tx1=max(m(2)-2*d,p2(2));
        ty=min(m(1)+2*d,ro-p2(1));
        ty1=min(m(2)+2*d,co-p2(2));
       
        temp=temp((tx:ty),(tx1:ty1));
        temp1 = ordfilt2(temp,1,ones(floor(p),floor(p)));
       
       %figure;
       %imshow(temp1/max(temp1(:)));

        len=length(find(temp1>0 & temp1<threshold & temp1==temp));
        if(len>=2 && len<10) 
            an=true;
        end
    end

end