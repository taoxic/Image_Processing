function His=HardVoting(data,dic)  
ncentres=size(dic,1);  
id = eye(ncentres);  
d2 = EuclideanDistance(data,dic);% Assign each point to nearest centre  
[minvals, index] = min(d2', [], 1);  
post = id(index,:); % matrix, if word i is in cluster j, post(i,j)=1, else 0  
His=sum(post, 1);  
end  