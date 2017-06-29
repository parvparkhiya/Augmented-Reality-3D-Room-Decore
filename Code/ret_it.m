function [an,ind1] = ret_it(im,cent,count)
    % figure;
    % imshow(im/255)
    k1=cent(1);
    k2=cent(2);
    
    an=false;
    cnt2=0;
    shift=6;
    ind1=0;
    px=[0];

    if (im(k1,k2)<120)
        t1=30; %threshold
        t2=40; %white and centroid
        t3=15; %white and gray
        t4=40;
        cnt=1;
        for i=k1:size(im,1)
            %check right 1
            if(abs(im(k1,k2)-im(i,k2))>t1)
                tt=i+shift;
                if tt>size(im,1)
                    tt=size(im,1);
                end
                px(cnt)=mean(im(i:tt,k2));
                cnt=cnt+1;
                break;
            end
        end
        for i=k1:-1:1
            %check left 2
            if(abs(im(k1,k2)-im(i,k2))>t1)
                tt=i-shift;
                if tt<=0
                    tt=1;
                end
                px(cnt)=mean(im(tt:i,k2));
                cnt=cnt+1;
                break;
            end
        end
        for i=k2:size(im,2)
            %check up 3
            if(abs(im(k1,k2)-im(k1,i))>t1)
                tt=i+shift;
                if tt>size(im,2)
                    tt=size(im,2);
                end
                px(cnt)=mean(im(k1,i:tt));
                cnt=cnt+1;
                break;
            end
        end

        for i=k2:-1:1
            %check down 4
            if(abs(im(k1,k2)-im(k1,i))>t1)
                tt=i-shift;
                if tt<=0
                    tt=1;
                end
                px(cnt)=mean(im(k1,tt:i));
                cnt=cnt+1;
                break;
            end
        end

        [px,index]=sort(px);


        if(cnt==5 & abs(px(1)-im(k1,k2)) > t3 & abs(px(cnt-1)-im(k1,k2)) > t2 & abs(px(cnt-1)-(px(1))) > t4)
            if((abs(px(1)-px(2))<abs(px(2)-px(4)) && abs(px(1)-px(3))<abs(px(3)-px(4)) ) )
                an=false;
            else
                ind1=index(1);
                an=true;
            end
        end
    end
end