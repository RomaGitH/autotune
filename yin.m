function [x, matrix,zero]  = yin(f,window,t,fm,min_lag,max_lag, m, no_matrix)

## Algoritmo de deteccion de frecuencia fundamental YIN
## paper: http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf

  ## Calcula la enegía para detectar si la ventana esta compuesta de silencio
  matrix = zeros(1024,1024);
  if(sum(f(t:t+window).^2) < 0.5)
      x = 0;
      zero = 1;
  else
    zero = 0;
    ## Precalculo del divisor de la normalizacion para optimizar.
    ## Se normaliza dividiendo por la media.
    ## Paso 3 paper.

    if(no_matrix)
      for i=1:1024
         m(:,i) = df(f,window,t,i);
      endfor
    else
      for i=513:1024
         m(:,i) = df(f,window,t,i);
      endfor
    endif
    matrix(:,1:512) = m(:,513:end);

    ## Calcula todas las cmnd(autocorrelaciones) entre en rango de lag definido.
    cmndf_values = []; #inicializo el vector las cmnd's.
    for lag=min_lag:max_lag
      cmndf_values = [cmndf_values cmndf(f,window,t,lag,m)];
    endfor

    ## Absolute Treshold.
    ## Reduce el error.
    ## Paso 4.
    ## sample es la posicion de la minima diferencia.
    sample = -1; # sample inicializado en pos no valida.
    n = length(cmndf_values);
    tresh = 0.1; # defino treshhold.
    for i=1:n
      ##Si un valor es menor al tresh entonces se asigna el sample.
      if(cmndf_values(i)<tresh)
        sample = i-1 + min_lag; #sumo el lag minimo para obtener la pos real.
        break;
      endif
    endfor

    ## Si todos los valores superan el treshhold
    if(sample == -1)
      [~,idx_min] = min(cmndf_values); #busco la pos del minimo;
      sample = idx_min - 1 + min_lag;  #idem
    endif

    x = fm/sample; #retorna la f0

   endif
endfunction
