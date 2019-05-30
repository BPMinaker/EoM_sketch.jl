module EoM_sketch

using LinearAlgebra

import EoM

export draw_sketch

include("sketch_save.jl")
include("sketch_prim.jl")
include("draw_sketch.jl")

end # module
