function r = acf(signal, window, t, lag)
  % Apply the window to the signal
##  windowed_signal = signal .* window;

  % Calculate the mean of the windowed signal
  mean_signal = mean(signal);

  % Subtract the mean from the windowed signal
  signal = signal - mean_signal;

  % Calculate the autocorrelation for the given lag
  n = length(signal);
  r = signal(t:t+window) * (signal(t+lag:lag+t+window)./(n-lag))';
endfunction
