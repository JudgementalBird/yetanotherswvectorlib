---@diagnostic disable: lowercase-global, duplicate-set-field

--Vector new
function vecn()return _addvecfunctions{x=0,y=0,z=0} end
--Vector from cartesian. Intentionally will not set x or y to 0, to encourage the usage of vecn() to express intentions more clearly.
--Will set z to allow you to use this library with 2d vectors.
function vecc(x,y,z)return _addvecfunctions{x=x, y=y, z=z or 0} end
--Vector from spherical
function vecs(dist,hor,ver)
	return _addvecfunctions{x=math.sin(hor)*math.cos(ver)*dist, y=math.cos(hor)*math.cos(ver)*dist, z=math.sin(ver)*dist} end

--Table of references to the vector functions. All new vectors get a copy of each reference in this table.
--You should probably not interact with this table or its contents.
_vecfuncs = {
    --Make a 1-layer deep-clone of this vector
    clone = function(self)return vecc(self.x,self.y,self.z)end,
    --Make string from this vector, primarily for debugging
    display = function(self)return "{"..self.x..", "..self.y..", "..self.z.."}" end,
    add = function(self,other)return vecc(self.x+other.x, self.y+other.y, self.z+other.z) end,
    --Multiply this vector by the scalar s
    muls = function(self,s)return vecc(self.x*s, self.y*s, self.z*s) end,
    --Divide this vector by the scalar s
    divs = function(self,s)return vecc(self.x/s, self.y/s, self.z/s) end,
    dot = function(self,other)return other.x*self.x + other.y*self.y + other.z*self.z end,
    --Source: https://en.wikipedia.org/wiki/Cross_product#Computing
    cross = function(self,other)
        return vecc(self.y*other.z - self.z*other.y,  self.z*other.x - self.x*other.z,  self.x*other.y - self.y*other.x) end,
    --Source: https://en.wikipedia.org/wiki/Vector_projection
    proj = function(self,other)return other:muls(self:dot(other)/other:dot(other)) end,
    --Source: https://en.wikipedia.org/wiki/Vector_projection
    rej = function(self,other)return self:sub(self:proj(other)) end,
    --'reflect incoming', eg treating self as an incoming ray of light
    --Source: https://www.contemporarycalculus.com/dh/Calculus_all/CC11_7_VectorReflections.pdf
    refi = function(self,normal)return self:sub(self:proj(normal):muls(2)) end,
    --'reflect outward', eg treating self as an outward pointing vector. This is the version commonly used for example in vector reflect guidance.
    --Source: https://www.fabrizioduroni.it/blog/post/2017/08/25/how-to-calculate-reflection-vector
    refo = function(self,normal)return normal:muls(self:dot(normal)):muls(2):sub(self) end,
    --Take magnitude, ie absolute value of the vector
    abs = function(self)return math.sqrt(self.x^2+self.y^2+self.z^2) end,
    --Returns self's opposite vector
    inv = function(self)return self:muls(-1) end,
    sub = function(self,other)return self:add( other:inv() ) end,
    --Normalizes self
    norm = function(self)return self:divs( self:abs() ) end,
    tolocal = function(self,r,f,u)return vecc(self:dot(r),self:dot(f),self:dot(u)) end,
    toglobal = function(self,r,f,u)return r:muls(self.x):add(f:muls(self.y)):add(u:muls(self.z)) end,
    --Provided an index for a given usage of it, this function returns the difference between self last time it ran to self this time it ran.
    --Warning: To facilitate this, it uses globals
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
}
function _addvecfunctions(avec)
	for k,v in pairs(_vecfuncs) do avec[k]=v end
	return avec
end
