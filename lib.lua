---@diagnostic disable: lowercase-global

---Create new empty vector.
---@generic T
---@return T vec
---@nodiscard
---@section vecn
function vecn()return _addvecfunctions{x=0,y=0,z=0} end
---@endsection

---Creates vector with supplied cartesian components. Requires x and y, use vecn() if you need to create empty vectors. z not required to allow 2d usage of this library.
---@param x number
---@param y number
---@param z number|nil
---@generic T
---@return T vec
---@nodiscard
---@section vecc
function vecc(x,y,z)return _addvecfunctions{x=x, y=y, z=z or 0} end
---@endsection

---Creates vector with cartesian components from supplied spherical coordinates.
---@param dist number Distance
---@param hor number Horizontal angle in radians.
---@param ver number Vertical angle in radians.
---@generic T
---@return T vec
---@nodiscard
---@section vecs
function vecs(dist,hor,ver)
  return _addvecfunctions{x=math.sin(hor)*math.cos(ver)*dist, y=math.cos(hor)*math.cos(ver)*dist, z=math.sin(ver)*dist} end
---@endsection

---Table of references to the vector functions. All new vectors get a copy of each reference in this table.
---You should probably not interact with this table or its contents.
---@section _vecfuncs 1 _VECFUNCS
_vecfuncs = {
  ---Makes a 1-layer deep-cloned vector.
  ---@generic T
  ---@param self T
  ---@return T result
  ---@nodiscard
  ---@section clone
  clone = function(self)return vecc(self.x,self.y,self.z)end,
  ---@endsection

  ---Make a string from this vector, primarily for debugging.
  ---@param self vec
  ---@return string result 
  ---@nodiscard
  ---@section display
  display = function(self)return "{"..self.x..", "..self.y..", "..self.z.."}" end,
  ---@endsection

  ---Add `other` to `self`.
  ---@param self vec
  ---@param other vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section add
  add = function(self,other)return vecc(self.x+other.x, self.y+other.y, self.z+other.z) end,
  ---@endsection

  ---Multiply `self` by the scalar `s`.
  ---@param self vec
  ---@param s number
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section muls
  muls = function(self,s)return vecc(self.x*s, self.y*s, self.z*s) end,
  ---@endsection

  ---Divide `self` by the scalar `s`.
  ---@param self vec
  ---@param s number
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section divs
  divs = function(self,s)return vecc(self.x/s, self.y/s, self.z/s) end,
  ---@endsection

  ---Dot product of `self`*`other`
  ---@param self vec
  ---@param other vec
  ---@return number result
  ---@nodiscard
  ---@section dot
  dot = function(self,other)return other.x*self.x + other.y*self.y + other.z*self.z end,
  ---@endsection

  ---Cross product of `self`x`other`. Source: https://en.wikipedia.org/wiki/Cross_product#Computing
  ---@param self vec
  ---@param other vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section cross
  cross = function(self,other)
    return vecc(self.y*other.z - self.z*other.y,  self.z*other.x - self.x*other.z,  self.x*other.y - self.y*other.x) end,
    ---@endsection
  
  ---Vector projection of `self` onto `other`. Source: https://en.wikipedia.org/wiki/Vector_projection
  ---@param self vec
  ---@param other vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section proj
  proj = function(self,other)return other:muls(self:dot(other)/other:dot(other)) end,
    ---@endsection

  ---Vector rejection of `self` onto `other`. Source: https://en.wikipedia.org/wiki/Vector_projection
  ---@param self vec
  ---@param other vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section rej
  rej = function(self,other)return self:sub(self:proj(other)) end,
    ---@endsection

  ---Vector 'reflect incoming', eg treating `self` as an incoming ray of light. 
  ---Source: https://www.contemporarycalculus.com/dh/Calculus_all/CC11_7_VectorReflections.pdf
  ---@param self vec
  ---@param normal vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section refi
  refi = function(self,normal)return self:sub(self:proj(normal):muls(2)) end,
    ---@endsection

  ---Vector 'reflect outward', eg treating `self` as an outward pointing vector. This is the function commonly used in for example vector reflect guidance.
  ---Source: https://www.fabrizioduroni.it/blog/post/2017/08/25/how-to-calculate-reflection-vector
  ---@param self vec
  ---@param normal vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section refo
  refo = function(self,normal)return normal:muls(self:dot(normal)):muls(2):sub(self) end,
    ---@endsection

  ---Takes magnitude, ie absolute value of `self`
  ---@param self vec
  ---@return number result
  ---@nodiscard
  ---@section abs
  abs = function(self)return math.sqrt(self.x^2+self.y^2+self.z^2) end,
    ---@endsection

  ---Gives `self`'s opposite vector
  ---@param self vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section inv
  inv = function(self)return self:muls(-1) end,
    ---@endsection

  ---Subtraction. `self`-`other`, or `self` + -1*`other`.
  ---@param self vec
  ---@param other vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section sub
  sub = function(self,other)return self:add( other:inv() ) end,
    ---@endsection

  ---Normalizes `self`. `normalized` has a magnitude of 1.
  ---@param self vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section norm
  norm = function(self)return self:divs( self:abs() ) end,
    ---@endsection

  ---Uses your craft's facing vectors `r`,`f`, and `u`, to change basis of `self` from world frame to your craft's local frame.
  ---It only does the rotation relative to the craft, not the translation from origin to craft. It is only to be used with already-relative vectors.
  ---@param self vec
  ---@param r vec
  ---@param f vec
  ---@param u vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section tolocal
  tolocal = function(self,r,f,u)return vecc(self:dot(r),self:dot(f),self:dot(u)) end,
    ---@endsection

  ---Uses your craft's facing vectors `r`,`f`, and `u`, to change basis of `self` from your craft's local frame to the world frame.
  ---It only does the rotation relative to the craft, not the translation from craft to origin. You need to add your position afterwards to get a global position vector.
  ---@param self vec
  ---@param r vec
  ---@param f vec
  ---@param u vec
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section toglobal
  toglobal = function(self,r,f,u)return r:muls(self.x):add(f:muls(self.y)):add(u:muls(self.z)) end,
    ---@endsection

  ---Provided an index for a given usage of it, this function returns the difference between `self`'s components last time it ran, to `self`'s components this time it ran. 
  ---Warning: To facilitate this, it uses global variables.
  ---@param self vec
  ---@param index number
  ---@generic T
---@return T result
  ---@nodiscard
  ---@section gdelta
  gdelta = function(self,index)
    if not gdeltas then
      gdeltas = {}
      gdeltas[index] = {old = vecn(),delta = vecn()}
    elseif not gdeltas[index] then
      gdeltas[index] = {old = vecn(),delta = vecn()}
    end
    gdeltas[index].delta = self:sub(gdeltas[index].old)
    gdeltas[index].old = self:clone()
    return gdeltas[index].delta
  end
  ---@endsection
}
---@endsection _VECFUNCS
---You probably shouldn't use or touch this function
---@param avec table
---@nodiscard
---@section _addvecfunctions
function _addvecfunctions(avec)
  for k,v in pairs(_vecfuncs) do avec[k]=v end
  return avec
end
---@endsection
