""" Ht_term(t, u, n; PI=π)

    Returns the value of the nth term of the infinite series, Φ(u)*exp(t*u^2). (See http://michaelnielsen.org/polymath1/index.php?title=De_Bruijn-Newman_constant). This is written separately from the corresponding term of Φ(u) itself to avoid numerical problems with large positive and negative exponents.
    """
function Ht_term{T1<:Real, T2<:Real}(t::T1, u::T2, n::Int; PI=convert(promote_type(T1,T2,Float64),π))
    x = t*u^2-PI*n^2*exp(4*u)
    return (2*PI^2*n^4*exp(9*u+x)-3*PI*n^2*exp(5*u+x))
end

""" Ht_integrand(t, u, z; nmax=100, PI=π)
    
    Returns a partial summation of the infinite series, Φ(u)*exp(t*u^2), to n_max (default 100) terms.
    """
function Ht_integrand{T1<:Real, T2<:Real, T3<:Number}(t::T1, u::T2, z::T3; n_max=100,
                                                   PI=convert(promote_type(T1,T2,typeof(real(z)),typeof(imag(z)),Float64),π))
    ans = convert(promote_type(Complex{T1},Complex{T2},T3),0)
    for n in 1:n_max
        ans += Ht_term(t,u,n,PI=PI)
    end
    return ans*cos(z*u)
end

""" Ht(t, z; n_max=100, PI=π)
    
    Returns a 2-tuple of an approximate value of Ht(z) and an estimated error of approximation. Ht(z) is the integral from 0 to ∞ of Φ(u)*exp(t*u^2)*cos(uz), where the first two factors are approximated by truncated series of n_max (default 100) terms. (See http://michaelnielsen.org/polymath1/index.php?title=De_Bruijn-Newman_constant).
    """
function Ht{T1<:Real,T2<:Number}(t::T1, z::T2; n_max::Int=100, upper_limit::T1=10.0, abstol=eps(T1), maxevals=10^7,
                                 PI=convert(promote_type(T1,typeof(real(z)),typeof(imag(z)),Float64),π))
    return quadgk((u)-> Ht_integrand(t,u,z; n_max=n_max, PI=PI), 0.0, upper_limit, abstol=abstol, maxevals=maxevals)
end

""" ζ(z)

    Alias for SpecialFunctions implementation, `zeta`, of Riemann's ζ function.
    """
ζ = zeta

""" Γ(z)

    Alias for SpecialFunctions implemention, `gamma` of the gamma function.
    """
Γ = gamma

""" ξ(s)

    Implementation of the Riemann xi function, ξ, using Riemann's zeta, ζ, and the gamma function, Γ, as implemented in Julia's SpecialFunctions package.
    """
function ξ{T<:Number}(s::T; PI=convert(promote_type(typeof(real(s)), typeof(imag(s), Float64)),π))
    return (s/2)*(s-1)*PI^(s/2)*Γ(s/2)*ζ(s)
end

""" H0(z)

    Implementation of H0(z) as (1/8)*ξ(1/2+z*im/2). See http://michaelnielsen.org/polymath1/index.php?title=De_Bruijn-Newman_constant#.5Bmath.5Dt.3D0.5B.2Fmath.5D. Compare with Ht(0.0,z).
    """
function H0{T<:Number}(z::T; PI=convert(promote_type(typeof(real(z)), typeof(imag(z), Float64)),π))
    return  ξ((1+z*im)/2)/8
end
    
