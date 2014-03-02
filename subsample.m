function [X,file_list,labels] = subsample(params,t_type)
% SUBSAMPLE subsample STIP features
% outputs:
%	X - cell of STIP features
%	labels - labels of corresponding STIP features
%	file_list - list of all files

X=cell(length(params.feat_list),1);
labels=[];

switch t_type
	case 'train'
		tt_list_dir=params.train_list_dir;
		reg_pattern='train*';
	case 'test'
		tt_list_dir=params.test_list_dir;
		reg_pattern='test*';
	otherwise
		error('Unknown file pattern!');
end

% extract training/test list
tt_list=[]; % train/test files
tlists=dir(fullfile(tt_list_dir,reg_pattern));
for i=1:length(tlists)
	fid=fopen(fullfile(tt_list_dir,tlists(i).name));
	tmp=textscan(fid,'%s%d');
	tt_list=[tt_list;tmp{1}];
	labels=[labels;tmp{2}];
end
file_list=tt_list;

switch t_type
	case 'train'
		HOG=[];
		HOF=[];
		parfor i=1:length(tt_list)
			action=regexprep(tt_list{i},'/v_(\w*)\.avi','');
			act_dir=fullfile(params.stip_dir,action);
			clip_name=regexprep(tt_list{i},'\.avi$',''); % get video clip name
			clip_name=regexprep(clip_name,'.*/','');
			stip_file=fullfile(act_dir,[clip_name,'.stip']);
			
			[newHOG,newHOF]=extract_stip_feats(stip_file,params,params.STIP_subsample_num);
			
			HOG=[HOG newHOG];
			HOF=[HOF newHOF];
		end
		%matlabpool close
		
		X{1}=HOG;
		clear HOG;
		X{2}=HOF;
		clear HOF;
	case 'test'
		% Do nothing
		% Test videos should not be subsampled.
	otherwise
		error('Unknown file pattern!');
end

end