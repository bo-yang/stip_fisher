function [ fvt ] = compute_fisher( params, pca_coeff, gmm, file_list )
%COMPUTE_FISHER Computer postitive/negative Fisher Vectors for each class

fvt=[];

%feat_idx=find(strcmp(params.feat_list,feat_type)); % find the index of feature in feat_list

% TODO:
% Should the following code be executed in parallel?
% The label of each FV is not an issue, because all of them could be
% assigned 1(positive files) or -1(negative files).
% What about the concatenation of Fisher vectors?
for j=1:length(file_list)
	action=regexprep(file_list{j},'/v_(\w*)\.avi','');
	act_dir=fullfile(params.stip_dir,action);
	clip_name=regexprep(file_list{j},'\.avi$',''); % get video clip name
	clip_name=regexprep(clip_name,'.*/','');
	file=fullfile(act_dir,[clip_name,'.stip']);
	
	[HOG,HOF]=extract_stip_feats(file, params, -1);
	
	%fv_hog=fisher_encode(HOG,pca_coeff{1},gmm{1});
	%fv_hof=fisher_encode(HOF,pca_coeff{2},gmm{2});
	fv_hog=fisher_encode(HOG,pca_coeff{1},gmm{1},params);
	fv_hof=fisher_encode(HOF,pca_coeff{2},gmm{2},params);
	
	fv=[fv_hog;fv_hof];
	fvt=[fvt fv]; % concatenate all features together
end

end

