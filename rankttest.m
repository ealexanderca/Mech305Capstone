function out=rankttest(X,p)
X2=X-mean(X,'omitnan');
[~,n]=size(X);
rank=ones(1,n);
for i=1:n
    for j=1+i:n
        if ttest2(X2(:,i),X2(:,j),'Alpha',p,'tail','both')==0
            if mean(X(:,i),'omitnan') > mean(X(:,j),'omitnan')
                rank(i)=rank(i)+1;
            else
                rank(j)=rank(j)+1;
            end
        else
            rank(i)=rank(i)+.5;
            rank(j)=rank(j)+.5;
        end
    end
end
vallast=0;
for i=1:n
    [val,b]=max(rank);
    rank(b)=0;
    if val==vallast
        out(b)=rlast;
    else
        rlast=i;
        out(b)=i;
    end    
    vallast=val;
end