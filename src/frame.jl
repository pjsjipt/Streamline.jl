import Polynomials: Polynomial

export pressure, temperature, HWFrame
mutable struct HWFrame
    cal_t::Polynomial{Float64,:T}
    cal_p::Polynomial{Float64,:P}
end

Hotwire.pressure(fr::HWFrame, P) = fr.cal_p(P*1000)
Hotwire.temperature(fr::HWFrame, T) = fr.cal_t(T)
