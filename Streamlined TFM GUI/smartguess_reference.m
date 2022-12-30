%version 1.0 written by O. Schwab (oschwab@stanford.edu)

function [ relax,contr ] = smartguess_reference(Num,us,vs,mask)
%smart guess relaxed and contracted frame fr. displacement data

%find the best fit for relaxed and contracted
K2=zeros(1,Num);
for frame=1:Num
    Nref_test=frame;
    
    u1ref=us{Nref_test};
    v1ref=vs{Nref_test};
    
    %transform mask, st 0s become Nans
    mask=double(mask);
    mask(mask==0)=NaN;
    
    %sum
    d=zeros(1,Num);
    for ktest=1:Num
        deltaU=mask.*(us{ktest}-u1ref);
        deltaV=mask.*(vs{ktest}-v1ref);
        usn=(us{ktest}-u1ref)-mean(deltaU(:),'omitnan').*ones(size(u1ref,1),size(u1ref,2));
        vsn=(vs{ktest}-v1ref)-mean(deltaV(:),'omitnan').*ones(size(v1ref,1),size(v1ref,2));
        dsn=mask.*sqrt(usn.^2+vsn.^2);
        d(ktest)=mean(dsn(:),'omitnan');
    end
    d(Nref_test)=NaN;
    K1=max(d,[],'omitnan')-min(d,[],'omitnan');
    K2(frame)=sum(d,'omitnan');
    
    %look for relaxed
    if frame==1
        K1_1=K1; 
        relax=1; [~,contr]=max(d,[],'omitnan');
    else
        if K1>K1_1
        relax=frame;
        [~,contr]=max(d,[],'omitnan');
        K1_1=K1;
        end
    end
end


%check which is really relaxed/contratced
if K2(contr)<K2(relax)
    %switch
    temp=contr;
    contr=relax;
    relax=temp;
end


end

