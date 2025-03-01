This is primarily a method syntax based 3d cartesian vector library, which should work with 2d cartesian vectors as well.

IF you are doing a quick/small project, probably use **lib_concise.lua**. It is compacted, but lacks comments & annotations.
IF you are doing an actual/larger project, probably use **lib_with_comments.lua**. It has LuaCATS annotations and my comments.

I wrote a test for every single vector function to ensure they work as they should despite this lib being new, see tests.lua. That file also serves as documentation and examples.

Some brief examples:
```lua
--Creating an empty vector is done with vecn(). (short for vector-new) (this has to do with conveying intent)
local a = vecn()

--Creating a vector from cartesian coords is done with vecc(x,y,z).
--(short for vector-from-cartesian)
local b = vecc(15,39,-4)

--Creating a vector from spherical coords- (Ie local, from a radar)
--should be done with vecs(dist,azim,elev). (short for vector-from-spherical)
local dist, azim, elev = ign(1), ign(2), ign(3)
local c = vecs(dist*pi2, azim*pi2, elev*pi2)
```
```lua
--All vector functions are methods on the vectors you make. Examples:
a:dot(b)
a:abs()
a:muls(10)
a:norm()
--I diverged from common naming conventions where I felt a minor improvement/clarification could be made.
```

The reason I made this is because I got bored of using the same vector library forever, and I've been meaning to try out method syntax in my scripts.
Feel free to run the tests yourself ( just run the tests.lua file from the command line using lua ), there should be no issues. I did not write explicitly write any tests for 2d code.
Feel free to let me know if you want anything added, if anything is weird, or if you have a comment.
