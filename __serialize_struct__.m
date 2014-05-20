function ret = __serialize_struct__(in)
  assert (isstruct(in));
  ret = 'struct(';
  for [val, key] = in
    #iscell(val)
    if (iscell(val) && isscalar(in))
      tmp = ['{' serialize(val) '}'];
    else
      tmp = serialize(val);
    endif
    ret = [ ret '"' key '",' tmp ','];
  endfor
  ret = [ ret(1:end-1) ')'];
endfunction
