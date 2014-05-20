function ret = __serialize_2d_cell__(in)
  assert (ndims (in) == 2);
  if (isempty (in))
    ret = '{}';
  else
    ret = '{';
    for (r = 1:rows (in))
      for (c = 1:columns (in))
        tmp = in{r,c};
        if (iscell (tmp))
          ret = [ret __serialize_cell_array__(tmp) ','];
        else
          ret = [ret serialize(tmp) ','];
        endif
      endfor
      ret(end) = ';';
    endfor
    ret(end) = '}';
  endif
endfunction
