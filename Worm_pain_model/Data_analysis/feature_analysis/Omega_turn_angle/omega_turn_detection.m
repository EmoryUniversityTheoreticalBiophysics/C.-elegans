%%calculate angle between head-middle vector and tail-middle vector
%%
%%

data = data_ctrl;
fI = I_ctrl;


headall = [];
tailall = [];

for i = 1:length(data)
    
    
    
    head(:,1) = data{i}.wormskelx(:,1);
    tail(:,1) = data{i}.wormskelx(:,41);
    middle(:,1) = data{i}.wormskelx(:,21);
    head(:,2) = data{i}.wormskely(:,1);
    tail(:,2) = data{i}.wormskely(:,41);
    middle(:,2) = data{i}.wormskely(:,21);
    
    %%calculate the distance between head and tail
    dist = sqrt(sum((head' - tail').^2));
    
    headall{i} = head;
    tailall{i} = tail;
    distall(i,:) = dist;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%calculate blend angle%%%%%%%%%%%%%%%%%%%%%
    mhvector = head - middle;
    mtvector = tail - middle;
    for j = 1:size(mhvector,1)
        bendangle(j,i) = angle_change(mhvector(j,:),mtvector(j,:));
    end
        %%%%%%%%
end
