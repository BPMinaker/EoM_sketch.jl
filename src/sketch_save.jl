function sketch_save(dir_output,str_in)

#viewpt=[100]
#lookat=[000]


#s="def o (0,0,0) def i (1,0,0) def j (0,1,0) def k (0,0,1)\n"
#  s=[s "def origin {\n"]
#  s=[s "special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$x$} | (o)(i) \n"]
#  s=[s "special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$y$} | (o)(j) \n"]
#  s=[s "special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {$z$} | (o)(k) \n"]
#  s=[s "}\n"]
#s=[s "def vwpt (" num2str(viewpt(1)) "," num2str(viewpt(2)) "," num2str(viewpt(3)) ")\n"]
#s=[s "def lkat (" num2str(lookat(1)) "," num2str(lookat(2)) "," num2str(lookat(3)) ")\n"]
#s=[s "put {view((vwpt),(lkat),[0,0,1])}{origin}\n"]

s="def n_sphere_segs 12\n"
s*="def n_cyl_segs 12\n"
s*="def n_whl_segs 24\n"
s*="def n_segs 4\n"
#s=[s sketch_prim("origin_ball","sphere","loc",[000],"rad",0.15,"col","blue")]
s*=str_in ## Insert the incoming content

#s=[s "special |\\tikzstyle{ann} = [fill=white,font=\\footnotesize,inner sep=1pt]|[lay=under]\n"]
#s=[s "special |\\tikzstyle{ghost} = [draw=lightgray]|[lay=under]\n"]
#s=[s "special |\\tikzstyle{transparent cone} = [fill=blue!20,fill opacity=0.8]|[lay=under]\n"]

#s=[s "put {scale(0.75) then view((1,0,0),(0,0,0),[0,0,1])}{system}\n"]
#s=[s "put {scale(0.75) then view((0,1,0),(0,0,0),[0,0,1])}{system}\n"]
s*="put {scale(0.75) then view((1,1,0.5),(0,0,0),[0,0,1])}{system}\n"

s*="global {language tikz }\n"

out=joinpath(dir_output,"sketch.sk")
open(out,"w") do handle
	write(handle,s)
end

tex=joinpath(dir_output,"sketch.tex")
cmd="sketch '$out' -o '$tex' 2>/dev/null"
try
	run(`bash -c $cmd`)
catch
	error("Error running sketch!")
end

end  ## Leave
