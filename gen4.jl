using Images
using Colors
using LinearAlgebra
using Random

function edit_ini(r::Float64,g::Float64,b::Float64,f::Float64,t::Float64,a::Float64,d::Float64,N::Int;name::String="img")
   io = open("sample.ini", "r")
   str = read(io,String)
   close(io)
   str=replace(str, "Declare=G=0.2" => "Declare=G="*string(g))
   str=replace(str, "Declare=R=0.2" => "Declare=R="*string(r))
   str=replace(str, "Declare=B=0.2" => "Declare=B="*string(b))
   str=replace(str, "Declare=F=0.2" => "Declare=F="*string(f))
   str=replace(str, "Declare=T=0.2" => "Declare=T="*string(t))
   str=replace(str, "Declare=A=0.2" => "Declare=A="*string(a))
   str=replace(str, "Declare=D=0.2" => "Declare=D="*string(d))
   str=replace(str, "Declare=N=2" => "Declare=N="*string(N))
   str=replace(str, "+Osample.png" => "+O"*name*".png")
   open(name*".ini", "w") do io
      write(io, str)
   end
   return name*".ini"
end

function render(r::Float64,g::Float64,b::Float64,f::Float64,t::Float64,a::Float64,d::Float64,N::Int;name="img")
   name_ini = edit_ini(r,g,b,f,t,a,d,N,name=name)
   run(`povray $(name_ini)`)
   # run(`povray $(name_ini)`,wait=false)
   return nothing
end

render(0.3,0.2,0.1,0.4,0.4,0.1,0.1,2, name="aaa2")

function getcolors(path_img)
   img = load(path_img)
   ind = ((0:4)*100).+30
   return img[ind,ind]
end

function flatten(colors)
   arr = Float64[]
   for c in colors
      push!(arr,c.r)
      push!(arr,c.g)
      push!(arr,c.b)
   end
   return arr
end

function stamp(r::Float64,g::Float64,b::Float64,f::Float64,t::Float64,a::Float64,d::Float64,N::Int)
   name = "tmp_"*Random.randstring()
   render(r,g,b,f,t,a,d,N,name=name)
   fcol = flatten(getcolors(name*".png"))
   return fcol
end

stamp(0.2,0.2,0.2,0.2,0.2,0.2,0.2,1)
stamp(0.2,0.2,0.2,0.2,0.2,0.2,0.2,2)

rgbftab0 = rgbftab = [0.1,0.4,0.5,0.3,0.45,0.1,0.1]

X75 = stamp(rgbftab0...,2)
s0 = stamp(rgbftab...,1)

function step(X75,rgbftab)
   l = norm(X75-stamp(rgbftab...,1))
   rgbftab′ = rgbftab+randn(7)*l/6
   l′ = norm(X75-stamp(rgbftab′...,1))
   if l < l′
      return rgbftab
   else
      return rgbftab′
   end
end

for i in 1:10000
   global rgbftab = step(X75,rgbftab)
   print(norm(stamp(rgbftab...,1) - X75))
end

println(norm(stamp(rgbftab...,1) - X75))
println(norm(stamp(rgbftab0...,2) - X75))

rgbftab=[
   0.07118323632020382
   0.3590397103152907
   0.4695439465032427
   0.27409846934726556
   0.22422802896574762
   0.2023986063832864
   -0.02380611553265845
]





rgbftab0
