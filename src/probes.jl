# DANTEC probes and hardware
export dantec1d, dantec2d, dantec3d
import Statistics: mean
import StaticArrays: SVector

function dantec1d(config, calibr, modelfun, fitfun; idx=1,
                  model="", tag="", alpha=0.4e-2, fluid=AIR,
                  T0=nothing, br=1/20, probe=nothing, support=nothing, cable=nothing,
                  modelparams...)
    hconfig = config[idx,:]
    
    bridge = StreamlineBridge(hconfig, model=model, tag=tag, T0=T0, br=br)

    # Let's calculate the operating temperature
    Rdecade   = bridge.Rdecade
    Rprobe    = bridge.Rprobe
    R0        = bridge.R0

    ΔR =  (Rdecade * br  - Rprobe)
    Rw = R0 + ΔR

    if isnothing(T0)
        T0 = bridge.Tr + 273.15  # Resistor reference temperature in K
    end
    
    R = Resistor(R=R0, a=alpha, T=T0)
    Tw = temperature(R, Rw)
    
    Tc = calibr[:,3] .+ 273.15  # Calibration temperature (K)
    Pc = calibr[:,4] .* 1000    # Calibration pressure (Pa)
    Ec    = calibr[:,2]
    Uc   = calibr[:,1]
    
    # Mean temperature and pressure - they will be used
    Tm = mean(Tc)
    Pm = mean(Pc)

    sensor = CTASensor(modelfun, R, Rw, Ec, Uc, Tc, Pc, fitfun; fluid=fluid,
                       modelparams...)
    
    
    return Probe1d(sensor, (hconfig, calibr, probe, support, cable, bridge))
end


function dantec2d(config, calibr, modelfun, fitfun, k²; idx=[1,2],
                  model="", tag="", alpha=0.4e-2, fluid=AIR,
                  T0=nothing, br=1/20, probe=nothing, support=nothing, cable=nothing,
                  modelparams...)
    
    bridge = [StreamlineBridge(hconfig[i,:], model=model, tag=tag, T0=T0, br=br)
              for i in idx]
    if isnothing(T0)
        T0x = [b.Tr for b in bridge] .+ 273.15
        T0 = mean(T0x)
    end
    
    Rdecade   = [b.Rdecade for b in bridge]
    Rprobe    = [b.Rprobe for b in bridge]
    R0        = [b.R0 for b in bridge]
    

    ΔR =  (Rdecade .* br  .- Rprobe)
    Rw = R0 .+ ΔR


    R = [Resistor(R=R0[i], a=alpha, T=T0) for i in eachindex(bridge)]
    Tw = temperature.(R, Rw)

    Tc = calibr[:,4] .+ 273.15  # Calibration temperature (K)
    Pc = calibr[:,5] .* 1000    # Calibration pressure (Pa)
    E1 = calibr[:,2]
    E2 = calibr[:,3]
    Uc = calibr[:,1]

    
    Tm = mean(Tc)
    Pm = mean(Pc)

    sensor = (CTASensor(modelfun, R[1], Rw[1], E1, Uc, Tc, Pc, fitfun;
                        fluid=fluid, modelparams...),
              CTASensor(modelfun, R[2], Rw[2], E2, Uc, Tc, Pc, fitfun;
                        fluid=fluid, modelparams...))
    return Probe2d(sensor, (config[idx,:], calibr, probe, support, cable, bridge))
end


function dantec3d(config, calibr, modelfun, fitfun, dircal=nothing; idx=1:3,
                  k2 = fill(0.04,3), h2 = fill(1.2, 3),
                  ih=[3,1,2], idircal=1, cosang=Hotwire.cosϕ_dantec,
                  model="", tag="", alpha=0.4e-2, fluid=AIR,T0=nothing,
                  br=1/20, probe=nothing, support=nothing, cable=nothing,
                  caltheta=30.0, modelparams...)
    bridge = [StreamlineBridge(config[i,:], model=model, tag=tag, T0=T0, br=br)
              for i in idx]
    if isnothing(T0)
        T0x = [b.Tr for b in bridge] .+ 273.15
        T0 = mean(T0x)
    end
    
    
    Rdecade   = [b.Rdecade for b in bridge]
    Rprobe    = [b.Rprobe for b in bridge]
    R0        = [b.R0 for b in bridge]
    
    ΔR =  (Rdecade .* br  .- Rprobe)
    Rw = R0 .+ ΔR

    println(length(bridge))
    R = [Resistor(R=R0[i], a=alpha, T=T0) for i in eachindex(bridge)]
    println(R)
    Tw = temperature.(R, Rw)

    Tc  = calibr[:,5] .+ 273.15  # Calibration temperature (K)
    Pc  = calibr[:,6] .* 1000    # Calibration pressure (Pa)
    E1  = calibr[:,2]
    E2  = calibr[:,3]
    E3  = calibr[:,4]
    Uc  = calibr[:,1]
    
    Tm = mean(Tc)
    Pm = mean(Pc)

    sensor = (CTASensor(modelfun, R[1], Rw[1], E1, Uc, Tc, Pc, fitfun;
                        fluid=fluid, modelparams...),
              CTASensor(modelfun, R[2], Rw[2], E2, Uc, Tc, Pc, fitfun;
                        fluid=fluid, modelparams...),
              CTASensor(modelfun, R[3], Rw[3], E3, Uc, Tc, Pc, fitfun;
                        fluid=fluid, modelparams...))
    if isnothing(dircal)
        k² = SVector{3}(k2)
        h² = SVector{3}(h2)
    else
        Ucx = dircal[:,5]
        Uc1 = [sensor[1](dircal[i,2], T=Tm, P=Pm) for i in eachindex(Ucx)]
        Uc2 = [sensor[2](dircal[i,3], T=Tm, P=Pm) for i in eachindex(Ucx)]
        Uc3 = [sensor[3](dircal[i,4], T=Tm, P=Pm) for i in eachindex(Ucx)]
        k², h² = dircalibr(cosang, idircal, Ucx,
                           Uc1, Uc2, Uc3, dircal[:,1], caltheta)
    end
    return Probe3d(sensor, SVector{3}(k²), SVector{3}(h²), 
                   (config[idx,:], calibr, probe, support, cable, bridge);
                   ih=ih, idircal=idircal, cosang=cosang)
    
    
end
