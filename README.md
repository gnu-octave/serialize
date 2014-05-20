Serialization functions for built-in octave data types.

With this you can get a human-readable string from an octave object which can be retrieved with "eval". The intended purpose is to serialize object for transmission over byte-stream channels or for storage in databases while perserve
the readability by humans(in contrast to the usage of typecast for example).

The principle is like JSON: eval(serialize(data)) == data

```
octave:1> x(1).a = "string1";
octave:2> x(2).a = "string2";
octave:3> x(1).b = 1;
octave:4> x(2).b = {3,4, rand(3,3)};
octave:5> 
octave:5> s = serialize(x)
s = struct("a",{char([115 116 114 105 110 103 49]),char([115 116 114 105 110 103 50])},"b",{1,{3,4,[0.565943301721236 0.685079217372737 0.0616254701297505;0.449486075058551 0.896455328674705 0.727906626406058;0.445813490881416 0.654086798649236 0.234766427416828]}})
octave:6> x2 = eval(s)
x2 =

  1x2 struct array containing the fields:

    a
    b

octave:7> assert(x,x2, 8*eps)
```
