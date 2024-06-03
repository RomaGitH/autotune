function x = acf(f, window, t, lag)

  x = f(t:t+window) * (f(lag + t: lag + t + window))';
endfunction
