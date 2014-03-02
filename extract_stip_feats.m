function [ HOG,HOF ] = extract_stip_feats( stip_file, params, num_feats )
%EXTRACT_STIP_FEATS extract STIP features.
%   The first 9 elements for each line in stip_file are information about the trajectory.
%	
%   Subsampling:
%       randomly choose 1000 descriptors from each video clip(stip file)
%		To use all the STIP fatures, set num_feats to a negative number.
%

HOG=zeros(params.feat_len_map('HOG'),1);
HOF=zeros(params.feat_len_map('HOF'),1);

if ~exist(stip_file,'file')
	warning('File %s does not exist! Skip now...',stip_file);
	return;
else
	tmpfile=dir(stip_file);
	if tmpfile.bytes < 1024
		warning('File %s is too small! Skip now...',stip_file);
		return;
	end
end

try
	x=load(stip_file);
catch exception
	warning('failed to load file %s!',stip_file);
	return;
end

hog_range=params.feat_start:params.feat_start+params.feat_len_map('HOG')-1;
hof_range=hog_range(end)+1:hog_range(end)+params.feat_len_map('HOF');

if num_feats<0 % To use all the STIP fatures, set num_feats to a negative number
	num_feats=size(x,1);
end

if size(x,1)<=num_feats
	idx=1:size(x,1); % randomly subsampling
else
	idx=randperm(size(x,1),num_feats); % randomly subsampling
end
HOG=x(idx,hog_range)';
HOF=x(idx,hof_range)';

end

