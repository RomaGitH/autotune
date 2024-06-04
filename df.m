## Difference function
## Paso 2.
function x = df(f, window, t, lag)
   x = acf(f,window,t,0) + acf(f,window,t+lag,0) - (2*acf(f,window,t,lag));

endfunction
