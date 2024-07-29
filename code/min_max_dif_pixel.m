function [min_i max_i max_dif ]=min_max_dif_pixel(F,M,st)
S=size(F);
Dif=zeros(S);

for i=2:S(3)
    T0(:,:)=F(:,:,i-1);
    T1(:,:)=F(:,:,i);
    dif=abs(T1-T0);
    Dif(:,:,i)=dif; 
end

for i=1:S(1)
    for j=1:S(2)
        temp1(1,:)=F(i,j,1:end);
        temp2(1,:)=Dif(i,j,1:end);

        max_dif(i,j)=max(temp2);
        min_i(i,j)=min(temp1);
        max_i(i,j)=max(temp1);
        
               
    end
end
    
