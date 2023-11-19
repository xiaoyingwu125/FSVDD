
addpath(genpath(pwd))
% parameter setting
kernel = Kernel('type', 'gaussian', 'gamma', 0.00001);
cost = 0.8;
[n, d] = size(cattt);
X =cattt(:,1:d-1);

Dists = squareform(pdist(X,'seuclidean'));
maxDist = max(max(Dists));

dc = 0.8 * maxDist;
rho = zeros(n, 1);
for i=1:n-1
    for j=i+1:n
        rho(i)=rho(i)+exp(-(Dists(i,j)/dc)*(Dists(i,j)/dc));
        rho(j)=rho(j)+exp(-(Dists(i,j)/dc)*(Dists(i,j)/dc));
    end
end

delta = zeros(n, 1);
master = -ones(n, 1);
[~, ordrho] = sort(rho, 'descend');
delta(ordrho(1)) = maxDist;
for i = 2:n
    delta(ordrho(i)) = maxDist;
    for j = 1:i-1
        if Dists(ordrho(i), ordrho(j)) < delta(ordrho(i))
            delta(ordrho(i)) = Dists(ordrho(i), ordrho(j));
            master(ordrho(i)) = ordrho(j);
        end
    end
end
gamma = rho .* delta;
[~, desInd] = sort(gamma, 'descend');               %%%%%%%desInd为按降序排列的索引
maxGamma = max(gamma);

num_condition_attr=size(n,2)-1;%条件属性的个数
num_object=size(n,1);%对象（记录）的个数
distinct_matrix=cell(num_object,num_object);
for i=1:num_object
    for j=i+1:num_object
        differ=zeros(1,num_condition_attr);
        if ~isequal(distinct_value_matrix(i,:),distinct_value_matrix(j,:))%如果区分值不一样
            for k=1:num_condition_attr%计算不同的属性
                if decision_table(i,k)~=decision_table(j,k)
                    differ(k)=k;
                end
            end
        end
        distinct_matrix{i,j}=differ;
    end
end
svddParameter = struct('cost', cost,'kernelFunc', kernel);
svdd = BaseSVDD(svddParameter);
results = svdd.train(cattt, catlab );
   svplot = SvddVisualization();


