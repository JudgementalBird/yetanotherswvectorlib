This is primarily a method syntax based 3d cartesian vector library, which for now *should* work with, and later, will have trustworthy support for 2d cartesian as well.

See lib_with_comments.lua for the library with explanatory comments — this serves as half of the de facto documentation.
**See lib_concise.lua for what is intended to be slapped into stormworks.**

I wrote a test for every single vector function to ensure they work as they should despite this lib being an infant, see tests.lua. That file also serves as documentation and examples.

Simple examples:
```lua
--Creating an empty vector should be done with vecn(). (short for vec-new)
local a = vecn()

--Creating a vector from cartesian coords should be done with vecc(x,y,z).
--(short for vec-from-cartesian)
local b = vecc(15,39,-4)

--Creating a vector from spherical coords- (Ie local, from a radar)
--should be done with vecs(dist,azim,elev). (short for vec-from-spherical)
local dist, azim, elev = ign(1), ign(2), ign(3)
local c = vecs(dist*pi2, azim*pi2, elev*pi2)
```
```lua
--All vector functions are methods on the vectors you make. Examples:
a:dot(b)
a:abs()
a:muls(10)
a:norm()
--I diverged from naming convention when I felt a minor improvement/clarification could be made.
```

The reason I made this is because I got bored of using the same vector library forever, and I've been meaning to try out method syntax in my scripts.
Feel free to run the tests yourself ( just run the tests.lua file from the command line using lua ), they should all be passing. The one thing I did not consider while writing tests was 2d code.
Feel free to let me know if you want anything added, if anything is weird, or if you have a comment.
