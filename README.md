serialize
=========

Serialization function for built-in [GNU Octave data types](http://www.gnu.org/software/octave/doc/interpreter/Built_002din-Data-Types.html#Built_002din-Data-Types).

With this function you can get a human-readable string from an octave object which can be retrieved by using "eval". The intended purpose is to serialize objects for transmission over byte-stream channels or for storage in databases while perserving the readability by humans (in contrast to the usage of typecast for example).

The principle is as with JSON: eval(serialize(data)) == data

Most built-in GNU Octave data types like numeric objects (real, complex and integer scalars and matrices),
strings, data structures, structure arrays and cell arrays are supported.

```
octave:1> x(1).a = pi;
octave:2> x(2).a = [1 2 3];
octave:3> x(1).b = 1;
octave:4> x(2).b = {3,4, randi(10,3,3)};
octave:5> 
octave:5> s = serialize(x)
s = struct("a",{3.14159265358979,[1 2 3]},"b",{1,{3,4,[7 1 8;4 2 4;4 9 5]}})
octave:6> x2 = eval(s);
octave:7> assert(x,x2, 16 * eps)
```

Bugs
----
Zarro Boogs Found

Missing or incomplete
---------------------
Sparse matrices are converted to a full storage matrix before serialization:

```
octave:1> a=zeros(3,3);
octave:2> a(randi(9,4,1))=rand(4,1)
a =

   0.93699   0.00000   0.98636
   0.00000   0.00000   0.22614
   0.00000   0.00000   0.16638

octave:3> serialize(a)
ans = [0.936989854208168 0 0.986359461519538;0 0 0.226137740875076;0 0 0.166379880758295]
```

TODO
----
Have a look at all functions with malicious code injection in mind.

License
-------
GPLv3
