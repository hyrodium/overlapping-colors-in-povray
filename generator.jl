using Images
using Colors
using LinearAlgebra

function edit_ini(r::Float64,g::Float64,b::Float64,f::Float64,t::Float64,a::Float64,N::Int)
   io = open("sample.ini", "r")
   str = read(io,String)
   close(io)
   str=replace(str, "Declare=G=0.2" => "Declare=G="*string(g))
   str=replace(str, "Declare=R=0.2" => "Declare=R="*string(r))
   str=replace(str, "Declare=B=0.2" => "Declare=B="*string(b))
   str=replace(str, "Declare=F=0.2" => "Declare=F="*string(f))
   str=replace(str, "Declare=T=0.2" => "Declare=T="*string(t))
   str=replace(str, "Declare=A=0.2" => "Declare=A="*string(a))
   str=replace(str, "Declare=N=2" => "Declare=N="*string(N))
   open("sample_modified.ini", "w") do io
      write(io, str)
   end
   return nothing
end

function render(r::Float64,g::Float64,b::Float64,f::Float64,t::Float64,a::Float64,N::Int)
   edit_ini(r,g,b,f,t,a,N)
   run(`povray sample_modified.ini`)
   return nothing
end

function getcolors(path_img)
   img = load(path_img)
   ind = ((0:4)*100).+30
   return img[ind,ind]
end

path_img = "/home/hyrodium/Git/overlapping-colors-in-povray/sample.png"
colors = getcolors(path_img)

function flatten(colors)
   arr = Float64[]
   for c in colors
      push!(arr,c.r)
      push!(arr,c.g)
      push!(arr,c.b)
   end
   return arr
end

function generate(M;gcols = Float64[], fcols = Float64[])
   for i in 1:M
      r,g,b,f,t,a = gcol = rand(6) # given colors
      render(r,g,b,f,t,a,1)
      path_img = "/home/hyrodium/Git/overlapping-colors-in-povray/sample.png"
      colors = getcolors(path_img)
      fcol = flatten(colors) # flatten colors

      gcols = vcat(gcols, gcol)
      fcols = vcat(fcols, fcol)
   end
   return gcols,fcols
end

@time gcols, fcols = generate(1000,gcols=gcols,fcols=fcols)

M = length(gcols)÷6

Gcols = reshape(gcols, 6, M)
Fcols = reshape(fcols, 75, M)


r,g,b,f,t,a = gcol_ = rand(6) # given colors
render(r,g,b,f,t,a,2)
path_img = "/home/hyrodium/Git/overlapping-colors-in-povray/sample.png"
colors = getcolors(path_img)
fcol = flatten(colors) # flatten colors


Δ = Fcols .- fcol
L = [norm(Δ[:,i]) for i in 1:M]
minimum(L)
I = argmin(L)

nn=3

ind = sortperm(L)[1:nn]
L[ind]

α = [1/L[i] for i in ind]
C = sum(α[i]*Gcols[:,ind[i]] for i in 1:nn)/sum(α)


r,g,b,f,t,a = C
render(r,g,b,f,t,a,1)


##
using JLD


save("10000.jld", "gcols", gcols, "fcols", fcols)

load("10000.jld")
