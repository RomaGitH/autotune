## Algoritmo de deteccion de frecuencia fundamental YIN
## paper: http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf

function f0  = yin(w, fm)

## Calcula la enegía para detectar si la ventana esta compuesta de silencio

  e = sum(w.^2);
  if(e < 0.05)
      f0 = 0;
  else
    #Logica de emplear dos ventanas.
    #no se si mejora.
##    if(nargin == 4 && e > 1)
##      e = sum(prev_w.^2);
##      if e > 0.05
##        acf_fft_values = acf_fft(w,prev_w);
##      else
        acf_fft_values = acf_fft(w);
##      endif
##    else
##      acf_fft_values = acf_fft(w);
##    endif
    #busco la pos del max ignorando las primeras 80 samples.
    [~,idx_max] = max(acf_fft_values(80:end));
    sample = idx_max - 1 + 80;  #sumo 80hz para obtener posicion real del sample
    f0 = fm/sample; #retorna la f0

   endif
endfunction
