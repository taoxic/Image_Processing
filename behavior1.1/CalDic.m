function a=CalDic(data,dicsize)  
%ʹ��ѵ�����ݽ����ֵ�
fprintf('Building Dictionary using Training Data\n\n');  
dictionarySize = dicsize;  %�ֵ�Ĵ�С
niters=100;%��������  
centres=zeros(dictionarySize,size(data,2));  %�ֵ��СΪ�У����ݵ���Ϊ��
[ndata,data_dim]=size(data);  %data������������
[ncentres,dim]=size(centres);  %centres������������
    %% initialization  ��ʼ��
      
    perm = randperm(ndata);  %perm�ǰ�1��ndata��Щ��������ҵõ���һ���������С�
    perm = perm(1:ncentres);  
    centres = data(perm, :);  
      
    num_points=zeros(1,dictionarySize);  
    old_centres = centres;  
    display('Run k-means');  %����k-means
      
    for n=1:niters  %����ѭ��
        % Save old centres to check for termination  
        e2=max(max(abs(centres - old_centres)));  
          
        inError(n)=e2;  
        old_centres = centres;  
        tempc = zeros(ncentres, dim);  
        num_points=zeros(1,ncentres);               
              
            
            [ndata, data_dim] = size(data);  
              
            id = eye(ncentres);  
            d2 = EuclideanDistance(data,centres); 
			
            % Assign each point to nearest centre  ָ��ÿ���㵽���������
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
            % Test for termination  ��ֹ���
              
            %Threshold  
            ThrError=0.009;  
              
            if max(max(abs(centres - old_centres))) <0.009  
                dictionary= centres;  
                fprintf('Saving texton dictionary\n');  
%                 mkdir('data');%����data�ļ���  
				    a = dictionary;
%                 save ('data\dictionary','dictionary');%����dictionary��data�ļ����¡�  
                break;  
            end  
              
            fprintf('The %d th interation finished \n',n);  
        end  
          
    end  