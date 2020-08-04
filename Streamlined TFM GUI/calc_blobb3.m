%version 2.0 corrected by Gaspard Pardon (gaspard@stanford.edu)
%version 1.0 written by O. Schwab (oschwab@stanford.edu)

function [ displacement,alphamean,alphastd,displacement_roi,alphamean_roi,alphastd_roi,alpha, dis_pts,dis_pts_dwnsamp]=calc_blobb3( filename,relax,contr,frame,mask,binary0,roitag,roinumber,roi_i)
%calculate displacements and angles for bf: outline + rois !

%displ. needed: relax, contr, frame (FOSTER: change way data is loaded)
%relax
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_u.mat']);
us_relax=s.fu(:,:,relax);
us_contr=s.fu(:,:,contr);
us_frame=s.fu(:,:,frame);
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_v.mat']);
vs_relax=s.fv(:,:,relax);
vs_contr=s.fv(:,:,contr);
vs_frame=s.fv(:,:,frame);
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_x.mat']);
xs_frame=s.x(:,:,frame);
s=matfile(['vars_DO_NOT_DELETE/',filename,'/tfm_piv_y.mat']);
ys_frame=s.y(:,:,frame);

%transform mask, st 0s become Nans
mask=double(mask);
mask(mask==0)=NaN;

%get angle
deltaU=mask.*(us_contr-us_relax);
deltaV=mask.*(vs_contr-vs_relax);
u1_0=(us_contr-us_relax)-nanmean(deltaU(:)).*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_contr-vs_relax)-nanmean(deltaV(:)).*ones(size(vs_relax,1),size(vs_relax,2));

%angle
Ang=atan((v1_0)./(u1_0+eps));
Ang_vec = subsref(Ang.', substruct('()', {':'})).';
theta=mean(Ang_vec)*180/pi;

%between current frame and relaxed:
deltaU=mask.*(us_frame-us_relax);
deltaV=mask.*(vs_frame-vs_relax);
u1_0=(us_frame-us_relax)-nanmean(deltaU(:)).*ones(size(us_relax,1),size(us_relax,2));
v1_0=(vs_frame-vs_relax)-nanmean(deltaV(:)).*ones(size(vs_relax,1),size(vs_relax,2));
x1=xs_frame;
y1=ys_frame;

%transform to cell coordinate system
R=[cosd(theta),-sind(theta);sind(theta),cosd(theta)];
u1=u1_0*R(1,1)+v1_0*R(1,2);
v1=u1_0*R(2,1)+v1_0*R(2,2);

%interpolate for every pixel
xi=1:size(binary0,2);
yi=1:size(binary0,1);
[Xqu,Yqu]=meshgrid(xi,yi);
U1 = interp2(x1,y1,u1,Xqu,Yqu,'linear',0);
V1 = interp2(x1,y1,v1,Xqu,Yqu,'linear',0);

%transofrm displacements into local CS
alpha=pi+theta;
R=[cosd(alpha),-sind(alpha);sind(alpha),cosd(alpha)];
un_prime=U1*R(1,1)+V1*R(1,2);
vn_prime=U1*R(2,1)+V1*R(2,2);
dis_pts=sqrt(un_prime.^2+vn_prime.^2);

dis_pts_dwnsamp = sqrt(u1.^2+v1.^2);


%%now mean, aver, angle for outline and roi
%outline
%consider only the displacements inside blobb at stage B
un=U1.*binary0;
vn=V1.*binary0;
un_prime2=un*R(1,1)+vn*R(1,2);
vn_prime2=un*R(2,1)+vn*R(2,2);

%average and std angle of displacmeents
un_prime_vec = subsref(un_prime2.', substruct('()', {':'})).';
vn_prime_vec = subsref(vn_prime2.', substruct('()', {':'})).';
un_prime_vec(isnan(un_prime_vec))=[];
vn_prime_vec(isnan(vn_prime_vec))=[];


binary3=double(binary0);
binary3(binary3==0)=NaN;
un3=U1.*binary3;
vn3=V1.*binary3;
alpha=atand(vn3./un3);

%makenvectors and delete NaN (i.e. outside cell)
un3_vec = subsref(un3.', substruct('()', {':'})).';
vn3_vec = subsref(vn3.', substruct('()', {':'})).';
un3_vec(isnan(un3_vec))=[];
vn3_vec(isnan(vn3_vec))=[];
displacement=mean(sqrt(un3_vec.^2+vn3_vec.^2));


alphamean=mean(atand(vn3_vec./(un3_vec+eps)));
alphastd=std(atand(vn3_vec./(un3_vec+eps)));
if frame==relax
alphamean=NaN;
alphastd=NaN;
end

%rois:
alphamean_roi=NaN*ones(1,roinumber);
alphastd_roi=NaN*ones(1,roinumber);
displacement_roi=NaN*ones(1,roinumber);

if roitag
    for roi=1:roinumber
        bin_roi_curr=roi_i(roi);
        bin_roi_curr=double(bin_roi_curr{1});
        
        un=U1.*bin_roi_curr;
        vn=V1.*bin_roi_curr;
        un_prime2=un*R(1,1)+vn*R(1,2);
        vn_prime2=un*R(2,1)+vn*R(2,2);
        
        %average and std angle of displacmeents
        un_prime_vec = subsref(un_prime2.', substruct('()', {':'})).';
        vn_prime_vec = subsref(vn_prime2.', substruct('()', {':'})).';
        un_prime_vec(isnan(un_prime_vec))=[];
        vn_prime_vec(isnan(vn_prime_vec))=[];
        alphamean_roi(roi)=mean(atand(vn_prime_vec./(un_prime_vec+eps)));
        alphastd_roi(roi)=std(atand(vn_prime_vec./(un_prime_vec+eps)));
        if frame==relax
            alphamean_roi(roi)=NaN;
            alphastd_roi(roi)=NaN;
        end
        
        binary3=double(bin_roi_curr);
        binary3(binary3==0)=NaN;
        un3=U1.*binary3;
        vn3=V1.*binary3;
        
        %makenvectors and delete NaN (i.e. outside cell)
        un3_vec = subsref(un3.', substruct('()', {':'})).';
        vn3_vec = subsref(vn3.', substruct('()', {':'})).';
        un3_vec(isnan(un3_vec))=[];
        vn3_vec(isnan(vn3_vec))=[];
        displacement_roi(roi)=mean(sqrt(un3_vec.^2+vn3_vec.^2));
        
        %test
        %disp(num2str(alphastd_roi(roi)))
    end    
    
end

end

