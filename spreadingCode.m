%扩频的函数产生器
%walsh代表walsh码，N代表扩频增益
function [pnupsample,walsh,user,basebandsig1]=spreadingCode(walsh,N,user,n) 
% clear all
% clc
% walsh=walsh(64);
% walsh_2=walsh(25,:);
% N=20;
% user=zeros(1,10);
length_user=length(user);
t=1;
for i=1:length_user*N
    t=t+1
    if t>length(walsh)
      t=1;  
    end
    walsh2(i)=walsh(t);
end
num=1;
for i=1:length_user
   user(i)=num;
       if randi([0,1])==0    %随机判断
       num=(-1)*num;
       end
end
fc=3; %?载频 
eb=2; %?每个字符的能量? 
tb=1; %?每个信息比特所占的时间?
%用户输入的数据信息
basebandsig=[]; 
for  i=1:length_user
   for j=0.01:0.01:(tb*n)
        if  user(i)==1  
            basebandsig=[basebandsig 1]; 
        else  
            basebandsig=[basebandsig -1]; 
        end 
   end 
end 
figure 
plot(basebandsig)  
axis([0  100*length_user*n -1.5 1.5]); 
title(['用户' num2str(n) '输入的信息']);
%bpsk的调制
bpskmod=[];  
for i=1:length_user 
    for j=0.01:0.01:tb  
       bpskmod=[bpskmod  sqrt(2*eb)*user(i)*cos(2*pi*fc*j)]; 
    end  
end 
length(bpskmod) 
%用户BPSK调制后的波形图输出
figure 
plot(bpskmod) 
axis([0 100*length_user -3  3]); 
title(['用户' num2str(n) '经BPSK调制之后的波形'])
len2=length(walsh);
%扩频过程
pnupsampled=[]; 
len_pn=length(walsh2); 
for i=1:len_pn  
    for j=0.1:0.1:tb 
      if walsh2(i)==1  
         pnupsampled=[pnupsampled 1]; 
      else  
         pnupsampled=[pnupsampled -1]; 
      end 
    end 
end  
length_pnupsampled=length(pnupsampled); 
for i=1;length_pnupsampled
    if i==length(bpskmod)
        break;
    end
    pnupsampled2(i)=pnupsampled(i);
end
sigtx=bpskmod.*pnupsampled2; 
pnupsample=sigtx;
walsh=pnupsampled2;
user=user;
basebandsig1=basebandsig;


