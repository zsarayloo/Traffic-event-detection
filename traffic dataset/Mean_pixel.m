function I=Mean_pixel(F)
S=size(F);
for i=1:S(1)
    for j=1:S(2)
        I(i,j)=mean(F(i,j,1:end));
    end
end
