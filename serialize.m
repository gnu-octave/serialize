function ret = serialize(obj)
  %% TODO:
  %% * add documentation
  %% * Have a look at all functions with malicious code injection in mind.
  if (ismatrix (obj))
    if (ischar (obj))
      ret = ["char(", __serialize_matrix__(uint8(obj)), ")"];
    else
      ret = __serialize_matrix__(obj);
    endif
  elseif (iscell (obj))
    ret = __serialize_cell_array__(obj);
  elseif (isstruct (obj))
    ret = __serialize_struct__(obj);
  else
    error('serialize for class "%s", type "%s" isn''t supported yet', class (obj), typeinfo (obj));
  endif
endfunction

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
function ret = __serialize_struct__(in)
  assert (isstruct(in));
  ret = 'struct(';
  for [val, key] = in
    %iscell(val)
    if (iscell(val) && isscalar(in))
      tmp = ['{' serialize(val) '}'];
    else
      tmp = serialize(val);
    endif
    ret = [ ret '"' key '",' tmp ','];
  endfor
  ret = [ ret(1:end-1) ')'];
endfunction
