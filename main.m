clear all
fc=3; %?��Ƶ 
eb=2; %?ÿ���ַ�������? 
tb=1; %?ÿ����Ϣ������ռ��ʱ��?
%walsh����в���
walsh=walsh(64);
walsh_1=walsh(15,:);
walsh_2=walsh(25,:);
%��Ƶ���в���
user1=zeros(1,10);
user2=zeros(1,10);
[spreadingCode_user1,walsh2_user1,user_user1,basebandsig_user1]=spreadingCode(walsh_1,10,user1,1);
[spreadingCode_user2,walsh2_user2,user_user2,basebandsig_user2]=spreadingCode(walsh_2,20,user2,2);
figure
plot(spreadingCode_user1);
title('�û�1��������Ƶ��');
figure
plot(spreadingCode_user2);
title('�û�2��������Ƶ��');
% scramble_sequence=spreadingCode;

% %���Ž��в���
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
title('�û�1���ŵ���Ƶ��');
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
title('�û�2���ŵ���Ƶ��');
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

%���и�˹����������
% for l=-20:20
snr_in_dbs=1%�������Ϊ20
scramble_sequence2=awgn(scramble_sequence1,snr_in_dbs); 
figure
plot(scramble_sequence2);
axis([0 pnu_len -2 2]);
title('��˹ͨ�������Ϣ');
grid on  
%%
%���ŵĹ���
%�û�2�Ľ���
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
title('�û�1���ŵ���Ƶ��');
grid on 
%�û�2�Ľ���
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
title('�û�2���ŵ���Ƶ��');
grid on 
%%
 %���ŵ��н������û�����Ϣ

   despreading_code_user1=scramble_sequence3.*walsh2_user1;
   despreading_code_user2=scramble_sequence4.*walsh2_user2;
 
 figure
 plot(despreading_code_user1);
 title('�û�1�������ŵ�����Ϣ');
 axis([0 pnu_len -2 2]);
 
  figure
 plot(despreading_code_user2);
 title('�û�2�������ŵ�����Ϣ');
 axis([0 pnu_len -2 2]);
 %����bpsk�Ľ��
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
 title('�û�1��bpsk������ŵ�����Ϣ');
 axis([0 pnu_len -4 4]);
 
 figure
 plot(bpskdemod_user2);
 title('�û�2��bpsk������ŵ�����Ϣ');
 axis([0 pnu_len -4 4]);
 %�����о�
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
title('�û�1�����ж�֮��Ĳ���')
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
title('�û�2�����ж�֮��Ĳ���')
%�����ʼ���



num1=0;



%������ĸ���
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
%   title('�û�1��2������������');
%   legend('�û�1(����Ϊ10)','�û�2(����Ϊ20)');
%   xlabel('�����');
%   axis([0,50,0,1]);
%   grid on;
  
  
%   figure
%   plot(errorRate_user2)
%   title('�û�2������������');
%   xlabel('�����');
%   axis([0,50,0,1]);
% 
% figure
% plot(errorRate_user1,'r');
% title('�û�1������������');
% xlabel('�����');
% grid on 
% figure
% plot(errorRate_user2,'.-')
% title('�û�2������������');
% xlabel('�����');
% grid on 

