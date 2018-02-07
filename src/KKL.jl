# ϕ ψ π Φ

function ψ(x; n_max=100)
    ans = 0.0
    for n in 1:n_max
        ans += exp(-n^2*π*x)
    end
    return(ans)
end

function ψx(x; n_max=100)
    ans = 0.0
    for n in 1:n_max
        ans += -exp(-n^2*π*x+2*log(n)+log(π))
    end
    return(ans)
end

function ψxx(x; n_max=100)
    ans = 0.0
    for n in 1:n_max
        ans += exp(-n^2*π*x+4*log(n)+2*log(π))
    end
    return(ans)
end

function ϕ4test(x;n_max=100)
    a=3*ψx(x)
    b=2*x*ψxx(x)
    if -a > b
        return x^(1.25)*b*(1+a/b)
    elseif b > -a
        return x^(1.25)*a*(b/a+1)
    else 
        return x^(1.25)*(a+b)
    end
end

function ϕ(x; n_max=100)
    a=b=d=0.0
    for n in 1:n_max
        y = π*n^2
        d = y*exp(-y*x)
        a += d
        b += y*d
    end
    if d/a > 1e-6 || d/b > 1e-6
        warn("The partial sum has not converged. n_max should be increased")
    end
    a *= -3
    b *= 2*x
    if -a > b
        ans = x^(1.25)*b*(1+a/b)
    elseif b > -a
        ans = x^(1.25)*a*(b/a+1)
    else 
        ans = x^(1.25)*(a+b)
    end
    return ans
end

function Ξλ_integrand(λ,u,z;n_max=100)
    2*exp(λ*u^2+log(ΦKKL(u,n_max=n_max)))*cos(u*z)
end

function Ξλ(λ,z;n_max=100, upper_limit = 10.0)
    return quadgk((u)-> Ξλ_integrand(λ,u,z;n_max=n_max), 0.0, upper_limit, abstol=eps(λ), maxevals=10^7)
end

function ΦKKL(u;n_max=100)
    return 2*ϕ(exp(2*u),n_max=n_max)
end