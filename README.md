Serialization functions for built-in octave data types.

With this you can get a human-readable string from an octave object which can be retrieved with "eval". The intended purpose is to serialize object for transmission over byte-stream channels or for storage in databases while perserve
the readability by humans(in contrast to the usage of typecast for example).

The principle is as with JSON: eval(serialize(data)) == data

The most built-in GNU Octave data types like numeric objects (real, complex and integer scalars and matrices),
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

What's missing:
Support for sparse matrizes
