
struct HWCable <: AbstractHardware
    "Model/serial/etc of the cable"
    model::String
    "Tag"
    tag::String
    "Cable description"
    descr::String
    "Length of the cable"
    L::Float64
    "Resistance of the cable"
    R::Float64
    "Impedance of the cable"
    Z::Float64
    "Number of connectors"
    connectors::Int
    "Cable compensation"
    cablecomp::String
end

HWCable(;L=4.0, R=0.2, Z=50.0, model="A1863", tag="", descr="BNC/BNC",
        conectors=2, cablecomp="5 m") = HWCable(model, descr, L, R, Z,
                                                connectors, cablecomp)


impedance(c::HWCable) = c.impedance

resistance(c::HWCable) = resistance(c.R)
resistance(c::HWCable, T) = resistance(c.R, T)

cable_A1863(; model="A1863", L=4.0, R=0.2, Z=50.0, descr="BNC/BNC", kw...) =
    HWCable(model=model, L=L, R=R, Z=Z, descr=descr, kw...)
cable_A1865(; model="A1865", L=10.0, R=0.5, Z=50.0, descr="BNC/BNC", kw...) =
    HWCable(model=model, L=L, R=R, Z=Z, descr=descr, kw...)
cable_A1866(; model="A1866", L=20.0, R=1.0, Z=50.0, descr="BNC/BNC", kw...) =
    HWCable(model=model, L=L, R=R, Z=Z, descr=descr, kw...)

struct HWSupport <: AbstractHardware
    "Support model"
    model::String
    "Support tag (storage and control)"
    tag::String
    "Description"
    descr::String
    "Support diamenter (mm)"
    d::Float64
    "Support length (mm)"
    L::Float64
    "Support cable length(mm)"
    Lc::Float64
    "Number of contacts"
    ncontacts::Int
    "Nominal resistance of the support"
    R::Float64
    "Recommended shorting"
    Rshort::Float64
    
end


"""
    `HWSupport(;model="55H21", tag="", descr="1D straight - long", R=0.44,
                     D=4.0, L=235.0, Lc=765, ncontacts=1, Rshort=0.0)`

Stores information about Probe support. Noty strictly necessary but 
could be useful for future reference

"""
HWSupport(; model="", tag="", descr="", d=4.0, L=235.0, Lc=765,
          ncontacts=1, R=0.44, Rshort=0.0) =
              HWSupport(model, tag, descr, d, L, Lc, ncontacts, R, Rshort)

support_builtin(n=1) = HWSupport(; model="", tag="", descr="built-in",
                            d=0, L=0, Lc=0, ncontacts=n,
                            R=0.0, Rshort=0.0)
support_55H20() = HWSupport(; model="55H20", tag="", descr="1D Straight - short",
                            d=4.0, L=29.0, Lc=971, ncontacts=1,
                            R=0.44, Rshort=0.0)
support_55H21() = HWSupport(; model="55H21", tag="", descr="1D Straight - long",
                            d=4.0, L=235.0, Lc=765, ncontacts=1,
                            R=0.44, Rshort=0.0)
support_55H22() = HWSupport(; model="55H22", tag="", descr="1D 90 deg",
                            d=4.0, L=270.0, Lc=765, ncontacts=1,
                            R=0.44, Rshort=0.0)

support_55H24() = HWSupport(; model="55H24", tag="", descr="2D Straight - short",
                            d=6.0, L=36.0, Lc=964, ncontacts=2,
                            R=0.44, Rshort=0.0)
support_55H25() = HWSupport(; model="55H25", tag="", descr="2D Straight - long",
                            d=6.0, L=235.0, Lc=750, ncontacts=2,
                            R=0.44, Rshort=0.0)
support_55H26() = HWSupport(; model="55H26", tag="", descr="2D 90 deg",
                            d=6.0, L=235.0, Lc=750, ncontacts=2,
                            R=0.44, Rshort=0.0)

support_55H27() = HWSupport(; model="55H27", tag="", descr="3D Straight",
                            d=6.0, L=235.0, Lc=720, ncontacts=3,
                            R=0.44, Rshort=0.0)

resistance(c::HWSupport) = resistance(c.R)
resistance(c::HWSupport, T) = resistance(c.R, T)
