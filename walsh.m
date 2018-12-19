% 产生 Walsh函数通用函数
% 参数N表示Walsh函数阶数,当N不是2的幂时,通过向无穷大取整使得所得Walsh阶数为2的幂
%根据题目要求这里是要初始化64位
function [walsh]=walsh(N)
M=ceil(log2(N));  
wc=zeros(N,N);  
wn=-1;                           
for i=1:M                 
   w2n=[wn,wn;wn,-wn];
   wn=w2n;   
end
walsh=wn;
