-- Copyright (c) 2012 Roland Yonaba

--[[
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local sqrt = math.sqrt
local abs = math.abs
local floor = math.floor
local tonumber = tonumber
local ipairs = ipairs
local setmetatable = setmetatable
local error = error
local type = type
local _VERSION = "0.1"

local function Normalize(_M)
	local n = 0
	for i,v in ipairs(_M) do
		n = n + (v*v)
	end
	return sqrt(n)
end

local function isInteger(v)
	return floor(v)==v
end

local function isSymmetric(_M)
	local i
	for x = 1,#_M[1]-1 do
		i = x
		for y = 1,#_M do
		i = i+1
			if not (_M[i]) then
				break
			end
			if (_M[i][x] ~= _M[x][i]) then
				return false
			end
		end
	end
	return true
end

local function isDiagonalDominant(_M)
	local s
	for i = 1,#_M do
		s = 0
		for j = 1,#_M[i]-1 do
			s = i~=j and (s + abs(_M[i][j])) or s
		end
		if abs(_M[i][i]) < s then
			return false
		end
	end
	return true
end

local function init1DVector(len)
	local x = {}
	for i = 1,len do x[i] = 0 end
	return x
end

local function checkDimError(_M,level)
	if type(_M)~='table' then
		return error('Argument is not a table!',level)
	end
	if #_M<=1 then
		return error('Maxtrix should be at least 2x2!',level)
	end
	for i = 1,#_M do
		if _M[i+1] then
			if (#_M[i] ~= #_M[i+1]) then
				return error('Wrong matrix dimensions!',level)
			end
		end
		for j = 1,#_M[i] do
			if not (type(_M[i][j]) == 'number') then
			return error('Maxtrix should contains only numbers!',level)
			end
		end
	end
	if (#_M ~= #_M[1]-1) then
		return error('Column missing!',level)
	end
end

local function checkMatrixError(_M,level)
	if not (isSymmetric(_M)) then
		return error('Matrix is not symmetric!',level)
	end
	if not (isDiagonalDominant(_M)) then
		return error('Matrix should be diagonal dominant!',level)
	end
end


local SOR_mt = { __call = function(self,...) return self.solve(...) end,
				 __newindex = function(self,key,value)
					return error ('Cannot write data inside SOR table',2)
				 end,
				}
local SOR = {
				MAX_ITERATION = 1E4,
				W = 1.86,
				ACCURACY = 1E-6,
			}

function SOR.setMaxIterations(I)
	if not tonumber(I) or not (I>0) or not isInteger(I) then
		return error('Max_Iterations must positive integer',2)
	end
	SOR.MAX_ITERATION = I
end

function SOR.getMaxIterations()
	return SOR.MAX_ITERATION
end

function SOR.SetRelaxation(W)
	if not tonumber(W) or not (W>0 and W<2) then
		return error('Relaxtion parameter must be a number between 0 and 2 excluded for convergence',2)
	end
	SOR.W = W
end

function SOR.getRelaxation()
	return SOR.W
end

function SOR.setAccuracy(Acc)
	if not tonumber(Acc) or (Acc <=0) then
		return error('Accuracy must be a positive number greather but near to 0. The lower, the better.',2)
	end
	SOR.ACCURACY = Acc
end

function SOR.getAccuracy()
	return SOR.ACCURACY
end

function SOR.solve(Matrix)
	checkDimError(Matrix,3)
	checkMatrixError(Matrix,3)


	local n = #Matrix
	local x = init1DVector(n)
	local w = SOR.W
	local Acc = SOR.ACCURACY
	local q, p, sum
	local t = 0
	repeat
	t = t+1
	q = Normalize(x)
		for i=1,n do
		sum = Matrix[i][n+1]
			for j=1,n do
				if (i~=j) then
				sum = sum - Matrix[i][j]*x[j]
				end
			end
		x[i] = (1-w) * x[i] + w * sum/Matrix[i][i]
		end
	p = Normalize(x)
	local d = abs(p-q)
	until (d<Acc) or (t>=SOR.MAX_ITERATION)

	return x, t
end

return setmetatable(SOR,SOR_mt)



