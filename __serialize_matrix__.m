function ret = __serialize_matrix__(m)
  if (ndims (m) == 2)
    ret = mat2str (m);
  else
    s = size (m);
    n = ndims (m);
    ret = sprintf ("cat(%i,", n);
    for (k = 1:size (m, n))
      idx.type = "()";
      idx.subs = cell(n,1);
      idx.subs(:) = ":";
      idx.subs(n) = k;
      tmp = subsref (m, idx);
      ret = [ret, __serialize_matrix__(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      endif
    endfor
  endif
endfunction
