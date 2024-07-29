function [med]=stocha_pixel(F)
S=size(F);
for i=1:S(1)
    for j=1:S(2)
        temp(1,:)=F(i,j,1:end);
%         M(i,j)=mean(temp);
        med(i,j)=median(temp);
%         st(i,j)=std(double(temp));
        
    end
end
