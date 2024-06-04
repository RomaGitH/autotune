function x = acf_fft(window)
  if isrow(window)
    window = window';
  endif

  window_fft = fft([window; zeros(1024,1)]); % zero pad and FFT
  x = ifft(window_fft.*conj(window_fft)); % abs()^2 and IFFT
  % circulate to get the peak in the middle and drop one
  % excess zero to get to 2*n-1 samples
  x = [x(1024+2:end); x(1:1024)];

end
