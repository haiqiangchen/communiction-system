%m���еĲ���������ϵ��Ϊ67������Ϊ5
function[mseq]=m_sequence()
fbconnection=[1 0 1 1 1]
n=length(fbconnection);
N=2^n-1;
register=[zeros(1,n-1) 1];%��λ�Ĵ����ĳ�ʼ״̬?
mseq(1)=register(n);%m���еĵ�һ�������Ԫ?
for i=2:N
    newregister(1)=mod(sum(fbconnection.*register),2);
		for j=2:n 
			newregister(j)=register(j-1);
		end;
register=newregister; 
if register(n)==0
    register(n)=-1;
end
mseq(i)=register(n);

end 