module Streamline



abstract type AbstractHardware end

hardmodel(h::AbstractHardware) = h.model
hardtag(h::AbstractHardware) = h.tag
harddescr(h::AbstractHardware) = h.descr

using Hotwire
include("hardware.jl")
include("bridge.jl")
include("frame.jl")
include("probes.jl")
end
