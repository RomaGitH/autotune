function [dpitch, cpitch, ACF_window] = pitch(left, center, right, fm, scale, old_pitch)

 l = length(left);
 % Genera ventana de 2*L con parte de las tres.
 ACF_window = [left((l/2)+1:end) center right(1:l/2)]; %size = 2*L
 if(left.^2<0.4) dpitch = 0; cpitch=0; endif;
 if(right.^2<0.4) dpitch = 0; cpitch=0; endif;
 % Calcula el pitch y lo corrige.

 dpitch = yin(ACF_window, fm, old_pitch);
 cpitch = pitchCorrection(dpitch) * scale; %multiplica por la scala.

endfunction
