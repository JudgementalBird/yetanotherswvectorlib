---@diagnostic disable: lowercase-global

function vecn()return _addvecfunctions{x=0,y=0,z=0} end
function vecc(x,y,z)return _addvecfunctions{x=x, y=y, z=z or 0} end
function vecs(dist,hor,ver) return _addvecfunctions{x=math.sin(hor)*math.cos(ver)*dist, y=math.cos(hor)*math.cos(ver)*dist, z=math.sin(ver)*dist} end

function _addvecfunctions(avec)
	for k,v in pairs(_vecfuncs) do avec[k]=v end
	return avec
 end
_vecfuncs = {
  clone = function(self)return vecc(self.x,self.y,self.z)end,
  display = function(self)return "{"..self.x..", "..self.y..", "..self.z.."}" end,
  add = function(self,other)return vecc(self.x+other.x, self.y+other.y, self.z+other.z) end,
  muls = function(self,s)return vecc(self.x*s, self.y*s, self.z*s) end,
  divs = function(self,s)return vecc(self.x/s, self.y/s, self.z/s) end,
  dot = function(self,other)return other.x*self.x + other.y*self.y + other.z*self.z end,
  cross = function(self,other)
    return vecc(self.y*other.z - self.z*other.y,  self.z*other.x - self.x*other.z,  self.x*other.y - self.y*other.x) end,
  proj = function(self,other)return other:muls(self:dot(other)/other:dot(other)) end,
  rej = function(self,other)return self:sub(self:proj(other)) end,
  refi = function(self,normal)return self:sub(self:proj(normal):muls(2)) end,
  refo = function(self,normal)return normal:muls(self:dot(normal)):muls(2):sub(self) end,
  abs = function(self)return math.sqrt(self.x^2+self.y^2+self.z^2) end,
  inv = function(self)return self:muls(-1) end,
  sub = function(self,other)return self:add( other:inv() ) end,
  norm = function(self)return self:divs( self:abs() ) end,
  tolocal = function(self,r,f,u)return vecc(self:dot(r),self:dot(f),self:dot(u)) end,
  toglobal = function(self,r,f,u)return r:muls(self.x):add(f:muls(self.y)):add(u:muls(self.z)) end,
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
