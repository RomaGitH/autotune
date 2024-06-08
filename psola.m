function output = psola(win, dpitch, cpitch, fm)

  if (cpitch == 0)
    output = zeros(1,1024);
    return;
  endif


  dpp = floor((1/dpitch)* fm);
  cpp = floor((1/cpitch)* fm);
  overlap = 64;
##  h = hanning(1024);
##  win = win.*h;
  output = [];
  new = zeros(1,cpp);
  i = 0;
  while (i*dpp+cpp < 1024)
    if(i == 0)
      new = zeros(1,cpp);
      new = win(i*dpp+1:i*dpp+cpp);
      output = [output new];

    else
      new = zeros(1,cpp+overlap);
      new = win(i*dpp+1-overlap:i*dpp+cpp);
      output = [output zeros(1,cpp)];
      output(i*cpp-overlap+1:end) += new;
    endif

    i += 1;
  endwhile

endfunction
