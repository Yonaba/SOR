#SOR : Linear Equation System Solver#
*Successive Over Relaxation (SOR)* is a light-weight library for solving linear Equation Systems using a converging iterative process.<br/>
It is written in [Lua][].

##Usage##
Place the file 'SOR.lua' inside your project, call it using *require*.
    
    local SOR = require ("SOR")
	
Now assuming you have to solve this linear system of 16x16 (16 equations, 16 unknown variables).<br/>
You will have to create a 16x17 matrix representing that system, the 17th column beign the solution vector.

    local matrix = {
					{-4,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,-11},
					{1,-4,1,0,0,1,0,0,0,0,0,0,0,0,0,0,-3},
					{0,1,-4,1,0,0,1,0,0,0,0,0,0,0,0,0,-3},
					{0,0,1,-4,0,0,0,1,0,0,0,0,0,0,0,0,-11},
					{1,0,0,0,-4,1,0,0,1,0,0,0,0,0,0,0,-8},
					{0,1,0,0,1,-4,1,0,0,1,0,0,0,0,0,0,0},
					{0,0,1,0,0,1,-4,1,0,0,1,0,0,0,0,0,0},
					{0,0,0,1,0,0,1,-4,0,0,0,1,0,0,0,0,-8},
					{0,0,0,0,1,0,0,0,-4,1,0,0,1,0,0,0,-8},
					{0,0,0,0,0,1,0,0,1,-4,1,0,0,1,0,0,0},
					{0,0,0,0,0,0,1,0,0,1,-4,1,0,0,1,0,0},
					{0,0,0,0,0,0,0,1,0,0,1,-4,0,0,0,1,-8},
					{0,0,0,0,0,0,0,0,1,0,0,0,-4,1,0,0,-10},
					{0,0,0,0,0,0,0,0,0,1,0,0,1,-4,1,0,-2},
					{0,0,0,0,0,0,0,0,0,0,1,0,0,1,-4,1,-2},
					{0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,-4,-10},
				}
				
To solve this sytem, use *SOR.solve()*.

    local x, iterations = SOR.solve(matrix)
    -- displays x-vector:
    for i,v in ipairs(x) do
      print(('x[%d] = %f'):format(i,v))
    end
    print(('Iterations Made: %d'):format(iterations))

The output will be :

    x[1] = 5.454459
    x[2] = 4.594688
    x[3] = 4.594679
    x[4] = 5.454531
    x[5] = 6.223469
    x[6] = 5.329580
    x[7] = 5.329561
    x[8] = 6.223491
    x[9] = 6.109833
    x[10] = 5.170488
    x[11] = 5.170455
    x[12] = 6.109845
    x[13] = 5.045460
    x[14] = 4.071980
    x[15] = 4.071964
    x[16] = 5.045457
    Iterations Made: 78

##Note##
Consider that, to have this working the input matrix , with the last column left out, must be [symmetric][] and [diagonally dominant][].<br/>
Otherwise, the solver will throw an error.


##Full documentation##
		
* *SOR.setAccuracy(Acc)* : sets the solver accuracy. It has to be a tiny positive value, as the solver uses it a convergence criteria to stop iterations. By default, value used is 1E-6.
* *SOR.getAccuracy()* : returns the accuracy.
* *SOR.setMaxIterations(I)* : the maximum possible iterations allowed to find a solution. Default value is 1E4
* *SOR.getMaxIterations* : return the number of maximum interations allowed.
* *SOR.setRelaxation(W)* : value of the relaxation parameter. It has to be a number between 0 and 2, both excluded. By default,value 1.86 will be used.
* *SOR.getRelaxation* : returns the value of the relaxation parameter.
* *SOR.solve(Matrix)* : Returns a linear solution vector, plus the number of iterations made.

You can optionnally modify the solver behaviour before using *SOR.solve()* through these commands.

##Useful links##
*  [Wikipedia : Successive Over Relaxation][]
  
##License##
This work is under [MIT-LICENSE][]<br/>
Copyright (c) 2012 Roland Yonaba

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

[Lua]: http://www.lua.org
[Wikipedia : Successive Over Relaxation]: http://en.wikipedia.org/wiki/Successive_over-relaxation
[symmetric]: http://en.wikipedia.org/wiki/Symmetric_matrix
[diagonally dominant]: http://en.wikipedia.org/wiki/Diagonally_dominant_matrix
[MIT-LICENSE]: http://www.opensource.org/licenses/mit-license.php