%version 2.0 corrected by Gaspard Pardon (gaspard@stanford.edu)
%version 1.0 written by O. Schwab (oschwab@stanford.edu)

function [ theta2,xs_frame,ys_frame,u1,v1,u1_0,v1_0,V,absd,Fx,Fy,F,Trx,Try,v,M] = calculate_tfm_constrain(filename,relax,contr,frame,maskpiv,cellmask,E,nu,conversion)
%calculates tfm between 2 frames
A=(1+nu)/(pi*E);

%transform mask, st 0s become Nans
mask=double(maskpiv);
%old_mask=mask;
binaryImage=double(cellmask);
mask(mask==0)=NaN;

%displ. needed: relax, contr, frame
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
deltaU=mask.*(us_contr-us_relax);
deltaV=mask.*(vs_contr-vs_relax);
u1_0=(us_contr-us_relax)-mean(deltaU(:),'omitnan').*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_contr-vs_relax)-mean(deltaV(:),'omitnan').*ones(size(vs_relax,1),size(vs_relax,2));

%angle
Ang=atand((mask.*v1_0)./(mask.*u1_0+eps));
Weights = sqrt(mask.*u1_0.^2+mask.*v1_0.^2);
theta_0 = sum(sum(Ang.*Weights,'omitnan'),'omitnan')./sum(sum(Weights,'omitnan'),'omitnan');

%between current frame and relaxed:
deltaU=mask.*(us_frame-us_relax);
deltaV=mask.*(vs_frame-vs_relax);
u1_0=(us_frame-us_relax)-mean(deltaU(:),'omitnan').*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_frame-vs_relax)-mean(deltaV(:),'omitnan').*ones(size(vs_relax,1),size(vs_relax,2));
x1=xs_frame;
y1=ys_frame;

u1=u1_0;
v1=v1_0;

%angle between curent frame and relaxed and delta_theta:
% Ang=atand((mask.*v1_0)./(mask.*u1_0+eps));
% Weights = sqrt(mask.*u1_0.^2+mask.*v1_0.^2);
% theta = sum(sum(Ang.*Weights,'omitnan'),'omitnan')./sum(sum(Weights,'omitnan'),'omitnan');


iter=1;
oldtracmax=1e6;
diff=1;
while iter<50 && diff>1e-6
    %step 1: normal unconstrained
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
                    K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2, -nu*i*j; -nu*i*j,(1-nu)*k^2+nu*j^2];
                end
                
                %2D identity
                H=eye(2);
                
                %now finally, the traction force calculation
                lambda=0; %no regul.
                Gn=K'*K+lambda^2*H;
                T=Gn\(K'*uk(1:end));
                Tx(ii,jj)=T(1);
                Ty(ii,jj)=T(2);
            end
        end
    end
    
    % Get the tractions at the lowest non-zero wave number k, i.e. at
    % dkx and dky, see Butler et al. Am J Physil Cell Physiol 2001
    Tx_dkx=Tx(1,2);
    Tx_dky=Tx(2,1);
    Ty_dkx=Ty(1,2);
    Ty_dky=Ty(2,1);
    
    % Calculate the traction moments and net contractile moment
    % using Tx and Ty at the lowest non-zero wave number k, i.e. at dkx and dky
    M(1,1) = real(((-1i/2)*(Tx_dkx+Tx_dkx))/(abs(sqrt(dkx^2+dky^2))));
    M(1,2) = real(((-1i/2)*(Ty_dkx+Tx_dky))/(abs(sqrt(dkx^2+dky^2))));
    M(2,1) = real(((-1i/2)*(Tx_dky+Ty_dkx))/(abs(sqrt(dkx^2+dky^2))));
    M(2,2) = real(((-1i/2)*(Ty_dky+Ty_dky))/(abs(sqrt(dkx^2+dky^2))));
    
    % align M to current dipole
    theta2 = atan2d((2*M(1,2)),-(M(1,1)-M(2,2)))/2;
    R=[cosd(theta2),sind(theta2);-sind(theta2),cosd(theta2)];
    M = R\M*R;
    
    %transform back into real space
    Trx=real((ifft2(Tx)));
    Try=real((ifft2(Ty)));
    
    %step 2: define a new traction field by setting the tractions outside the
    %cell boundary to zero.
    Trx_new=Trx.*binaryImage;
    Try_new=Try.*binaryImage;
    
    %norm of the tractions
    v = sqrt( Trx_new.^2 + Try_new.^2 );
    
    %step 3: calculate displacement field induced by this field: forward FT;
    Trx_new_fft=(fft2(Trx_new));
    Try_new_fft=(fft2(Try_new));
    
    u_new=zeros(size(Trx_new_fft));
    v_new=zeros(size(Try_new_fft));
    
    %wavevector: N points
    Nx=size(Trx_new_fft,2);
    Ny=size(Try_new_fft,1);
    
    D=(x1(1,3)-x1(1,2))*conversion*1e-6; %in m
    
    %wavenumber
    dkx=1/(Nx*D)*2*pi;
    kx=[0:fix(Nx/2)-1,-fix(Nx/2):-1]*dkx;
    dky=1/(Ny*D)*2*pi;
    ky=[0:fix(Ny/2)-1,-fix(Ny/2):-1]*dky;
    
    ii=0;
    for i=ky(1:end)
        ii=ii+1;
        jj=0;
        for j=kx(1:end)
            jj=jj+1;
            
            k=sqrt(i^2+j^2);
            
            Trxn=Trx_new_fft(ii,jj);
            Tryn=Try_new_fft(ii,jj);
            Trk=[Trxn;Tryn];
            
            if (i==0) && (j==0)
                u_new(ii,jj)=0;
                u_new(ii,jj)=0;
                
            else
                %Qingzong: at the nyquist frequency, set the off-diagonal element to zero, see Butler et al. Am J Physil Cell Physiol 2001
                if (ii==Ny/2)||(jj==Nx/2)
                    K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2,0; 0,(1-nu)*k^2+nu*j^2];
                else
                    K=A*2*pi/(k^3)*[(1-nu)*k^2+nu*i^2, -nu*i*j; -nu*i*j,(1-nu)*k^2+nu*j^2];
                end
                H=eye(2);
                
                lambda=0;%no regul
                
                Gn=K'*K+lambda^2*H;
                uk=K'\(Gn*Trk(1:end));
                u_new(ii,jj)=uk(1);
                v_new(ii,jj)=uk(2);
            end
        end
    end
    
    
    u1=real((ifft2(u_new)));
    v1=real((ifft2(v_new)));
    
    %step 4: replace dis inside cell by experimental results
    u1=u1.*double(~binaryImage)+u1_0.*binaryImage;
    v1=v1.*double(~binaryImage)+v1_0.*binaryImage;
    
    %increase counter
    iter=iter+1;
    
    diff=abs(oldtracmax-max(v(:)));
    oldtracmax=max(v(:));
end

% align displacements and tractions to the cell main axis
R=[cosd(theta_0),sind(theta_0);-sind(theta_0),cosd(theta_0)];
u1_2=u1*R(1,1)+v1*R(1,2);
v1_2=u1*R(2,1)+v1*R(2,2);
u1 = u1_2;
v1 = v1_2;

Trx_new_2=Trx_new*R(1,1)+Try_new*R(1,2);
Try_new_2=Trx_new*R(2,1)+Try_new*R(2,2);
Trx_new = Trx_new_2;
Try_new = Try_new_2;

%norm of the tractions
v = sqrt( Trx_new.^2 + Try_new.^2 );

%Interpolate traction data for every pixel
try
    [Xqu,Yqu]=meshgrid(xs_frame(1):xs_frame(end),ys_frame(1):ys_frame(end));
    V = interp2(xs_frame,ys_frame,v,Xqu,Yqu,'linear');
catch
    V=v;
end

%save displacement in matrix
absd=sqrt(u1_0.^2+v1_0.^2);

%forces calculation: every traction is wrt the area of 1px*1px
Apx=(conversion*1e-6)^2*(xs_frame(1,3)-xs_frame(1,2))*(ys_frame(3,1)-ys_frame(2,1));
Fx=Apx*Trx_new;
Fy=Apx*Try_new;
F=Apx*v;
M=Apx*M;

end

