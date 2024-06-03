function x  = yin(f,window,t,fm,min_lag,max_lag, tresh,db)

  if(sum(f(t:t+window).^2) < 0.5)
      x = 0;
  else

    tresh = 0.1;
    m = [];
    for i=0:max_lag
       m = [m df(f,window,t,i+1)];
     endfor

    cmndf_values = [];
    for i=min_lag:max_lag
      cmndf_values = [cmndf_values cmndf(f,window,t,i,m)];
    endfor


    sample = -1;
    n = length(cmndf_values);
    for i=1:n
      if(cmndf_values(i)<tresh)
        sample = i + min_lag;
        break;
      endif
    endfor

    if(sample == -1)
      [~,idx_min] = min(cmndf_values);
      sample = idx_min - 1 + min_lag;
    endif

    x = fm/sample;

   endif
endfunction
