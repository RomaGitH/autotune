function [x,y] = seno(ti, tf, fm, fs, phs)
  tm = 1/fm;
  t = ti:tm:tf-tm;
  x=2*pi*fs*t + phs;
  y=sin(x);
endfunction
##TESTING
