function [dpitch, cpitch] = pitch(left, center, right, fm, scale)

##  left_energy = sum(left.^2); %Oldest window
##  center_energy = sum(center.^2); %Second oldest
##  right_energy = sum(right.^2); %Newest... u(0.0)u
##
##  total_energy = left_energy+center_energy+right_energy;
##  if (total_energy < 0.2)
##    dpitch = 0; %Silence -> no signal;
##    cpitch = 0;
##    return;
##  endif
##
##  if(center_energy < 0.05)
##    dpitch = 0;
##    cpitch = 0; %center pitch = 0 -> output = 0;
##    return;
##  endif
##
##  if(right_energy < 0.05)
##    dpitch = 0;
##    cpitch = 0; %newest pitch = 0 -> output = 0;
##    return;
##  endif

 ACF_window = [left(513:end) center right(1:512)]; %size = 2*L
 dpitch = yin(ACF_window, fm);
 cpitch = dpitch;
## cpitch = pitchCorrection(dpitch)*scale;
## cpitch = pitchCorrection(dpitch)*scale;


##  left_dpitch = yin(left, fm);
##  center_dpitch = yin(center, fm);
##  right_dpitch = yin(righ, fm);
##
##  left_cpitch = pitchCorrection(left);
##  center_cpitch = pitchCorrection(center);
##  right_cpitch = pitchCorrection(righ);
##
##  dpitch = center_dpitch;
##
##
##  if ((left_cpitch == center_cpitch) && (center_cpitch== right_cpitch))
##    cpitch = center_cpitch;
##    return;
##  endif
##
##  if (center_cpitch==right_cpitch)
##    c_pitch = center_cpitch;
##    return;
##  endif
##
##  if(center_cpitch < abs(right_cpitch-100))
##    c_pitch = right_cpitch;
##    return;
##  endif
##
##  c_pitch = center_cpitch;


endfunction
