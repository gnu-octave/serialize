function ret = serialize(obj)
  ## TODO:
  ## * add documentation
  ## * Have a look at all functions with malicious code injection in mind.
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

%!function check_it(in)
%!  out = eval (serialize (in));
%!  assert (out, in, 16*eps);
%!endfunction

## [complex] scalars
%!test check_it (uint8(5))
%!test check_it (uint8(5))
%!test check_it (1.23456)
%!test check_it (1.23456i)
%!test check_it (-1.23456j)

## Inf, NA, NaN
%!test check_it ([1 2 inf NA NaN])

## 2D matrix
%!test check_it ([1,2;3,4])
%!test check_it ([1,2*pi;3,4.12i])

## static 3D
%!test
%! a = zeros (2, 3, 2);
%! a(:,:,1) = [1, 3, 5; 2, 4, 6];
%! a(:,:,2) = [7, 9, 11; 8, 10, 12];
%! b = serialize (a);
%! assert(eval(b), a, 16*eps);

## random >2D matrix
%!test check_it (rand(2,3,4));                 ## random 3D
%!test check_it (rand (2,3,4,5));              ## random 4D
%!test check_it (randi (3e4,2,3,4,5,"int16")); ## random int16 4D
%!test check_it (rand (2,3,4,5,2));            ## random 5D

## strings
%!test check_it ("huhu");
%!test check_it ("hello world\nsecond line");
%!test check_it ('hello world\nstill first line');

## cells
%!test check_it ({})
%!test check_it ({3, "hello", pi, i})
%!test check_it ({3, "octave", pi, i}.')
%!test check_it ({3.1, "world";3, 2+i})
%!test check_it ({{pi, 5}, "world";{5, {}, 2+i}, 6})
%!test
%! tmp = cell(3,2,2);
%! tmp(1,:,:) = {3.1, "world";3, 2+i};
%! check_it (tmp)

## scalar structs
%!test check_it (struct ("foo",1))
%!test check_it (struct ("foo",1,"bar","hello"))
%!test check_it (struct("foo", {3, 4, 5}))

%!test
%! g.y = {"hello", "world"};
%! tmp = serialize(g);
%! assert(eval(tmp), g, 16*eps)

## empty scalar struct
%!test check_it (struct ("foo", {}))
%!test check_it (struct ("foo", []))

## struct array
%!test
%! x(1).a = "string1";
%! x(2).a = "string2";
%! x(1).b = 1;
%! x(2).b = 2;
%! assert (eval(serialize(x)), x, 16*eps)

## 2d struct array
%!test
%! y(1,1).a = "huhu";
%! y(1,2).b = pi;
%! y(2,1).a = "hello";
%! assert (eval(serialize(y)), y, 16*eps)

%!test check_it (struct("foo", {{"huhu", "haha"}}))
%!test check_it (struct("foo", {{3,4,5}}))
%!test check_it (struct("foo", {1, 2}, "bar", {{1,2},{3,4}}))
%!test check_it (struct("foo", {{1,2;10,11},{3;4;5}}))
