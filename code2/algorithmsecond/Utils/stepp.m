function [g,b]=stepp(L,ykg,ykb,gradg,gradb,lambda1,lambda2)
tempg=ykg-gradg/L;
tempb=ykb-gradb/L;
temp1=max(tempg-lambda1/L,0);
temp2=min(tempg+lambda1/L,0);
temp3=max(tempb-lambda2/L,0);
temp4=min(tempb+lambda2/L,0);
g=max(temp1+temp2,0);
b=temp3+temp4;