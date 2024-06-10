function [dpitch, cpitch, ACF_window] = pitch(left, center, right, fm, scale, old_pitch, bad_singer)


 l = length(left);
 % Genera ventana de 2*L con parte de las tres.
 ACF_window = [left((l/2)+1:end) center right(1:l/2)]; %size = 2*L
 % Calcula el pitch y lo corrige.
 dpitch = yin(ACF_window, fm);
 cpitch = pitchCorrection(dpitch) * scale; %multiplica por la scala.

  %No mejora mucho==============================================
 if(bad_singer)

    if((cpitch > sum(old_pitch)) && (old_pitch != zeros(1,3)))
      cpitch = old_pitch(end);
    endif
   if(cpitch > 250)
    cpitch = old_pitch(end);
   endif

##   cpitch = pitchCorrectionX(cpitch) * scale;
##
##  if((cpitch > old_pitch(end) + 50) && (old_pitch(end) != 0))
##    cpitch = old_pitch(end);
##   endif
##
##   if(cpitch > 1000)
##    cpitch = old_pitch(end);
##   endif

   if(dpitch < 80 && dpitch > 0)
    cpitch = old_pitch(end);
   endif
##   cpitch =440;

 endif

endfunction
