%version 2.0 corrected by Gaspard Pardon (gaspard@stanford.edu)
%version 1.0 written by O. Schwab (oschwab@stanford.edu)

function [ theta_0,x1,y1,u1,v1,u1_0,v1_0,V,lambda,rho,eta] = calculate_tfm_regul(filename,relax,contr,frame,mask,E,nu,conversion)
%calculates tfm between 2 frames
A=(1+nu)/(pi*E);

%transform mask, st 0s become Nans
mask=double(mask);
%old_mask=mask;
mask(mask==0)=NaN;

%displ. needed: relax, contr, frame %FOSTER
%relax
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_u.mat']);
us_relax=s.fu(:,:,relax);
us_contr=s.fu(:,:,contr);
us_frame=s.fu(:,:,frame);
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_v.mat']);
vs_relax=s.fv(:,:,relax);
vs_contr=s.fv(:,:,contr);
vs_frame=s.fv(:,:,frame);
%contr
% s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_u.mat']);
% us_contr=s.fu(:,:,contr);
% s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_v.mat']);
% vs_contr=s.fv(:,:,contr);
%relax
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_x.mat']);
xs_frame=s.x(:,:,frame);
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_y.mat']);
ys_frame=s.y(:,:,frame);
% s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_u.mat']);
% us_frame=s.fu(:,:,frame);
% s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_v.mat']);
% vs_frame=s.fv(:,:,frame);

%get angle
deltaU=(us_contr-us_relax);%mask.*(us_contr-us_relax);
deltaV=(vs_contr-vs_relax);%mask.*(vs_contr-vs_relax);
u1_0=(us_contr-us_relax)-mean(deltaU(:),'omitnan').*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_contr-vs_relax)-mean(deltaV(:),'omitnan').*ones(size(vs_relax,1),size(vs_relax,2));

%angle
Ang=atand((mask.*v1_0)./(mask.*u1_0+eps));
Weights = sqrt(mask.*u1_0.^2+mask.*v1_0.^2);
theta_0 = sum(sum(Ang.*Weights,'omitnan'),'omitnan')./sum(sum(Weights,'omitnan'),'omitnan');
% Ang=atan((mask.*v1_0)./(mask.*u1_0+eps));
% Ang_vec = subsref(Ang.', substruct('()', {':'})).';
% Ang_vec(isnan(Ang_vec))=[];
% theta=mean(Ang_vec)*180/pi;

% mask_data = regionprops(cellmask,'Orientation');
% theta = mask_data.Orientation;

%between current frame and relaxed:
deltaU=(us_frame-us_relax);%mask.*(us_frame-us_relax);
deltaV=(vs_frame-vs_relax);%mask.*(vs_frame-vs_relax);
u1_0=(us_frame-us_relax)-mean(deltaU(:),'omitnan').*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_frame-vs_relax)-mean(deltaV(:),'omitnan').*ones(size(vs_relax,1),size(vs_relax,2));
x1=xs_frame;
y1=ys_frame;

u1=u1_0;
v1=v1_0;

%%1. lambda determining
%restrict to 50x50 area for performance
nx=min(25,floor(size(u1,2)/2));
ny=min(25,floor(size(u1,1)/2));

%Get center postion of the frame
mx=ceil(size(u1,2)/2);
my=ceil(size(u1,1)/2);

%fourier transform of window stretching by nx and ny on either sides of the
%center of the frame in x and y direction
u=(fft2(u1(my-(ny-1):my+ny,mx-(nx-1):mx+nx)));
v=(fft2(v1(my-(ny-1):my+ny,mx-(nx-1):mx+nx)));

%initialize traction vectors w. nans
Tx=zeros(size(u));
Ty=zeros(size(v));

%image size
Nx=size(u,2);
Ny=size(v,1);

%distance between grid points
D=(x1(1,3)-x1(1,2))*conversion*1e-6; %in m

%wavenumbers: theory from fourier transform; matlab starts at f=0:N/2 then
%from -N/2 to -1;
dkx=1/(Nx*D)*2*pi;
kx=[0:fix(Nx/2)-1,-fix(Nx/2):-1]*dkx;
dky=1/(Ny*D)*2*pi;
ky=[0:fix(Ny/2)-1,-fix(Ny/2):-1]*dky;

%determine lambda for regularization
ii=0;
n=0;
Gt=zeros(2*(length(kx)-1)*(length(ky)-1),2*(length(kx)-1)*(length(ky)-1));
ut=zeros(2*(length(kx)-1)*(length(ky)-1),1);

%loop over wavenumbers
for i=ky(1:end)
    ii=ii+1;
    jj=0;
    for j=kx(1:end)
        jj=jj+1;
        n=n+1;
        
        k=sqrt(i^2+j^2);
        un=u(ii,jj);
        vn=v(ii,jj);
        uk=[un;vn]*conversion*1e-6;
        
        %at f=0 the tractions must be 0
        if (i==0) && (j==0)
            Tx(ii,jj)=0;
            Ty(ii,jj)=0;
            
        else
            %Qingzong: at the nyquist frequency, set the off-diagonal element to zero, see Butler et al. Am J Physil Cell Physiol 2001
            if (ii==Ny/2)||(jj==Nx/2)
                K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2,0; 0,(1-nu)*k^2+nu*j^2];
            else
                K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2,-nu*i*j;-nu*i*j,(1-nu)*k^2+nu*j^2];
            end
            
            %regul. for l-curve
            Gt(2*n-1:2*n,2*n-1:2*n)=K'*K;
            ut(2*n-1:2*n,1)=K'*uk;
            
        end
    end
end

%regul
[U,s,~]=csvd(Gt);
[lambda,rho,eta,~]=l_curve(U,s,ut(1:end));
lambda=sqrt(lambda);

%%2. preview
%fourier transform
u=(fft2(u1));
v=(fft2(v1));

%initialize traction vectors w. nans
Tx=zeros(size(u));
Ty=zeros(size(v));

%image size
Nx=size(u,2);
Ny=size(v,1);

%distance between grid points
D=(x1(1,3)-x1(1,2))*conversion*1e-6; %in m

%wavenumbers: theory from fourier transform; matlab starts at f=0:N/2 then
%from -N/2 to -1;
dkx=1/(Nx*D)*2*pi;
kx=[0:fix(Nx/2)-1,-fix(Nx/2):-1]*dkx;
dky=1/(Ny*D)*2*pi;
ky=[0:fix(Ny/2)-1,-fix(Ny/2):-1]*dky;

ii=0;
%loop over wavenumbers
for i=ky(1:end)
    ii=ii+1;
    jj=0;
    for j=kx(1:end)
        jj=jj+1;
        
        k=sqrt(i^2+j^2);
        un=u(ii,jj);
        vn=v(ii,jj);
        uk=[un;vn]*conversion*1e-6;
        
        %at f=0 the tractions must be 0
        if (i==0) && (j==0)
            Tx(ii,jj)=0;
            Ty(ii,jj)=0;
            
        else
            %Qingzong: at the nyquist frequency, set the off-diagonal element to zero, see Butler et al. Am J Physil Cell Physiol 2001
            if (ii==Ny/2)||(jj==Nx/2)
                K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2,0; 0,(1-nu)*k^2+nu*j^2];
            else
                K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2,-nu*i*j; -nu*i*j,(1-nu)*k^2+nu*j^2];
            end
                       
            %2D identity
            H=eye(2);
            
            %now finally, the traction force calculation
            Gn=K'*K+lambda^2*H;
            T=Gn\(K'*uk(1:end));
            Tx(ii,jj)=T(1);
            Ty(ii,jj)=T(2);
        end
    end
end

%transform back into real space
Trx=real((ifft2(Tx)));
Try=real((ifft2(Ty)));

% % align T to the cell main axis
R=[cosd(theta_0),sind(theta_0);-sind(theta_0),cosd(theta_0)];
u1_2=u1*R(1,1)+v1*R(1,2);
v1_2=u1*R(2,1)+v1*R(2,2);
u1 = u1_2;
v1 = v1_2;

Trx_2=Trx*R(1,1)+Try*R(1,2);
Try_2=Trx*R(2,1)+Try*R(2,2);
Trx = Trx_2;
Try = Try_2;

%norm of the tractions
v = sqrt( Trx.^2 + Try.^2 );

%Interpolate traction data for every pixel
try
[Xqu,Yqu]=meshgrid(x1(1):x1(end),y1(1):y1(end));
V = interp2(x1,y1,v,Xqu,Yqu,'linear');
catch
    V=v;
end

end

