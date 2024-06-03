function x = acf(f, window, t, lag)

  x = ceil(f(t:t+window) * (f(lag + t: lag + t + window))');
endfunction
