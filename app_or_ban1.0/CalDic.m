function a=CalDic(data,dicsize)  
%使用训练数据建立字典
fprintf('Building Dictionary using Training Data\n\n');  
dictionarySize = dicsize;  %字典的大小
niters=100;%迭代次数  
centres=zeros(dictionarySize,size(data,2));  %字典大小为行，数据的列为列
[ndata,data_dim]=size(data);  %data的行数和列数
[ncentres,dim]=size(centres);  %centres的行数和列数
    %% initialization  初始化
      
    perm = randperm(ndata);  %perm是把1到ndata这些数随机打乱得到的一个数字序列。
    perm = perm(1:ncentres);  
    centres = data(perm, :);  
      
    num_points=zeros(1,dictionarySize);  
    old_centres = centres;  
    display('Run k-means');  %运行k-means
      
    for n=1:niters  %迭代循环
        % Save old centres to check for termination  
        e2=max(max(abs(centres - old_centres)));  
          
        inError(n)=e2;  
        old_centres = centres;  
        tempc = zeros(ncentres, dim);  
        num_points=zeros(1,ncentres);               
              
            
            [ndata, data_dim] = size(data);  
              
            id = eye(ncentres);  
            d2 = EuclideanDistance(data,centres); 
			
            % Assign each point to nearest centre  指定每个点到最近的中心
            [minvals, index] = min(d2', [], 1);  
            post = id(index,:); % matrix, if word i is in cluster j, post(i,j)=1, else 0;  
              
            num_points = num_points + sum(post, 1);  
              
            for j = 1:ncentres  
                tempc(j,:) =  tempc(j,:)+sum(data(find(post(:,j)),:), 1);  
            end              
          
          
        for j = 1:ncentres  
            if num_points(j)>0  
                centres(j,:) =  tempc(j,:)/num_points(j);  
            end  
        end  
        if n > 1  
            % Test for termination  终止检测
              
            %Threshold  
            ThrError=0.009;  
              
            if max(max(abs(centres - old_centres))) <0.009  
                dictionary= centres;  
                fprintf('Saving texton dictionary\n');  
%                 mkdir('data');%建立data文件夹  
				    a = dictionary;
%                 save ('data\dictionary','dictionary');%保存dictionary到data文件夹下。  
                break;  
            end  
              
            fprintf('The %d th interation finished \n',n);  
        end  
          
    end  