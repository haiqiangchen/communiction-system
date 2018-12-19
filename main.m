clear all
fc=3; %?载频 
eb=2; %?每个字符的能量? 
tb=1; %?每个信息比特所占的时间?
%walsh码进行测试
walsh=walsh(64);
walsh_1=walsh(15,:);
walsh_2=walsh(25,:);
%扩频进行测试
user1=zeros(1,10);
user2=zeros(1,10);
[spreadingCode_user1,walsh2_user1,user_user1,basebandsig_user1]=spreadingCode(walsh_1,10,user1,1);
[spreadingCode_user2,walsh2_user2,user_user2,basebandsig_user2]=spreadingCode(walsh_2,20,user2,2);
figure
plot(spreadingCode_user1);
title('用户1产生的扩频码');
figure
plot(spreadingCode_user2);
title('用户2产生的扩频码');
% scramble_sequence=spreadingCode;

% %加扰进行测试
m_seq=m_sequence();
pnu_len=length(spreadingCode_user1);
%%
j=1;
for i=1:pnu_len
    j=j+1;
    if j>length(m_seq)
        j=1;
    end
     scramble_sequence1_user1(i)=m_seq(j).*spreadingCode_user1(i);
end
figure
plot(scramble_sequence1_user1);
axis([0 pnu_len -2 2]); 
title('用户1加扰的扩频码');
grid on 

j=2;
for i=1:pnu_len
    j=j+1;
    if j>length(m_seq)
        j=1;
    end
     scramble_sequence1_user2(i)=m_seq(j).*spreadingCode_user2(i);
end
figure
plot(scramble_sequence1_user2);
axis([0 pnu_len -2 2]); 
title('用户2加扰的扩频码');
grid on 
%%
scramble_sequence1=scramble_sequence1_user2+scramble_sequence1_user1;
%%
for i=1:20
randNum2(i)=randi([1,100]);
end 
for i=1:20
randNum1(i)=randi([1,100]);
end 

%进行高斯白噪声处理
% for l=-20:20
snr_in_dbs=1%设信噪比为20
scramble_sequence2=awgn(scramble_sequence1,snr_in_dbs); 
figure
plot(scramble_sequence2);
axis([0 pnu_len -2 2]);
title('高斯通道后的信息');
grid on  
%%
%解扰的过程
%用户2的解扰
j=1;
for i=1:pnu_len
    j=j+1;
    if j>length(m_seq)
        j=1;
    end
     scramble_sequence3(i)=m_seq(j).*scramble_sequence2(i);
end
figure
plot(scramble_sequence3);
axis([0 pnu_len -2 2]); 
title('用户1解扰的扩频码');
grid on 
%用户2的解扰
j=2;
for i=1:pnu_len
    j=j+1;
    if j>length(m_seq)
        j=1;
    end
     scramble_sequence4(i)=m_seq(j).*scramble_sequence2(i);
end
figure
plot(scramble_sequence4);
axis([0 pnu_len -2 2]); 
title('用户2解扰的扩频码');
grid on 
%%
 %从信道中解扩出用户的信息

   despreading_code_user1=scramble_sequence3.*walsh2_user1;
   despreading_code_user2=scramble_sequence4.*walsh2_user2;
 
 figure
 plot(despreading_code_user1);
 title('用户1解扩后信道的信息');
 axis([0 pnu_len -2 2]);
 
  figure
 plot(despreading_code_user2);
 title('用户2解扩后信道的信息');
 axis([0 pnu_len -2 2]);
 %进行bpsk的解调
 demodcar=[];
 length_user=length(user_user1);
for i=1:length_user
   for j=0.01:0.01:tb  
      demodcar=[demodcar sqrt(2*eb)*cos(2*pi*fc*j)]; 
   end 
end 

bpskdemod_user1=despreading_code_user1.*demodcar; 
bpskdemod_user2=despreading_code_user2.*demodcar; 

 figure
 plot(bpskdemod_user1);
 title('用户1的bpsk解调后信道的信息');
 axis([0 pnu_len -4 4]);
 
 figure
 plot(bpskdemod_user2);
 title('用户2的bpsk解调后信道的信息');
 axis([0 pnu_len -4 4]);
 %门限判决
len_dmod=length(bpskdemod_user1); 
sum=zeros(1,len_dmod/100); 
for  i=1:len_dmod/100  
      for j=1:20
%    for j=(i-1)*100+1:i*100  
       sum(i)=sum(i)+bpskdemod_user1(randNum1(j)+(i-1)*100); 
      end 
end 
 
 rxbits_user1=[];  
 for i=1:length_user 
    if sum(i)>0
       rxbits_user1=[rxbits_user1 1]; 
    else  
       rxbits_user1=[rxbits_user1 -1]; 
    end 
 end  
length_rxbits=length(rxbits_user1);  
t=0.01:0.01:tb*length_rxbits; 
savbandsig1=[]; 
for i=1:length_rxbits 
   for j=0.01:0.01:tb  
      if rxbits_user1(i)==1 
        savbandsig1=[savbandsig1 1]; 
      else 
        savbandsig1=[savbandsig1 -1]; 
      end 
   end 
end 
figure  
plot(savbandsig1)  
axis([0 100*length_user -2 2]); 
title('用户1门限判断之后的波形')
% %%
len_dmod=length(bpskdemod_user2); 
sum=zeros(1,len_dmod/100); 
for  i=1:len_dmod/100  
    for j=1:20
%    for j=(i-1)*100+1:i*100  
       sum(i)=sum(i)+bpskdemod_user2(randNum2(j)+(i-1)*100); 
   end 
end 
 
 rxbits_user2=[];  
 for i=1:length_user 
    if sum(i)>0  
       rxbits_user2=[rxbits_user2 1]; 
    else  
       rxbits_user2=[rxbits_user2 -1]; 
    end 
 end  


length_rxbits=length(rxbits_user2);  
t=0.01:0.01:tb*length_rxbits; 
savbandsig2=[]; 
for i=1:length_rxbits 
   for j=0.01:0.01:(tb*2)  
      if rxbits_user2(i)==1 
        savbandsig2=[savbandsig2 1]; 
      else 
        savbandsig2=[savbandsig2 -1]; 
      end 
   end 
end 
figure  
plot(savbandsig2)  
axis([0 100*length_user*2 -2 2]); 
title('用户2门限判断之后的波形')
%误码率计算



num1=0;



%求误码的个数
for i=1:len_dmod/100  
%     if  l=<10
%         num1=num1+numm(l);
%     end
       if rxbits_user1(i)~=user_user1(i);
           num1=num1+1;
%        else 
%            num1=num1+numm(l);
       end    
end
errorRate_user1=num1/length(user_user1);

num2=0;
for i=1:len_dmod/100
     if rxbits_user2(i)~=user_user2(i);
            num2=num2+1;
%      else
%             num2=num2+numm(l);
     end 
end
errorRate_user2=num2/length(user_user2);

 
% end
% figure
%  plot(errorRate_user1,'r')
%  hold on 
%  plot(errorRate_user2,'.-')
%   title('用户1和2的误码率曲线');
%   legend('用户1(增益为10)','用户2(增益为20)');
%   xlabel('信噪比');
%   axis([0,50,0,1]);
%   grid on;
  
  
%   figure
%   plot(errorRate_user2)
%   title('用户2的误码率曲线');
%   xlabel('信噪比');
%   axis([0,50,0,1]);
% 
% figure
% plot(errorRate_user1,'r');
% title('用户1的误码率曲线');
% xlabel('信噪比');
% grid on 
% figure
% plot(errorRate_user2,'.-')
% title('用户2的误码率曲线');
% xlabel('信噪比');
% grid on 

