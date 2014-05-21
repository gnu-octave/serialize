function ret = serialize(obj)
  %% TODO:
  %% * add documentation
  %% * Have a look at all functions with malicious code injection in mind.
  if (ismatrix (obj))
    if (ischar (obj))
      ret = ['char(', serialize_matrix(uint8(obj)), ')'];
    else
      ret = serialize_matrix(obj);
    endif
  elseif (iscell (obj))
    ret = serialize_cell_array(obj);
  elseif (isstruct (obj))
    ret = serialize_struct(obj);
  else
    error('serialize for class "%s", type "%s" isn''t supported yet', class (obj), typeinfo (obj));
  endif
end

function ret = serialize_2d_cell(in)
  assert (ndims (in) == 2);
  if (isempty (in))
    ret = '{}';
  else
    ret = '{';
    for (r = 1:size (in,1))
      for (c = 1:size (in,2))
        tmp = in{r,c};
        if (iscell (tmp))
          ret = [ret serialize_cell_array(tmp) ','];
        else
          ret = [ret serialize(tmp) ','];
        endif
      endfor
      ret(end) = ';';
    endfor
    ret(end) = '}';
  endif
end

function ret = serialize_cell_array (in)
  if(ndims (in) == 2)
    ret = serialize_2d_cell (in);
  else
    s = size (in);
    n = ndims (in);
    ret = sprintf ('cat(%i,', n);
    for (k = 1:size (in, n))
      idx.type = '()';
      idx.subs = cell(n,1);
      idx.subs(:) = ':';
      idx.subs(n) = k;
      tmp = subsref (in, idx);
      ret = [ret, serialize_2d_cell(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      endif
    endfor
  endif
end

function ret = serialize_matrix(m)
  if (ndims (m) == 2)
    ret = mat2str (m);
  else
    s = size (m);
    n = ndims (m);
    ret = sprintf ('cat(%i,', n);
    for (k = 1:size (m, n))
      idx.type = '()';
      idx.subs = cell(n,1);
      idx.subs(:) = ':';
      idx.subs(n) = k;
      tmp = subsref (m, idx);
      ret = [ret, serialize_matrix(tmp)];
      if (k < s(n))
        ret = [ret, ','];
      else
        ret = [ret, ')'];
      endif
    endfor
  endif
end

function ret = serialize_struct(in)
  assert (isstruct(in));
  ret = 'struct(';
  for [val, key] = in
    %iscell(val)
    if (iscell(val) && isscalar(in))
      tmp = ['{' serialize(val) '}'];
    else
      tmp = serialize(val);
    endif
    ret = [ ret '''' key ''',' tmp ','];
  endfor
  ret = [ ret(1:end-1) ')'];
end
