function x = acf_fft(w,prev_w)
    if (nargin==2)
      [x,~] = xcorr([prev_w,w],2048);
      x = x(2048:3071);
    else
       [x,~] = xcorr(w,1024);
        x = x(1024:end);
    endif
end
