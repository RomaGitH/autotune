function x = cmndf(f, window, t, lag,m)
   if lag == 0
     x = 1;
   endif

   x = df(f,window,t,lag) / (sum(m(1:lag) *(1/lag)));
endfunction
