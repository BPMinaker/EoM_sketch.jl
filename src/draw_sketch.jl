function draw_sketch(dir_output,system;verbose=false)

scale=30

verbose && println("Sketching ...")
s=""
s2="def system{"

tags=["wheel" "chassis" "upright" "strut" "arm" "crank" "rod" "bar"]  ## Define significant body names

i=0
for item in system.bodys[1:end-1]  ## Loop over each body
	i+=1
	s2*="{body_$i} "
	ss=sketch_prim(name="body_$i",type="box",rad=scale*0.03,loc=scale*item.location,opc=0.8)  ## Define default x3d string
	for j=1:length(tags)  ## Loop over each sig. name
		if occursin(tags[j],lowercase(item.name))  ## If the body name contains a sig. name, replace the default string

			if j==1 #"wheel"
				if occursin("bike",lowercase(item.name))
					ss=sketch_prim(name="body_$i",type="bwheel",loc=scale*item.location,axis=[0,1,0],opc=0.5)
				else
					ss=sketch_prim(name="body_$i",type="wheel",loc=scale*item.location,axis=[0,1,0],opc=0.5)
				end
			elseif j==2 #"chassis"
				ss=sketch_prim(name="body_$i",type="box",loc=scale*item.location,rad=scale*0.2,opc=0.5)
			else #"upright" etc
				ss=sketch_prim(name="body_$i",type="sphere",loc=scale*item.location,rad=scale*0.015)
			end
 		end
 	end
	s*=ss
end

i=0
for item in system.flex_points
	i+=1
	s2*="{flex_point_$i} "
	if (item.forces==3||item.forces==0) && (item.moments==3||item.moments==0)
		s*=sketch_prim(name="flex_point_$i",type="sphere",loc=scale*item.location,rad=scale*0.015)
	else
		s*=sketch_prim(name="flex_point_$i",type="cyl",loc=scale*item.location,axis=item.unit,rad=scale*0.015)
	end

	for j=1:2  ## For each body it attachs
		name=lowercase(system.bodys[item.body_number[j]].name)
		if name!="ground" && name!="chassis" && name!="wheel"  ## If it"s not the ground, chassis or wheel
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location-body_lcn)>0
				s2*="{flex_point_$(i)_$j} "
				s*=sketch_prim(name="flex_point_$(i)_$j",type="tube",top=scale*item.location,bot=scale*body_lcn,rad=scale*0.01)
			end
		end
	end
end

i=0
for item in system.rigid_points
	i+=1
	s2*="{rigid_point_$i} "
	if (item.forces==3||item.forces==0) && (item.moments==3||item.moments==0)
		s*=sketch_prim(name="rigid_point_$i",type="sphere",loc=scale*item.location,rad=scale*0.015)
	elseif item.forces==3 && item.moments==1
		s*=sketch_prim(name="rigid_point_$i",type="cyl",loc=scale*item.location,axis=item.nu[:,1],rad=scale*0.015)
		s*=sketch_prim(name="rigid_point_$(i)b",type="cyl",loc=scale*item.location,axis=item.nu[:,2],rad=scale*0.015)
		s2*="{rigid_point_$(i)b} "
	else
		s*=sketch_prim(name="rigid_point_$i",type="cyl",loc=scale*item.location,axis=item.unit,rad=scale*0.015)
	end

	for j=1:2  ## For each body it attachs
		name=lowercase(system.bodys[item.body_number[j]].name)
		if name!="ground" && name!="chassis" && name!="wheel"  ## If it's not the ground, chassis or wheel
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location-body_lcn)>0
				s2*="{rigid_point_$(i)_$j} "
				s*=sketch_prim(name="rigid_point_$(i)_$j",type="tube",top=scale*item.location,bot=scale*body_lcn,rad=scale*0.01)
			end
		end
	end
end

link_rad=0.01
i=0
for item in system.springs
i+=1
	len=item.length
	frac=2*link_rad/len

	s2*="{spring_t_$i} "
	s2*="{spring_b_$i} "
	s2*="{spring_i_$i} "
	s2*="{spring_o_$i} "

	s*=sketch_prim(name="spring_t_$i",type="sphere",loc=scale*item.location[1],rad=scale*2*link_rad)
	s*=sketch_prim(name="spring_b_$i",type="sphere",loc=scale*item.location[2],rad=scale*2*link_rad)

	temp1=(1-frac)*item.location[2]+frac*item.location[1]
	temp2=0.35*item.location[2]+0.65*item.location[1]

	s*=sketch_prim(name="spring_i_$i",type="tube",top=scale*temp1,bot=scale*temp2,rad=scale*2.5*link_rad)

	temp1=0.65*item.location[2]+0.35*item.location[1]
	temp2=frac*item.location[2]+(1-frac)*item.location[1]
	s*=sketch_prim(name="spring_o_$i",type="tube",top=scale*temp1,bot=scale*temp2,rad=scale*3*link_rad,opc=0.8)

#	s=[s sketch_prim(["spring_" num2str(i)],"cyl","top",scale*item.location[1],"bot",scale*item.location[2],"rad",0.25)]
	for j=1:2  ## For each body it attachs
		name=lowercase(system.bodys[item.body_number[j]].name)
		if name!="ground" && name!="chassis" && name!="wheel"  ## If it's not the ground, chassis or wheel
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location[j]-body_lcn)>0
				s2*="{spring_$(i)_$j} "
				s*=sketch_prim(name="spring_$(i)_$j",type="tube",top=scale*item.location[j],bot=scale*body_lcn,rad=scale*0.01)
			end
	#		if(~strcmp(system.bodys(system.links(i).body_number(j)).name,"ground"))  ## If it"s not the ground
	#			x3d=[x3d x3d_cyl([[joint_lcn-body_lcn] [000]],"rad",link_rad,"col",color)]  ## Draw the link mount
	#		end
		end
	end
end

i=0
for item in system.links
	i+=1
	s2*="{link_$i} "
	s2*="{link_t_$i} "
	s2*="{link_b_$i} "

	s*=sketch_prim(name="link_$i",type="tube",top=scale*item.location[1],bot=scale*item.location[2],rad=scale*0.01)
	s*=sketch_prim(name="link_t_$i",type="sphere",loc=scale*item.location[1],rad=scale*0.015)
	s*=sketch_prim(name="link_b_$i",type="sphere",loc=scale*item.location[2],rad=scale*0.015)

	for j=1:2  ## For each body it attachs

		if system.bodys[item.body_number[j]].name!="ground"  ## If it"s not the ground
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location[j]-body_lcn)>0
				s2*="{link_$(i)_$j} "
				s*=sketch_prim(name="link_$(i)_$j",type="tube",top=scale*item.location[j],bot=scale*body_lcn,rad=scale*0.01)
			end
	#		if(~strcmp(system.bodys(system.links(i).body_number(j)).name,"ground"))  ## If it"s not the ground
	#			x3d=[x3d x3d_cyl([[joint_lcn-body_lcn] [000]],"rad",link_rad,"col",color)]  ## Draw the link mount
	#		end
		end
	end
end

i=0
for item in system.actuators
	i+=1
	s2*="{actuator_$i} "
	s2*="{actuator_t_$i} "
	s2*="{actuator_b_$i} "

	s*=sketch_prim(name="actuator_$i",type="tube",top=scale*item.location[1],bot=scale*item.location[2],rad=scale*0.01)
	s*=sketch_prim(name="actuator_t_$i",type="sphere",loc=scale*item.location[1],rad=scale*0.015)
	s*=sketch_prim(name="actuator_b_$i",type="sphere",loc=scale*item.location[2],rad=scale*0.015)

	for j=1:2  ## For each body it attachs
		name=lowercase(system.bodys[item.body_number[j]].name)
		if name!="ground" && name!="chassis" && name!="wheel"  ## If it's not the ground, chassis or wheel
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location[j]-body_lcn)>0
				s2*="{actuator_$(i)_$j} "
				s*=sketch_prim(name="actuator_$(i)_$j",type="tube",top=scale*item.location[j],bot=scale*body_lcn,rad=scale*0.01)
			end
		end
	end
end

i=0
for item in system.sensors
	i+=1
	s2*="{sensor_$i} "
	s2*="{sensor_t_$i} "
	s2*="{sensor_b_$i} "
	
	s*=sketch_prim(name="sensor_$i",type="tube",top=scale*item.location[1],bot=scale*item.location[2],rad=scale*0.01)
	s*=sketch_prim(name="sensor_t_$i",type="sphere",loc=scale*item.location[1],rad=scale*0.015)
	s*=sketch_prim(name="sensor_b_$i",type="sphere",loc=scale*item.location[2],rad=scale*0.015)

	for j=1:2  ## For each body it attachs
		name=lowercase(system.bodys[item.body_number[j]].name)
		if name!="ground" && name!="chassis" && name!="wheel"  ## If it's not the ground, chassis or wheel
			body_lcn=system.bodys[item.body_number[j]].location  ## Find the body location
			if norm(item.location[j]-body_lcn)>0
				s2*="{sensor_$(i)_$j} "
				s*=sketch_prim(name="sensor_$(i)_$j",type="tube",top=scale*item.location[j],bot=scale*body_lcn,rad=scale*0.01)
			end
		end
	end

end


# for i=1:system.nbeams
# 	item=system.beams(i)
# 	s2*="{beam_" num2str(i) "} "]
# 	s=[s sketch_prim(["beam_" num2str(i)],"cyl","top",scale*item.location[1],"bot",scale*item.location[2],"rad",0.25)]
# end

i=0
for item in system.loads
	i+=1
	s2*="{load_$i} {load_$(i)_b}"
	dirn=item.force/norm(item.force)
	s*=sketch_prim(name="load_$i",type="tube",top=scale*(item.location+0.04*dirn),bot=scale*item.location,rad=scale*0.01)
	s*=sketch_prim(name="load_$(i)_b",type="cone",top=scale*(item.location+0.07*dirn),axis=dirn,rad=scale*0.015)
end

s2*="}\n"
sketch_save(dir_output,s*s2)


verbose && println("Sketching done.")

end



# s=["\\section{Geometry Diagram}\n The system geometry is shown in the following diagram.\n"]
# s=[s "\\begin{figure}[hbtp]\n"]  ## Insert the picture into a figure
# s=[s "\\begin{center}\n"]
# s=[s "\\input{sketch}\n"]
# s=[s "\\caption{Geometry}\n"]
# s=[s "\\label{geometry}\n"]
# s=[s "\\end{center}\n"]
# s=[s "\\end{figure}\n"]
# s=[s "\n\n"]
