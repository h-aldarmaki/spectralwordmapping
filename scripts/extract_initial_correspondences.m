function [] = extract_initial_correspondences(source, target, source_words, target_words, k,out_file)

%Load vectors
T=load(target);
S=load(source);

%load vocab
fid=fopen(source_words,'r','n','UTF-8');
CStr = textscan(fid, '%s', 'delimiter', '\n');
fclose(fid)  ;
SW=CStr{1};

fid=fopen(target_words,'r','n','UTF-8');
CStr = textscan(fid, '%s', 'delimiter', '\n');
fclose(fid)  ;
TW=CStr{1};

%calculate spectral features for each target vector
[idx, dist] = knnsearch( T, T , 'k', k);  
A=zeros(size(T,1), k );
for ii = 1:size(idx,1)    
  %construct D for the k neighbors and calculate the eigenvalues
  D = squareform(pdist(T(idx(ii,:),:)));    
  D = exp(-0.5 * (D.^2)/10); % 10 is chosen arbitrarily
  L = eye(k) - D; 
  A(ii,:)= sort(eig(L),'descend');
end

%calculate spectrak features for each source vector
[idx2, dist2] = knnsearch(S, S , 'k', k);  
B=zeros(size(S,1), k );
for ii = 1:size(idx2,1)    
  D = squareform(pdist(S(idx2(ii,:),:)));     
  D = exp(-0.5 * (D.^2)/10);
  L = eye(k) - D;
  B(ii,:)= sort(eig(L),'descend') ;
end

%find the closest points in the feature space
[idx, dist] = knnsearch( A, B , 'k', 1);  
[idx2, dist2] = knnsearch( B, A , 'k', 1); 

%output correspondences
fid = fopen(out_file,'w','native', 'UTF-8');
for i=1:size(S,1)         
  if idx2(idx(i))   == i  % make sure the neighborhood is symmetric
     fprintf(fid,'%s\t%s\t%f\n', SW{i}, TW{idx(i)}, dist(i)); 
  end
end
fclose(fid);

end
