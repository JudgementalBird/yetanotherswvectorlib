---@diagnostic disable: lowercase-global, duplicate-set-field

-- this one is NOT MINIFIABLE - rewriting super soon, but until then use the other file with 'minifiable' in its name

function vecn()return _addvecfunctions{x=0,y=0,z=0} end
function vecc(x,y,z)return _addvecfunctions{x=x, y=y, z=z or 0} end
function vecs(dist,hor,ver)
	return _addvecfunctions{x=math.sin(hor)*math.cos(ver)*dist, y=math.cos(hor)*math.cos(ver)*dist, z=math.sin(ver)*dist} end
_vecfuncs = {}
function _addvecfunctions(avec)
	for k,v in pairs(_vecfuncs) do avec[k]=v end
	return avec
end
function _vecfuncs:clone()return vecc(self.x,self.y,self.z)end
function _vecfuncs:display()return "{"..self.x..", "..self.y..", "..self.z.."}" end
function _vecfuncs:add(other)return vecc(self.x+other.x, self.y+other.y, self.z+other.z) end
function _vecfuncs:muls(s)return vecc(self.x*s, self.y*s, self.z*s) end
function _vecfuncs:divs(s)return vecc(self.x/s, self.y/s, self.z/s) end
function _vecfuncs:dot(other)return other.x*self.x + other.y*self.y + other.z*self.z end
function _vecfuncs:cross(other) 
	return vecc(self.y*other.z - self.z*other.y,  self.z*other.x - self.x*other.z,  self.x*other.y - self.y*other.x) end
function _vecfuncs:proj(other)return other:muls(self:dot(other)/other:dot(other)) end 
function _vecfuncs:rej(other)return self:sub(self:proj(other)) end 
function _vecfuncs:refi(normal)return self:sub(self:proj(normal):muls(2)) end 
function _vecfuncs:refo(normal)return normal:muls(self:dot(normal)):muls(2):sub(self) end 
function _vecfuncs:abs()return math.sqrt(self.x^2+self.y^2+self.z^2) end
function _vecfuncs:inv()return self:muls(-1) end
function _vecfuncs:sub(other)return self:add( other:inv() ) end
function _vecfuncs:norm()return self:divs( self:abs() ) end
function _vecfuncs:tolocal(r,f,u)return vecc(self:dot(r),self:dot(f),self:dot(u)) end
function _vecfuncs:toglobal(r,f,u)return r:muls(self.x):add(f:muls(self.y)):add(u:muls(self.z)) end
function _vecfuncs:gdelta(index)
	if not gdeltas then gdeltas = {};gdeltas[index] = {old = vecn(),delta = vecn()}
	elseif not gdeltas[index] then gdeltas[index] = {old = vecn(),delta = vecn()} end
	gdeltas[index].delta = self:sub(gdeltas[index].old)
	gdeltas[index].old = self:clone()
	return gdeltas[index].delta
end

