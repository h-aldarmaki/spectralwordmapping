function [] = greedy_mapping(source_file, target_file, seed, n1, n2, out_file, max_itr)
rng('shuffle');
X = load(source_file);
Y = load(target_file); 
S = load(seed);

th = 0.01;
rv = 3; %virtual token cost

%remove less frequent words from seed lexicon
tmp=find(S(:,2) > n2);
S(tmp,:)=[];
tmp=find(S(:,1) > n1);
S(tmp,:)=[];

X = X(1:n1,:);
Y = Y(1:n2,:);

%calculate the euclidean distance between all rows
R1 = squareform(pdist(X));
R2 = squareform(pdist(Y));


%initialize mapping to virtual token
R2=[R2;ones(1,n2).*rv];
R2=[R2 (ones(n2+1,1).*rv)];
M=ones(1,n1).*(n2+1); %initial mapping to virtual token

%seed tokens mapping 
M(S(:,1))=S(:,2);

%initial cost
C=(R1-R2(M,M)).^2;
old_cost=sum(sum(triu(C))); %sum of square losses
%loop until convergence or max_itr
for itr = 1:max_itr 
  fprintf('[greedy_mapping.m]: iteration=%d\n', itr); 
  updated = 0;
  perm=randperm(n1);
  for i = 1:n1 
    idx=perm(i); 
    old_C=sum(C(idx,:));
    map=M(idx);
    for j = 1:n2 %loop through all possible maapings
      if j==map %skip old mapping
        continue
      end
      new_M=M;
      new_M(idx)=j;
      new_C = sum((R1(idx,:)-R2(new_M(idx),new_M)).^2);
      if (new_C < old_C)
        old_C=new_C;
        map=j;
        updated=1;
      end
    end
    M(idx)=map;
  end
  C=(R1-R2(M,M)).^2;
  new_cost=sum(sum(triu(C)));
  gain=old_cost-new_cost;
  old_cost=new_cost;
  fprintf('cost of mapping=%f  gain=%f\n', new_cost, gain);
  if updated == 0  %convergence
     break
  end
  errs=sum(C,2)./n1;
  L= [[1:n1]' M' errs];
  dlmwrite(out_file,L,'delimiter',' ');
end

L= [[1:n1]' M' errs];
dlmwrite(out_file,L,'delimiter',' ');

end

