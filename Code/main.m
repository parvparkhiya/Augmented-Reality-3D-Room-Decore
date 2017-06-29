clear;
close all;
clc;

chair=readObj('c1.obj');
texture_file='tex1.jpg';

global py_level;
global scale_factor;

scale_factor=130; 
py_level=2;
scale=0.25; %for image resize


for ii=2:2
%ii=2;

    imor=imread(strcat(num2str(ii),'.jpg'));
    imor=imresize(imor,scale);
    imor=double(imor)/255;
    
    %figure;
    %subplot(1,2,1);
    %imshow(imor);
    imor=white_balance(imor);
    %subplot(1,2,2);
    %imshow(imor);
    
    imo=double(rgb2gray(imor));
    im=imgaussfilt(imo,2);
    
    rows=size(im,1);
    cols=size(im,2);
    
    imt=im>0.425;
    imn=1-imt;
    
    %figure
    %imshow(imn)
    
    CC = bwconncomp(imn);
    stats = regionprops('table',CC,'ConvexArea','Area','Solidity','EulerNumber','Eccentricity','Extrema','Orientation','Centroid');
    indx=find((stats.Solidity>0.9)&(stats.EulerNumber==1)&(stats.Area>(250*scale^2)/(0.25)^2)&(stats.Area<(90000*scale^2)/(0.25)^2)&stats.Eccentricity>0.5);
    imnp=imn;
    
    id1=0;
    sp=1;
    can_n=size(indx,1);
    temp_image=zeros(size(im));
    
    centroid=zeros(can_n,2);
    orient_can=zeros(can_n,1);
    extrema=zeros(can_n*4,2);
    distance_can=zeros(1,can_n);
    color_can=zeros(3,can_n);
    
    for i=1:can_n
        imn=imnp;
        imn(CC.PixelIdxList{indx(i)}) = 0;
        temp=CC.PixelIdxList{indx(i)};
        for j=1:length(temp)
            centroid(i,:)=centroid(i,:)+get_co(temp(j),rows);
        end
        centroid(i,:)=centroid(i,:)/length(temp);
        orient_can(i)=stats.Orientation(indx(i));
        color_can(:,i)=imor(floor(centroid(i,1)),floor(centroid(i,2)),:);
        temp_image=temp_image|(imnp-imn);
        tt=[1,2,5,6];
        tv=stats.Extrema{indx(i)};
        dd=zeros(1,4);
        for j=1:4
            extrema((i-1)*4+j,:)=tv(tt(j),:);
            dd(j)=sqrt(((tv(tt(j),1)-centroid(i,2))^2)+((tv(tt(j),2)-centroid(i,1))^2));
        end
        distance_can(i)=floor(max(dd));
    end
  
    % figure;
    % imshow(imo), hold on
    % plot(centroid(:,2),centroid(:,1),'r*'), hold on
    % plot(extrema(:,1),extrema(:,2),'g*'), hold on

    count2=0;
    for i=1:can_n
        
        if(abs(color_can(1,i)-color_can(2,i))<30 && abs(color_can(1,i)-color_can(3,i))<30 && abs(color_can(2,i)-color_can(3,i))<30 )
     
            tx=floor(centroid(i,1)-distance_can(i)*1.2);
            ty=floor(centroid(i,1)+distance_can(i)*1.2);
            tx1=floor(centroid(i,2)-distance_can(i)*1.2);
            ty1=floor(centroid(i,2)+distance_can(i)*1.2);
          
            if tx<=0
            tx=1;
            end
            if tx1<=0
            tx1=1;
            end
            if ty>rows
            ty=rows;
            end
            if ty1>cols
            ty1=cols;
            end

            template_patch_o=edge(temp_image(tx:ty,tx1:ty1));
            template_patch=template_patch_o/sum(template_patch_o(:));

            % figure;
            % subplot(2,2,1);
            % imshow(temp_image(tx:ty,tx1:ty1));
            % xlabel('Cropped Thresholded Image');
            % subplot(2,2,2);
            % imshow(template_patch_o);
            % xlabel('Boundary');

            tx=(centroid(i,1)-distance_can(i)*3);
            ty=(centroid(i,1)+distance_can(i)*3);
            tx1=(centroid(i,2)-distance_can(i)*3);
            ty1=(centroid(i,2)+distance_can(i)*3);
            centroid_local=[floor((ty-tx+1)/2),floor((ty1-tx1+1)/2)];

            if tx<=0
            tx=1;
            end
            if tx1<=0
            tx1=1;
            end
            if ty>rows
            ty=rows;
            end
            if ty1>cols
            ty1=cols;
            end
            image_gray=imo(tx:ty,tx1:ty1);
            image_patch=edge(image_gray);
            image_patch_d=bwdist(image_patch);
            
            % subplot(2,2,3);
            % imshow(image_gray);
            % xlabel('Cropped Original Gray Image');
            % subplot(2,2,4);
            % imshow(image_patch);
            % xlabel('Edge Image of patch');
            %figure;
            %imshow(image_patch_d/max(image_patch_d(:)));

            flag=correlation_cmp2(image_patch_d,template_patch,distance_can(i));
                    
                  
            if(flag>1)

                % figure;
                % subplot(1,3,1);
                % imshow(template_patch*100);
                % xlabel(strcat(num2str(orient_can(i)),' : ','orientation'));
                % subplot(1,3,2);
                % imshow(image_patch);
                % subplot(1,3,3);
                % imshow(imo(tx:ty,tx1:ty1));
                   
         
                flag2=false;
                left=0;
                count2=count2+1;
                [flag2,ind1]=ret_it(image_gray*255,centroid_local,count2);
                direction=orient_can(i);

                if(orient_can(i)>=0 && (ind1==2 || ind1==4))
                    left=1;
                elseif (orient_can(i)<0 && (ind1==4 || ind1==1))
                    left=1;
                end

                if (direction>0 && left==0)
                    direction=direction-90;
                elseif (direction>0 && left==1)
                    direction=direction+90;
                elseif (direction<=0 && left==0)
                    direction=direction+90;
                elseif (direction<=0 && left==1)
                    direction=direction-90;
                end


                if(flag2==true)
                
                    % figure;
                    % subplot(1,4,1);
                    % imshow(template_patch*100);
                    % xlabel(strcat(num2str(orient_can(i)),' : ','orientation'));
                    % subplot(1,4,2);
                    % imshow(image_patch);
                    % xlabel(strcat(num2str(left)));                 
                    % subplot(1,4,3);
                    % imshow(imo(tx:ty,tx1:ty1));
                    % xlabel(strcat(num2str(ii),' : ',num2str(flag)));
                    
                    figure;
                    display_obj(chair,texture_file);
                    fig = get(groot,'CurrentFigure');
                    %view([(-1)*(100+direction) 20]);
                    view([(-1)*(100+direction) (20*(distance_can(i)/20))]);
                    %(20*sqrt(distance_can(i)/100))
                    camlight('headlight');
                    chair_temp=getframe(fig);
                    chair_oriented=chair_temp.cdata;
                    chair_oriented=double(chair_oriented)/255;
                    close(fig);
              
                    [mask_image,target_image]=create_mask_target(imor,chair_oriented,centroid(i,:),distance_can(i));
                    %imwrite(mask_image,'mask_image.png');
                    %imwrite(target_image,'target_image.png');
                    result_image=blend_im(imor,target_image,mask_image);
                    imwrite(result_image,strcat('result_',num2str(ii),'.jpg'));
                    
                    % figure;
                    % imshow(template_patch_o);
                    % [ang1,ang2]=hough_check(template_patch_o);
                    % xlabel(strcat('Major Axis Direction','::',num2str(ang1)));
              
                    figure;
                    % subplot(1,2,1);
                    imshow(result_image);
                    xlabel(num2str(ii));
                    % subplot(1,2,2);
                    % imshow(imn);
                end
            end
        end
    end


end