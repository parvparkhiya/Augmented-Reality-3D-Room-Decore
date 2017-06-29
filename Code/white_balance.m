function im_trg_rgb =white_balance(im)
 
    a=double(im(:,:,1))+double(im(:,:,2))+double(im(:,:,3));
    [m i]=max(a);
    [m1 i1]=max(m);
    xyz = rgb2xyz(im);
    xyz_est=rgb2xyz([im(i(i1),i1,1) im(i(i1),i1,2) im(i(i1),i1,3)]);
    xyz_est=double(xyz_est)';
    xyz_target=rgb2xyz([1 1 1])';
    im_trg=zeros(size(im));
    % M matrix clculate
    % xfm = [1.2694 -.0988 -.1706; -.8364 1.8006 0.0357; 0.0297 -0.0315 1.0018];
    xfm = [0.7328 0.4296 -.1624; -.7036 1.6975 0.0061; 0.0030 0.0136 0.9834];
    gain = double([1 1 1])';
    temp=(xfm*xyz_est);
    gain=gain./temp;
    outMat=inv(xfm)*(diag(gain)*xfm);
    for j=1:size(xyz,1)
        for k=1:size(xyz,2)
            xyz_src=xfm*([xyz(j,k,1) xyz(j,k,2) xyz(j,k,3)]');
              an=inv(xfm)*diag(gain)*xyz_src;
              im_trg(j,k,:)=an';
        end
    end
    im_trg_rgb=xyz2rgb(im_trg);

end