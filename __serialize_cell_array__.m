function ret = __serialize_cell_array__ (in)
  if(ndims (in) == 2)
    ret = __serialize_2d_cell__ (in);
  else
    s = size (in);
    n = ndims (in);
    ret = sprintf ("cat(%i,", n);
    for (k = 1:size (in, n))
      idx.type = "()";
      idx.subs = cell(n,1);
      idx.subs(:) = ":";
      idx.subs(n) = k;
      tmp = subsref (in, idx);
      ret = [ret, __serialize_2d_cell__(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      endif
    endfor
  endif
endfunction
