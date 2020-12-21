function sketch_prim(;name="unnamed",type="shere",axis=[0,0,1],loc=[0,0,0],rad=0.01,top=[0,0,1],bot=[0,0,0],col="gray",opc=1.0)


	if type=="sphere"||type=="ball"

		bot=loc-[0,0,rad]
		s="def "*name*"_loc $(Tuple(loc))\n"
		s*="def "*name*"_bot $(Tuple(bot))\n"
		s*="def "*name*" {sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_sphere_segs,rotate(360/n_sphere_segs,("*name*"_loc))} sweep {n_sphere_segs,rotate(180/n_sphere_segs,("*name*"_loc),[0,1,0])}("*name*"_bot)}\n"
#		s*="put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=" num2str(opc) ",fill=" col "!20,line width=0.2pt]{n_sphere_segs,rotate(360/n_sphere_segs,("*name*"loc))} sweep {n_sphere_segs,rotate(180/n_sphere_segs,("*name*"loc),[0,1,0])}("*name*"bot)}\n"

	elseif type=="tube"

		axis=top-bot
		rad*=nullspace(Array(axis'))
		p2=top+rad[:,1]
		p1=bot+rad[:,1]

		s="def "*name*"_top $(Tuple(top))\n"
		s*="def "*name*"_axis $(axis)\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_l1 line("*name*"_p1)("*name*"_p2)\n"
		s*="def "*name*" {sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_cyl_segs<>,rotate(360/n_cyl_segs,("*name*"_top),["*name*"_axis]) }{"*name*"_l1}}\n"

	#		s*="put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=" num2str(opc) ",fill=" col "!20,line width=0.2pt]{n_cyl_segs<>,rotate(360/n_cyl_segs,("*name*"top),["*name*"axis]) }{"*name*"l1}}\n"

	elseif type=="cyl"

		r=rad
		rad*=nullspace(Array(axis'))

		p2=loc+r*axis+rad[:,1]
		p1=loc-r*axis+rad[:,1]

		s="def "*name*"_loc $(Tuple(loc))\n"
		s*="def "*name*"_axis $(axis)\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_l1 line("*name*"_p1)("*name*"_p2)\n"
		s*="def "*name*" {sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_cyl_segs<>,rotate(360/n_cyl_segs,("*name*"_loc),["*name*"_axis]) }{"*name*"_l1}}\n"


	elseif type=="cone"

		r=rad
		rad*=nullspace(Array(axis'))
		p2=top
		p1=top-2*r*axis+rad[:,1]

		s="def "*name*"_top $(Tuple(top))\n"
		s*="def "*name*"_axis $(axis)\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_l1 line("*name*"_p1)("*name*"_p2)\n"
		s*="def "*name*" {sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_cyl_segs<>,rotate(360/n_cyl_segs,("*name*"_top),["*name*"_axis]) }{"*name*"_l1}}\n"

	elseif type=="box"||type=="cube"

		p2=loc+rad/2*[1,1,1]
		p1=loc+rad/2*[1,1,-1]

		s="def "*name*"_loc $(Tuple(loc))\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_l1 line("*name*"_p1)("*name*"_p2)\n"
		s*="def "*name*" {sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_segs<>,rotate(360/n_segs,("*name*"_loc))}{"*name*"_l1}}\n"

#		s*="put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=" num2str(opc) ",fill=" col "!20,line width=0.2pt]{n_segs<>,rotate(360/n_segs,("*name*"loc))}{"*name*"l1}}\n"

	elseif type=="wheel"

		r=loc[3]
		rad=[0,0,r]
		srt_rad=0.8*rad

		p1=loc+rad+r/4*axis
		p2=loc+rad-r/4*axis
		p3=loc+srt_rad+r/4*axis
		p4=loc+srt_rad-r/4*axis
		p5=p3-3*r/16*axis
		p6=p4+3*r/16*axis

		s="def "*name*"_loc $(Tuple(loc))\n"
		s*="def "*name*"_axis $(axis)\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_p3 $(Tuple(p3))\n"
		s*="def "*name*"_p4 $(Tuple(p4))\n"
		s*="def "*name*"_p5 $(Tuple(p5))\n"
		s*="def "*name*"_p6 $(Tuple(p6))\n"

		s*="def "*name*"_l1 line("*name*"_p6)("*name*"_p4)("*name*"_p2)("*name*"_p1)("*name*"_p3)("*name*"_p5)\n"
		s*="def "*name*" sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_whl_segs<>,rotate(360/n_whl_segs,("*name*"_loc),["*name*"_axis]) }{"*name*"_l1}\n"

#		s*="put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=" num2str(opc) ",fill=" col "!20,line width=0.2pt]{n_whl_segs<>,rotate(360/n_whl_segs,("*name*"top),["*name*"axis]) }{"*name*"l1}}\n"

	elseif type=="bwheel"

		r=loc[3]
		rad=[0,0,r]

		p1=loc+0.8*rad+r/16*axis
		p2=loc+0.8*rad-r/16*axis
		p3=loc+0.8*rad+r/4*axis
		p4=loc+0.8*rad-r/4*axis
		p5=loc+0.9*rad+r/4*axis
		p6=loc+0.9*rad-r/4*axis
		p7=loc+0.6375*rad
		tang=[1,0,0]

		s="def "*name*"_loc $(Tuple(loc))\n"
		s*="def "*name*"_axis $(axis)\n"
		s*="def "*name*"_tang $(tang)\n"
		s*="def "*name*"_p1 $(Tuple(p1))\n"
		s*="def "*name*"_p2 $(Tuple(p2))\n"
		s*="def "*name*"_p3 $(Tuple(p3))\n"
		s*="def "*name*"_p4 $(Tuple(p4))\n"
		s*="def "*name*"_p5 $(Tuple(p5))\n"
		s*="def "*name*"_p6 $(Tuple(p6))\n"
		s*="def "*name*"_p7 $(Tuple(p7))\n"

		s*="def "*name*"_l1 line ("*name*"_p1)("*name*"_p3)("*name*"_p5)("*name*"_p6)("*name*"_p4)("*name*"_p2)\n"
		s*="def "*name*"_l2 sweep{n_cyl_segs/2,rotate(2*87.2/n_cyl_segs,("*name*"_p7),["*name*"_tang])}("*name*"_p5)\n"
		s*="def "*name*"_s1 sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_whl_segs<>,rotate(360/n_whl_segs,("*name*"_loc),["*name*"_axis]) }{"*name*"_l1}\n"
		s*="def "*name*"_s2 sweep[cull=false,fill opacity=$opc,fill=$(col)!20,line width=0.2pt]{n_whl_segs,rotate(360/n_whl_segs,("*name*"_loc),["*name*"_axis]) }{"*name*"_l2}\n"
		s*="def "*name*" {{" *name*"_s1}{"*name*"_s2}}\n"

#		s*="put {view((vwpt),(lkat),[0,0,1])}{sweep[cull=false,fill opacity=" $(opc) ",fill=" col "!20,line width=0.2pt]{n_whl_segs<>,rotate(360/n_whl_segs,("*name*"top),["*name*"axis]) }{"*name*"l1}}\n"

	else
		error("Incorrect arguments to sketch.")
	end

end  ## Leave
