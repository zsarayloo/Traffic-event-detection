function I=remove_nois(I1)
% remove noise from I1(RGB)
I(:,:,1)=medfilt2(I1(:,:,1));
I(:,:,2)=medfilt2(I1(:,:,2));
I(:,:,3)=medfilt2(I1(:,:,3));

