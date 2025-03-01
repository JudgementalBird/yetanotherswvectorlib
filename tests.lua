---@diagnostic disable: lowercase-global

local to_test = {"lib_concise", "lib"}
for i = 1,2 do
	require(to_test[i])
	print("\n".."-- TESTING: "..to_test[i].." --")

	function rad2deg(a)return a*180/math.pi end
	function deg2rad(a)return a/360*math.pi*2 end

	function req( a, b )return math.abs(a-b) < 0.0001 end --Checks if a and b are 'roughly equal' with max 0.0001 error. Used since floating point imprecision and stuff
	assert( not req(1,1.001) )
	assert( req(1,1.0001) )
	assert( not req(-15,-15.001) )
	assert( req(-15,-15.0001) )

	function vecreq( a, b )return req(a.x, b.x) and req(a.y, b.y) and req(a.z, b.z) end --Checks if two vectors are identical with max 0.0001 per-axis error.
	assert( not vecreq(vecc(1,1,1), vecc(1.001,1.001,1.001)) )
	assert( vecreq(vecc(1,1,1), vecc(1.0001,1.0001,1.0001)) )
	assert( not vecreq(vecc(-15,-15,-15), vecc(-15.001,-15.001,-15.001)) )
	assert( vecreq(vecc(-15,-15,-15), vecc(-15.0001,-15.0001,-15.0001)) )

	function veceq( a,b )return a.x==b.x and a.y==b.y and a.z==b.z end --Checks if two vectors are identical according to double equals operator
	assert( veceq(vecc(1,2,3), vecc(1,2,3)) )
	assert( not veceq(vecc(-1,2,3), vecc(1,2,3)) )

	function assert_req( a, b )return assert(req(a,b)) end --Assert two numbers are *nearly* identical
	function assert_vecreq( a, b )return assert(vecreq(a,b)) end --Assert two vectors are *nearly* identical
	function assert_veceq( a, b )return assert(veceq(a,b)) end --Assert two vectors *are* identical

	-- TESTS / EXAMPLES:
	--vecn
	assert_veceq( vecn(), {x=0,y=0,z=0} )
	print("Passed vecn() test")
	--vecc
	assert_veceq( vecc(136,-15,1.6), {x=136,y=-15,z=1.6} )
	print("Passed vecc() test")
	--vecs
	assert_veceq( vecs(5,0,0), {x=0,y=5,z=0} )
	print("Passed vecs() test")
	--clone
	do
		local a = vecn()
		local b = a
		assert( a == b ) --lua implicitly copies references, and two table reference values are only equal if they point to the same table
		local c = a:clone()
		assert( a ~= c ) --clone() can be used to 1-layer deep clone
	end
	print("Passed clone() test")
	--display
	assert( vecc(135,29,40):display() == "{135, 29, 40}" ) --good for debugging
	print("Passed display() test")
	--add
	assert_veceq( vecc(1,1,1):add( vecc(1,2,3) ), vecc(2, 3, 4) )
	print("Passed add() test")
	--muls
	assert_veceq( vecc(1,2,3):muls(3), vecc(3,6,9) )
	print("Passed muls() test")
	--divs
	assert_veceq( vecc(3,6,9):divs(3), vecc(1,2,3) )
	print("Passed divs() test")
	--dot
	assert( vecc(0,0,5):dot( vecc(0,5, 2) ) >  0 ) --dot <90deg should be positive
	assert( vecc(0,0,5):dot( vecc(0,5, 0) ) == 0 ) --dot 90deg should be 0
	assert( vecc(0,0,5):dot( vecc(0,5,-2) ) <  0 ) --dot >90deg should be negative
	print("Passed dot() test")
	--cross
	assert_veceq( vecc(0,1,0):cross(vecc(-1,0,0)), vecc(0,0,1) )
	assert_veceq( vecc(0,1,0):cross(vecc(1,0,0)), vecc(0,0,-1) )
	print("Passed cross() test")
	--proj
	do
		assert_veceq( vecc(1,0,0):proj(vecc(0,1,0)), vecc(0,0,0) ) --projection of a onto b when a is orthogonal to b like this is zero vector

		local a = vecs(1,0,deg2rad(45)) --1 long vector pointing 45 degrees up on the YZ
		local b = vecc(0,1,0) --1 long vector pointing straight into y axis
		local c = a:proj(b)
		assert( c.x == 0 )
		assert( c.y > 0 and c.y < 1 ) --since a is angled up, its projection onto b should extend into the y axis by something between 0 and 1
		assert( c.z == 0 )
	end
	print("Passed proj() test")
	--rej
	do
		assert_veceq( vecc(1,0,0):rej(vecc(0,1,0)), vecc(1,0,0) ) --rejection of a onto b when orthogonal like this should be a

		local a = vecs(1,0,deg2rad(45)) --1 long vector pointing 45 degrees up from the Y axis in the YZ plane
		local b = vecc(0,1,0) --1 long vector pointing straight into y axis
		local c = a:rej(b)
		assert( c.x == 0 )
		assert( c.y == 0 )
		assert( c.z > 0 and c.z < 1 ) --since a is angled up, its rejection onto b should extend into the z axis by something between 0 and 1
	end
	print("Passed rej() test")
	--refo
	do
		local a = vecs(1,0,deg2rad(45)) --1 long vector pointing 45 degrees up from the Y axis in the YZ plane
		local b = vecc(0,0,1) --1 long vector pointing straight into z axis
		local a_ref = a:refo(b)
		assert_req( a_ref.x, 0 )
		assert( a_ref.y > -1 and a_ref.y < 0 )
		assert( a_ref.z > 0 and a_ref.z < 1 )
	end
	print("Passed refo() test")
	--refi
	do
		local a = vecs(1,0,deg2rad(45)):inv() --1 long vector at the 45 degree mark between the negative parts of the y and x axes, ie pointing down to the left on the XY plane
		local b = vecc(0,0,1) --1 long vector pointing straight into z axis
		local a_ref = a:refi(b)
		assert_req( a_ref.x, 0 )
		assert( a_ref.y > -1 and a_ref.y < 0 )
		assert( a_ref.z > 0 and a_ref.z < 1 )
	end
	print("Passed refi() test")
	--abs
	assert( vecn():abs() == 0 ) --new vectors are initialized with 0,0,0, so their length should be 0.
	assert( vecc(8,0,0):abs() == 8 )
	print("Passed abs() test")
	--inv
	assert_veceq( vecn():inv(), vecn() )
	assert_veceq( vecc(0.0,0.0,0.0):inv(), vecn() )
	assert_veceq( vecc(5,-2,3):inv(), vecc(-5,2,-3) )
	print("Passed inv() test")
	--sub
	assert_vecreq( vecc(2,3,4):sub( vecc(1,2,3) ), vecc(1, 1, 1) )
	print("Passed sub() test")
	--norm
	assert_req( vecc(1,0,0):norm():abs(), 1 )
	assert_req( vecc(5,3,7):norm():abs(), 1 )
	assert_veceq( vecc(5,0,0):norm(), vecc(1,0,0) )
	print("Passed norm() test")
	--gdelta
	do
		local pos = vecc(0,0,0)
		local vel = pos:gdelta("pos")
		assert_veceq( vel,vecc(0,0,0) )
		pos.x = 5
		vel = pos:gdelta("pos")
		assert_veceq( vel,vecc(5,0,0) )
		pos.x = 10
		vel = pos:gdelta("pos")
		assert_veceq( vel,vecc(5,0,0) )
	end
	print("Passed gdelta() test")
	--tolocal
	do
		local r,f,u = vecc(0,1,0),vecc(-1,0,0),vecc(0,0,1)
		local a = vecc(1,2,3)
		local b = a:tolocal(r,f,u)
		assert_vecreq( b, vecc(2,-1,3) )
	end
	print("Passed tolocal() test")
	--toglobal
	do
		local r,f,u = vecc(0,1,0),vecc(-1,0,0),vecc(0,0,1)
		local a = vecc(1,2,3)
		local b = a:toglobal(r,f,u)
		assert_vecreq( b, vecc(-2,1,3) )
	end
	print("Passed toglobal() test")


	--test cleanup
	gdeltas = nil
end