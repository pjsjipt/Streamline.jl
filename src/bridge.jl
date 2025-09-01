
abstract type AbstractHardware end

struct StreamlineBridge <: AbstractHardware
    "Anemometer system model"
    model::String
    "Anemometer tag"
    tag::String
    "Overheat ratio"
    overheat::Float64
    "Decade resistance"
    Rdecade::Float64
    "Probe resistance (Ω)"
    Rprobe::Float64
    "Cable resistance (Ω)"
    Rcable::Float64
    "Sensor resistance (Ω)"
    R0::Float64
    "Reference temperature (K)"
    Tr::Float64
    "Ambient Temperature (K)"
    Ta::Float64
    "Bridge top voltage (V)"
    brdgtop::Float64
    "Low pass filter (kHz)"
    lpfilt::Float64
    "High pass filter (kHz)"
    hpfilt::Float64
    "Signal offset (V)"
    offset::Float64
    "Signal gain"
    gain::Float64
    "Bridge resistance ratio"
    bridgeratio::Float64
    "Bridge filter"
    filter::Int16
    "Bridge gain"
    bgain::Int16
    "Cable compensation"
    cablecomp::Int16
    "Specific bridge type"
    type::Int16
end


"""
`StreamlineBridge(config; model="", tag="", T0=nothing, br=1/20)`

Information about hotwire hardware system.

"""
function StreamlineBridge(config ;model="Streamline", tag="", T0=nothing, br=1/20)
    btype = round(Int16,config[1])
    overheat = config[2]
    Rdecade = config[3]
    Rprobe = config[4]
    Rcable = config[5]
    R0 = config[6]
    if !isnothing(T0)
        Tr = T0
        Ta = T0
    else
        Tr = config[7]
        Ta = config[8]
    end
    brdgtop = config[9]
    lpfilt = config[10]
    hpfilt = config[11]
    offset = config[12]
    gain = config[13]
    bridgeratio = br
    filter = round(Int16,config[14])
    bgain =  round(Int16,config[15])
    cablecomp =  round(Int16,config[16])

    StreamlineBridge(model, tag, overheat, Rdecade, Rprobe, Rcable, R0, Tr, Ta,
                     brdgtop, lpfilt, hpfilt, offset, gain, bridgeratio,
                     filter, bgain, cablecomp, btype)
end
    
