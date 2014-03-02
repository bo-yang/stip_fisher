function fvt=fisher_encode(feats,pca_coeff, gmm, params)
% Perform Fisher Vector encoding using PCA coefficients and pretrained GMM
% parameters.

coef=gmm.coef;
mean=gmm.mean;
var=gmm.variance;

% L1 normalization & Square root
feats=sqrt(feats/norm(feats,1));
% Apply PCA
feats=pca_coeff*feats; 

D=size(feats,1);
T=size(feats,2);
K=params.K;

% Fisher vector, dimension (2D+1)*K
fvt=zeros((2*D+1)*K,1); 

% Initialize accumulators
S0=zeros(K,1);
S1=zeros(K,D); % KxD matrix
S2=zeros(K,D); % KxD matrix

% Compute statistics
for t=1:T
    g=zeros(K,1); % Gaussians
    gamma=zeros(K,1); % soft assignment of x_t to Gaussian k
    for k=1:K
        % Compute the soft assignment of x_t to Gaussian k
        g(k)=Gauss(feats(:,t),mean(:,k),var(:,k)');
	end
	g(isinf(g))=1e30; % Replace inf with a very large number
    gamma=coef.*g/(coef'*g);
    
    S0=S0+gamma;
    S1=S1+gamma*feats(:,t)';
    S2=S2+gamma*(feats(:,t)'.^2);
end

% Compute the Fisher vector signature
Galpha=zeros(K,1);
Gmiu=zeros(K,D); % KxD matrix
Gcov=zeros(K,D); % KxD matrix

Galpha=(S0-T*coef)./sqrt(coef);
% TODO: substitute for loop by matrix multiplication
for k=1:K
    Gmiu(k,:)=(S1(k,:)-mean(:,k)'*S0(k))./(sqrt(coef(k))*var(:,k)');
    Gcov(k,:)=(S2(k,:)-2*S1(k,:)*mean(:,k)+((mean(:,k)').^2-(var(:,k)').^2 )*S0(k))./(sqrt(2*coef(k))*(var(:,k)').^2);
end
fvt=[Galpha;Gmiu(:);Gcov(:)];

% Replace NaN with very large number
fvt(isnan(fvt)) = 123456;

% Apply normalizations
% power normalization
fvt = sign(fvt) .* sqrt(abs(fvt));
% L2 normalization
fvt = double(fvt/sqrt(fvt'*fvt));

end

function u=Gauss(x,miu,sigma)
% Computer Gaussian distribution
%   x - 1xD input feature
%   miu - 1xD mean
%   sigma - 1xD variance

D=size(x,1);
u=1./((2*pi)^(D/2)*sqrt(abs(sigma)))*exp(-0.5*(x-miu)'*(1./sigma')*(x-miu));

end