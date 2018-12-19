% ���� Walsh����ͨ�ú���
% ����N��ʾWalsh��������,��N����2����ʱ,ͨ���������ȡ��ʹ������Walsh����Ϊ2����
%������ĿҪ��������Ҫ��ʼ��64λ
function [walsh]=walsh(N)
M=ceil(log2(N));  
wc=zeros(N,N);  
wn=-1;                           
for i=1:M                 
   w2n=[wn,wn;wn,-wn];
   wn=w2n;   
end
walsh=wn;
