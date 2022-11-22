%version 1.0 written by Gaspard Pardon (gaspard@stanford.edu)

function [s,p_av] = peak_averaging(t, signal, fs, incl_diff)
%function to find repeating pattern in signal, extract repeating peak and
%calculate average peak
%Input arguments: signal time vector, curve signal, frame rate/sampling
%    frequency, include differential calculation
%Oupt arguments: peak_av structure with fields: 
%t_peak, av_peak, peak_max, peak_max_t, peak_min, peak_min_t,...
%    peak_bl, p_av.peak_amp, dpeak_max, dpeak_max_t, dpeak_min, dpeak_min_t,...
%    peak_area_contr, peak_area_rel, peak_area_tot, autocorr_signal, frequency,
%    n_peaks, comments;
%corresponding to: peak time vector, average peak signal, peak max, peak max time location, peak
%minimums, peak minimums locations, baseline, peak amplitude, first derivative maximum, first derivative maximum time location, first derivative
%minimum,first derivative minimum time location, area under the curve
%during contraction, area under the curve during relaxation, total area
%under the peak, auto-correlation signal, peaks frequency, number of peaks
%detected, comments

%Initialize output structure with NaNs
s.fsignal = NaN;
s.signal_t = t;
s.framerate = fs;
s.autocorr_signal = NaN;
s.autocorr_lags = NaN;
s.autocorr_peaks = NaN;
s.autocorr_peaks_lags = NaN;
s.av_peak_spac = NaN;
s.av_peak_spac_std = NaN;
s.f_main_peak = NaN;
s.f_main_peak_std = NaN;
s.av_peak_w = NaN;%?
s.av_peak_w_std = NaN;%?
s.comment = '';

s.peaks = NaN;
s.peaks_lags = NaN;
s.ref_peak = NaN;
s.ref_peak_lag = NaN;

p_av.peaks = NaN;
p_av.n_peaks = NaN;

p_av.filtyoffs = NaN;

p_av.t_peak = NaN;
p_av.av_peak = NaN;
p_av.av_peak_std = NaN;

p_av.peak_max = NaN;
p_av.peak_max_t = NaN;
p_av.peak_max_std = NaN;
p_av.peak_max_t_std = NaN;

p_av.peak_min = NaN;
p_av.peak_min_t = NaN;
p_av.peak_min_std = NaN;

p_av.peak_basel = NaN;
p_av.peak_basel_std = NaN;

p_av.peak_amp = NaN;
p_av.peak_amp_std = NaN;

p_av.av_peak_width = NaN;
p_av.av_peak_width_std = NaN;

p_av.peak_area_contr = NaN;
p_av.peak_area_contr_std = NaN;

p_av.peak_area_rel = NaN;
p_av.peak_area_rel_std = NaN;

p_av.peak_area_tot = NaN;
p_av.peak_area_tot_std = NaN;

p_av.d_t_peak = NaN;
p_av.d_av_peak = NaN;
p_av.d_av_peak_std = NaN;

p_av.d_peak_max = NaN;
p_av.d_peak_max_t = NaN;
p_av.d_peak_max_std = NaN;

p_av.d_peak_min = NaN;
p_av.d_peak_min_t = NaN;
p_av.d_peak_min_std = NaN;


%check for column vector inputs
if isrow(s.signal_t)
    s.signal_t = transpose(s.signal_t);
end
if isrow(signal)
    signal = transpose(signal);
end

%Prepare curve vector
signal(isnan(signal))=0;%change NaN to 0

% %Plot curve
% figure(1)
% f1p1=plot(s.signal_t,signal);
% hold on 

%%
%Filtering
%================================

%Compute curve - average for comparison with fft filter below
%curve = curve - mean(curve);

%Use fft to filter signalwith a bandpass filter
df = fs/size(signal,1);
f_range = ((-fs/2:df:fs/2-df)+(df-mod(size(signal,1),2)*df/2))';
bp_filter = ((1/3 < abs(f_range)) & (abs(f_range) < 10));

fft_signal = fftshift(fft(signal-mean(signal)));
fft_signal = bp_filter.*fft_signal;
%Transform curve back to time domain
s.fsignal = real(ifft(ifftshift(fft_signal)));

% %Plot filtered curve
% hold on
% fip2=plot(s.signal_t,s.fsignal);
% hold on


%%
%Autocorrelation of curve with itself
%================================

[s.autocorr_signal, s.autocorr_lags] = xcorr(s.fsignal, 'coeff');

%Extract positive part of autocorrelation signal
pos_el = find(s.autocorr_lags>=0);
s.autocorr_lags = s.autocorr_lags(pos_el);
s.autocorr_signal = s.autocorr_signal(pos_el);

% %Plot autocorrelation signal
% figure(2)
% plot(s.autocorr_lags/fs,s.autocorr_signal)
% hold on 

%Find peaks of autocorrelation signal, using a specific peak prominence and height
[s.autocorr_peaks,s.autocorr_peaks_lags,w] = findpeaks(s.autocorr_signal,'MinPeakDistance',60/220/fs,'MinPeakWidth',fs/8,'MinPeakProminence',0.2);%,'MinPeakHeight',0.1);%'SortStr','descend','MinPeakDistance',0.25*fs

%if no autocorrelation peak is detected, output message and output
%arbitrary peak of height 0.1, and lad and width of 1 second = fs frames 
if isempty(s.autocorr_peaks)
    s.comment = 'No correlation peak detected'; 
    s.autocorr_peaks = 0.1;
    s.autocorr_peaks_lags = fs;
    w = fs;
elseif size(s.autocorr_peaks,1) == 1
    s.comment = 'Only 1 correlation peak detected';
end

%Find the average peak distance and divide by sampling frequency to get the
%time between peaks
s.av_peak_spac = mean(diff([0; s.autocorr_peaks_lags]))/fs;% Measure of beating frequency
% if isnan(s.av_peak_spac)
%     s.comment = 'Peak spacing is NaN';
% end
s.av_peak_spac_std = std(diff([0; s.autocorr_peaks_lags]))/fs;% Measure of the arrythmia 
%Calculate the average peak width
s.av_peak_w = mean(w)/fs;% Measure of the peak duration
s.av_peak_w_std = std(w)/fs;% Measure of the variability in peak duration
%Calculate the peak frequency
s.f_main_peak = 1/s.av_peak_spac;
s.f_main_peak_std = s.f_main_peak*sqrt((s.av_peak_spac_std/s.av_peak_spac)^2);

% %Plot the position of the average peak in autocorrelation signal
% hold on
% pks = plot(s.autocorr_lags(s.autocorr_peaks_lags(1))/fs,s.autocorr_peaks(1)+0.05,'vk');
% hold off
% legend('Signal auto-correlation','Average peak position')

%%
%Determine the width of the window framing a single peak
%================================
s.ref_peak_l = floor(s.av_peak_spac*fs);

%Add an overlapping factor of 25% on each side of the peak
overlap = 1.5;
%Determine a moving window length and duration
s.peak_win_l = min(floor(size(s.signal_t,1)/2),floor(s.ref_peak_l*overlap));
peak_d = s.signal_t(s.peak_win_l);
%Make an index and time vector for the moving windows
peak_wins_ind = s.signal_t<=peak_d;
p_av.peak_wins_t = s.signal_t(peak_wins_ind);


%%
%Find most prominent peak of width peakwin_l in curve to use as reference
%peak
%================================
[s.peaks,s.peaks_lags,w,p] = findpeaks(s.fsignal,'MinPeakDistance',0.75*s.av_peak_spac*fs,'MinPeakProminence',1.5*rms(s.fsignal),'MaxPeakWidth',min(s.av_peak_w+4*s.av_peak_w_std,size(s.fsignal,1)/2)*fs);%max(2*fs, size(s.fsignal,2)/2));

%exit function if no prominent peak is found in the signal
if isempty(s.peaks)
    s.comment = [s.comment ': No prominent peak found in the signal'];
    return
end

%Restrict to full peaks only, i.e. exclude peaks at the beginning and end
%of the signal to avoid truncation
s.peaks = s.peaks(find((s.peaks_lags>s.peak_win_l/2) .* (s.peaks_lags<size(s.fsignal,1)-s.peak_win_l/2)));
s.peaks_lags = s.peaks_lags(find((s.peaks_lags>s.peak_win_l/2) .* (s.peaks_lags<size(s.fsignal,1)-s.peak_win_l/2)));
w = w(find((s.peaks_lags>s.peak_win_l/2) .* (s.peaks_lags<size(s.fsignal,1)-s.peak_win_l/2)));
p = p(find((s.peaks_lags>s.peak_win_l/2) .* (s.peaks_lags<size(s.fsignal,1)-s.peak_win_l/2)))';

%Check that there is a full peak to use as reference and if not find
%another peak with less strict criteria
if isempty(s.peaks)
    [s.peaks,s.peaks_lags,w,p] = findpeaks(s.fsignal(floor(s.peak_win_l/2):end-floor(s.peak_win_l/2)),'MinPeakDistance',0.75*s.av_peak_spac, 'MaxPeakWidth',fs,'SortStr','descend','NPeaks',1);
    s.peaks_lags = s.peaks_lags+floor(s.peak_win_l/2);
    s.comment = [s.comment ': Non prominent peak selected because no prominent peak detected'];
end

%second check to ensure one peak is selected, even if not really prominent
%(to be deleted if never used)
if isempty(s.peaks)
    [s.peaks,s.peaks_lags,w,p] = findpeaks(s.fsignal(floor(s.peak_win_l/2):end-floor(s.peak_win_l/2)),'MinPeakDistance',0.75*s.av_peak_spac,'SortStr','descend','NPeaks',1);
    s.peaks_lags = s.peaks_lags+floor(s.peak_win_l/2);
    s.comment = [s.comment 'Random peak selected because no prominent peak detected'];
end

% %Plot peaks
% figure(1)
% fip3=plot(s.signal_t(s.peaks_lags),s.peaks,'vk');
% hold on

%Find most prominent peak
mp_peak_num = find(p==max(p));
%Save peak height and peak lag in variable
mp_peak = s.peaks(mp_peak_num);
mp_peak_lg = s.peaks_lags(mp_peak_num);

%%
%Extract most prominent peak window from curve signal 
%================================
s.ref_peak = s.fsignal(mp_peak_lg-floor(s.peak_win_l/2)+1:mp_peak_lg+floor(s.peak_win_l/2));
s.ref_peak_lag = s.signal_t(mp_peak_lg-floor(s.peak_win_l/2)+1:mp_peak_lg+floor(s.peak_win_l/2));
% %Calculate the number of moving window that can be juxtaposed along the
% %signal length
% n_peak_wins = floor(size(s.signal_t,1)/s.ref_peak_l);

% %Plot the first moving window
% figure (1)
% fip4=plot(s.ref_peak_lag,s.ref_peak,'-og');
% legend([f1p1 fip2 fip3 fip4], {'Original signal', 'FFT low-pass filter and baseline correction','Detected peaks','Reference window'});


%%
%Pad the curve signal with mean*zeros in front and back 
%================================
%calculate mean of curve
mcurve = mean(s.fsignal);

%Pad curve with a full moving window length in front and back
%Add zeros in front
s.pd_signal = [ones(s.peak_win_l,1)*mcurve;s.fsignal;ones(s.peak_win_l,1)*mcurve];
s.pd_t = linspace(0,size(s.pd_signal,1),size(s.pd_signal,1))'/fs;

%%Plot padded signal 
%figure(3)
% plot(s.pd_t,s.pd_signal)
% hold on
% legend('Padded and filtered signal')

%%
%Cross-correlate the reference peak with the curve signal
%================================

%Cross-correlate reference window with signal
[s.x_curve_win,s.x_lags] = xcorr(s.pd_signal,s.ref_peak);
%Extract positive part of the cross-correlation signal
s.x_curve_win = s.x_curve_win(s.x_lags>=0);
s.x_curve_win = s.x_curve_win(1:size(s.fsignal,1));
s.x_lags = s.x_lags(s.x_lags>=0);
s.x_lags = s.x_lags(1:size(s.fsignal,1));

% %Plot the cross-correlated signal
% figure(4)
% plot((s.x_lags+s.peak_win_l/2+1)/fs,s.x_curve_win)

%Find correlation peaks
[s.xcorr_peaks,s.xcorr_peaks_lags,w,p] = findpeaks(s.x_curve_win,'MinPeakDistance',floor(s.peak_win_l/2),'MinPeakProminence',0.3*max(s.x_curve_win));
if isempty(s.xcorr_peaks)
    s.xcorr_peaks = s.x_curve_win(1);
    s.xcorr_peaks_lags = 1;
end

%Save the number of peaks found
p_av.n_peaks = size(s.xcorr_peaks,1);

%Compensate for the padding
s.pd_xcorr_peaks_lags = s.xcorr_peaks_lags+floor(s.peak_win_l/2);

% %Plot the peaks on the cross-correlated signal
% hold on
% plot(s.pd_xcorr_peaks_lags/fs,s.xcorr_peaks,'ok')
% hold on
% %Plot the padded curve, *1e-8 is a scaling factor for the plotting on same
% %axis
% plot(s.pd_t,s.pd_signal*1e-8)
% hold on
% legend('Cross-correlation of signal with reference peak','Detected peaks','Padded and filtered signal')


%%
%Extract the repeating windows
%================================

%Extract the repeating windows, setting the padding elements to NaN to
%neglect them
s.pd_signal(1:s.peak_win_l) = nan(s.peak_win_l,1);
s.pd_signal(end-s.peak_win_l+1:end) = nan(s.peak_win_l,1);
p_av.peaks = zeros(s.peak_win_l,p_av.n_peaks);
for i = 1:p_av.n_peaks
    p_av.peaks(:,i) = s.pd_signal(s.pd_xcorr_peaks_lags(i)-floor(s.peak_win_l/2)+1:s.pd_xcorr_peaks_lags(i)+ceil(s.peak_win_l/2));
end
%%
%Calculate the average peak based on the repeating peak shape
%================================

%Calculate the average peak and the standard deviation envelop 
p_av.av_peak = mean(p_av.peaks,2,'omitnan');
p_av.av_peak_std = std(p_av.peaks,0,2,'omitnan');

%Find minimum and remove y-offset
p_av.filtyoffs = min(p_av.av_peak);
p_av.av_peak = p_av.av_peak - p_av.filtyoffs;

%Get time vector for peaks average
p_av.t_peak = p_av.peak_wins_t(1:s.peak_win_l);

% %Plot all repeating signal windows overlapped
% figure(5)
% f5p1 = plot(p_av.t_peak,p_av.peaks);
% hold on
% %Plot the average peak
% f5p2 = plot(p_av.t_peak,p_av.av_peak,'-*k');
% hold on
% %Plot the std envelop
% f5p3=plot(p_av.t_peak,p_av.av_peak-p_av.av_peak_std,':k');
% hold on
% f5p4=plot(p_av.t_peak,p_av.av_peak+p_av.av_peak_std,':k');
% legend([f5p2 f5p3],{'Average peak signal','Standard deviation envelop'})

%================================

% %================================
% %Control code to see how well aligned the peaks are using cross-correlation
% %of the extracted peaks. 
% %NOTE: A second round of alignement and
% %y-alignement of the peak maximum could also be performed as part of this step as well
% %================================
% 
% %Take the cross-correlation of the extracted repeating windows
% [s.x_curve_win,s.x_lags] = xcorr(p_av.peaks,'coeff');
% %Extract the cross correlation of the first windows with the others
% s.x_curve_win = s.x_curve_win(:,1:end);
% 
% %Plot the cross-correlation signals
% figure(6)
% plot(s.x_lags/fs,s.x_curve_win)
% hold on
% legend('Cross-correlation of the extracted peaks')
% %================================

%Find the width of each peaks and get the statistics
%=================================
width = nan(size(p_av.peaks,2),1);
for i =1:size(p_av.peaks,2) 
    test = floor(0.25*s.ref_peak_l);
    [~,~,width_i,~] = findpeaks(p_av.peaks(floor(0.25*s.ref_peak_l):end-floor(0.25*s.ref_peak_l),i),'MinPeakProminence',0.5*(max(p_av.av_peak)-min(p_av.av_peak)),'SortStr','descend', 'NPeaks',1);
    if ~isempty(width_i)
        width(i) = width_i;
    end
end
p_av.av_peak_width = mean(width,'omitnan')/fs;
p_av.av_peak_width_std = std(width,'omitnan')/fs;

%%
%Find relax and contracted point in the average peak
%================================
%Find the max peak

%end_limit = size(p_av.av_peak,1)-floor(0.25*s.ref_peak_l)

[p_av.peak_max,p_av.peak_max_t,w,p] = findpeaks(p_av.av_peak(floor(0.25*s.ref_peak_l):end-floor(0.25*s.ref_peak_l)),'MinPeakProminence',0.5*(max(p_av.av_peak)-min(p_av.av_peak)),'SortStr','descend', 'NPeaks',1);%,'MinPeakDistance',s.ref_peak_l/2
if isempty(p_av.peak_max)
    [p_av.peak_max,p_av.peak_max_t,w,p] = findpeaks(p_av.av_peak(floor(0.25*s.ref_peak_l):end-floor(0.25*s.ref_peak_l)),'SortStr','descend', 'NPeaks',1);%'MinPeakDistance',s.ref_peak_l/2,
end
if isempty(p_av.peak_max)
    [p_av.peak_max,p_av.peak_max_t] = max(p_av.av_peak(floor(0.25*s.ref_peak_l):end-floor(0.25*s.ref_peak_l)));
end
p_av.peak_max_t = p_av.peak_max_t+floor(0.25*s.ref_peak_l)-1;
p_av.peak_max_t = p_av.peak_max_t(1);
p_av.peak_max = p_av.peak_max(1);
p_av.peak_max_std = p_av.av_peak_std(p_av.peak_max_t);

%find the stadard deviation along the x-axis
%[value, index] = min(abs(p_av.av_peak(1:p_av.peak_max_t)+p_av.av_peak_std(1:p_av.peak_max_t) - p_av.peak_max));
%p_av.peak_max_t_std = p_av.peak_max_t-index;

%Find the min (relax) point
%on the contraction side of the peak
[p_av.peak_min,p_av.peak_min_t] = findpeaks([-p_av.av_peak(1)*1.01; -p_av.av_peak(1:max(3,p_av.peak_max_t))],'SortStr','descend','NPeaks',1);%'MinPeakDistance',s.ref_peak_l/2,
p_av.peak_min_t = p_av.peak_min_t-1;
%on the relaxation side of the peak
[p_av.peak_min_2,p_av.peak_min_t_2] = findpeaks(-p_av.av_peak(min(p_av.peak_max_t,end-3):end),'SortStr','descend','NPeaks',1);
%concatenate peak min in single array
p_av.peak_min_t = [p_av.peak_min_t, p_av.peak_min_t_2+p_av.peak_max_t-1];
p_av.peak_min = [p_av.peak_min,p_av.peak_min_2];

%Check the peak min
if size(p_av.peak_min,2)==1
    if p_av.peak_min_t < p_av.peak_max_t
        p_av.peak_min = [p_av.peak_min(1), -p_av.av_peak(end)];
        p_av.peak_min_t = [p_av.peak_min_t, size(p_av.av_peak,2)];
    else
        p_av.peak_min = [-p_av.av_peak(1), p_av.peak_min(end)];
        p_av.peak_min_t = [1, p_av.peak_min_t];
    end
end
if isempty(p_av.peak_min)
    p_av.peak_min = [-p_av.av_peak(1) -p_av.av_peak(end)];
    p_av.peak_min_t = [1 size(p_av.av_peak,1)];
end
if p_av.peak_min_t(2) < p_av.peak_max_t
    p_av.peak_min(2) = -p_av.av_peak(end);
    p_av.peak_min_t(2) = size(p_av.av_peak,1);
end
%take negative again
p_av.peak_min = -p_av.peak_min;
%p_av.peak_min_t = p_av.peak_min_t(find(p_av.peak_min == min(p_av.peak_min)));
p_av.peak_min_std = sqrt(mean(p_av.av_peak_std(p_av.peak_min_t).^2));
p_av.peak_basel = min(p_av.peak_min);
p_av.peak_basel_std = p_av.av_peak_std(min(p_av.peak_min_t));

%Calculate the peak amplitude
p_av.peak_amp = mean(p_av.peak_max-p_av.peak_basel,'omitnan');
p_av.peak_amp_std = sqrt(p_av.peak_max_std^2+p_av.peak_basel_std^2);
%%Compare with the peak prominence
%peak_prom = max(p);

%Calculate the integral under the curve
p_av.peak_area_contr = sum(p_av.av_peak(min(p_av.peak_min_t):p_av.peak_max_t)*(p_av.peak_wins_t(2)-p_av.peak_wins_t(1)));
p_av.peak_area_contr_std = sum((p_av.av_peak(min(p_av.peak_min_t):p_av.peak_max_t)+p_av.av_peak_std(min(p_av.peak_min_t):p_av.peak_max_t))*(p_av.peak_wins_t(2)-p_av.peak_wins_t(1)))-p_av.peak_area_contr;
p_av.peak_area_rel = sum(p_av.av_peak(p_av.peak_max_t:max(p_av.peak_min_t))*(p_av.peak_wins_t(2)-p_av.peak_wins_t(1)));
p_av.peak_area_rel_std = sum((p_av.av_peak(p_av.peak_max_t:max(p_av.peak_min_t))+p_av.av_peak_std(p_av.peak_max_t:max(p_av.peak_min_t)))*(p_av.peak_wins_t(2)-p_av.peak_wins_t(1)))-p_av.peak_area_contr;
p_av.peak_area_tot = p_av.peak_area_contr + p_av.peak_area_rel;
p_av.peak_area_tot_std = sqrt(p_av.peak_area_contr_std^2+p_av.peak_area_rel_std^2);
%%
%Take the derivative
%================================
if incl_diff
    
    p_av.d_t_peak  = diff(p_av.peak_wins_t,1);
    p_av.d_peaks = diff(p_av.peaks,1)./p_av.d_t_peak(1);
    p_av.d_t_peak  = p_av.t_peak(1:end-1);
    
    %Calculate the average peak derivative and the standard deviation envelop 
    p_av.d_av_peak = mean(p_av.d_peaks,2,'omitnan');
    p_av.d_av_peak_std = std(p_av.d_peaks,0,2,'omitnan');
    
   
    
    %Find max point for the contracting speed
    [p_av.d_peak_max,p_av.d_peak_max_t] = findpeaks(p_av.d_av_peak(min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))),'MinPeakDistance',size(p_av.d_av_peak (min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))),1)/2,'SortStr','descend','NPeaks',1);
    if isempty(p_av.d_peak_max)
        [p_av.d_peak_max,p_av.d_peak_max_t] = max(p_av.d_av_peak (min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))));
    end
    p_av.d_peak_max = p_av.d_peak_max(1);
    p_av.d_peak_max_t = p_av.d_peak_max_t(1)+min(p_av.peak_min_t)-1;
    p_av.d_peak_max_std = p_av.d_av_peak_std(p_av.d_peak_max_t);
    
    %Find min points for the relaxing speed
    [p_av.d_peak_min,p_av.d_peak_min_t] = findpeaks(-p_av.d_av_peak (min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))),'MinPeakDistance',size(p_av.d_av_peak (min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))),1)/2,'SortStr','descend','NPeaks',1);%,'SortStr','descend');
    if isempty(p_av.d_peak_min)
        [p_av.d_peak_min,p_av.d_peak_min_t] = min(p_av.d_av_peak(min(p_av.peak_min_t):min(max(p_av.peak_min_t),size(p_av.d_av_peak,1))));
    end
    
    p_av.d_peak_min = -p_av.d_peak_min(1);
    p_av.d_peak_min_t = p_av.d_peak_min_t(1)+min(p_av.peak_min_t)-1;
    %p_av.d_peak_min = min(p_av.d_peak_min);
    p_av.d_peak_min_std = p_av.d_av_peak_std(p_av.d_peak_min_t);
end

%%
%Plot the average peak curve and the max and min point and the speed as the
%slope
%================================

% figure(7)
% f7p1=plot(p_av.peak_wins_t,p_av.av_peak,'LineWidth',2);
% ax7 = gca;
% hold on
% ax7.YLim = [1.1*p_av.d_peak_min 1.1*p_av.peak_max];
% hold on
% f7p2=plot(p_av.peak_max_t/fs,p_av.peak_max,'dk','MarkerSize',10);
% hold on
% f7p3=plot(p_av.peak_min_t/fs,p_av.peak_min,'sk','MarkerSize',10)';
% hold on
% 
% %Plot the std envelop
% f7p4=area(p_av.t_peak,p_av.av_peak+p_av.av_peak_std,min(p_av.av_peak-p_av.av_peak_std),'FaceColor',[0.8 0.8 0.8],'FaceAlpha',0.5,'EdgeColor','none');
% %f7p4=plot(p_av.t_peak,p_av.av_peak-p_av.av_peak_std,':','Color',f7p1.Color);
% hold on
% f7p5=area(p_av.t_peak,p_av.av_peak-p_av.av_peak_std,min(p_av.av_peak-p_av.av_peak_std),'FaceColor',[1 1 1],'FaceAlpha',1,'EdgeColor','none');
% hold on
% 
% %Plot the first derivative of the curve
% f7p6=plot(p_av.peak_wins_t(1:end-1),p_av.d_av_peak ,'--');
% hold on
% %f7p5=plot(p_av.d_peak_max_t/fs,p_av.d_peak_max,'vk','MarkerSize',10);
% %hold on
% %f7p6=plot(p_av.d_peak_min_t/fs,p_av.d_peak_min,'^k','MarkerSize',10);
% %hold on
% %Display value of integral under the curve
% ar1 = area(p_av.peak_wins_t(min(p_av.peak_min_t):p_av.peak_max_t)',p_av.av_peak(min(p_av.peak_min_t):p_av.peak_max_t),p_av.peak_basel,'FaceColor',[255,74,0]/255,'FaceAlpha',0.5,'EdgeColor','none');
% hold on
% ar2 = area(p_av.peak_wins_t(p_av.peak_max_t:max(p_av.peak_min_t))',p_av.av_peak(p_av.peak_max_t:max(p_av.peak_min_t)),p_av.peak_basel,'FaceColor',[64,166,41]/256,'FaceAlpha',0.5,'EdgeColor','none');
% hold on
% annotation('textbox', [max(ar1.XData)/max(ax7.XLim)-0.15,(p_av.peak_basel-min(ax7.YLim))/(max(ax7.YLim)-min(ax7.YLim)),0.15,0.05],'String',p_av.peak_area_contr)
% hold on
% annotation('textbox', [min(ar2.XData)/max(ax7.XLim),(p_av.peak_basel-min(ax7.YLim))/(max(ax7.YLim)-min(ax7.YLim)),0.15,0.05],'String',p_av.peak_area_rel)
% hold on 
% annotation('textbox', [max(ar1.XData)/max(ax7.XLim)-0.125,(p_av.peak_basel-min(ax7.YLim))/(max(ax7.YLim)-min(ax7.YLim))-0.05,0.25,0.05],'String',['Total Area = ', num2str(p_av.peak_area_tot)])
% 
% 
% %% Plot the derivative
% f7p7=plot(p_av.d_peak_max_t/fs,p_av.av_peak(p_av.d_peak_max_t),'^k','MarkerSize',10);
% hold on
% f7p8=plot(p_av.d_peak_min_t/fs,p_av.av_peak(p_av.d_peak_min_t),'vk','MarkerSize',10);
% hold on
% f7p9=plot([p_av.peak_max_t-floor(floor(s.peak_win_l/4)):p_av.peak_max_t+floor(s.peak_win_l/4)]/fs,p_av.peak_max*ones(1,(p_av.peak_max_t+floor(s.peak_win_l/4))-(p_av.peak_max_t-floor(floor(s.peak_win_l/4)))+1),':k');
% hold on
% f7p10=plot(p_av.peak_wins_t,p_av.peak_basel*ones(1,s.peak_win_l),':k');
% hold on
% f7p11=plot([p_av.d_peak_max_t-floor(s.peak_win_l/4):p_av.d_peak_max_t+floor(s.peak_win_l/4)]/fs,p_av.d_peak_max*[-floor(s.peak_win_l/4):+floor(s.peak_win_l/4)]+p_av.av_peak(p_av.d_peak_max_t),':k');
% hold on
% f7p12=plot([p_av.d_peak_min_t-floor(s.peak_win_l/4):p_av.d_peak_min_t+floor(s.peak_win_l/4)]/fs,p_av.d_peak_min*[-floor(s.peak_win_l/4):+floor(s.peak_win_l/4)]+p_av.av_peak(p_av.d_peak_min_t),':k');
% hold on
% 
% legend([f7p1 f7p2 f7p3(1) f7p4 f7p6 f7p7 f7p8],{'Average peak','Peak maximum = Contracted state','Peak minimum = Relaxed state','Standard deviation envelop','1st derivative','1st deriv. maximum','1st deriv. minimum'});
% 
% legend([f5p2 f5p3],{})
% 
% %================================
% 
