function sketch_save(dir_output,str_in,name)

viewpt=[1,2,2]
lookat=[0,0,0]

out=joinpath(dir_output,"$name.sk")
file=open(out,"w")

println(file,"def o (2,0,0) def i (3,0,0) def j (2,1,0) def k (2,0,1)")
println(file,"def origin {")
println(file,"special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {\$x\$}; | (o)(i)")
println(file,"special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {\$y\$}; | (o)(j)")
println(file,"special | \\footnotesize \\draw[arrows=->] #1 -- #2 node[pos=1.2] {\$z\$}; | (o)(k)")
println(file,"}")
println(file,"def vwpt (",viewpt[1],",",viewpt[2],",",viewpt[3],")")
println(file,"def lkat (",lookat[1],",",lookat[2],",",lookat[3],")")
println(file,"put {view((vwpt),(lkat),[0,0,1])}{origin}")


println(file,"def n_sphere_segs 12")
println(file,"def n_cyl_segs 12")
println(file,"def n_whl_segs 24")
println(file,"def n_segs 4")

println(file,str_in) ## Insert the incoming content
println(file,"put {scale(1) then view((vwpt),(lkat),[0,0,1])}{system}")


println(file,"global {language tikz }")

close(file)

tex=joinpath(dir_output,"$name.tex")
cmd="sketch '$out' -o '$tex' 2>/dev/null"
try
	run(`bash -c $cmd`)
catch
	error("Error running sketch!")
end

end  ## Leave



#println(file,"special |\\tikzstyle{ann} = [fill=white,font=\\footnotesize,inner sep=1pt]|[lay=under]")
#println(file,"special |\\tikzstyle{ghost} = [draw=lightgray]|[lay=under]")
#println(file,"special |\\tikzstyle{transparent cone} = [fill=blue!20,fill opacity=0.8]|[lay=under]")
