function res = Euler2(Max)

%Max=100;

cnt=0;
list=[1;2];

for i=3:Max
    list(i)=list(i-1)+list(i-2)
    if mod(list(i), 2)==0
        cnt=cnt+list(i)
    end
    if list(i-2)>=Max
        break
    end
end

res=cnt+2;