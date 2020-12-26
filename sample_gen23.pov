#declare Lng=-90;
#declare Lat=90;
#declare Tilt=0;
#declare Pers=0.05;
#declare Zoom=0.41;
#declare LookAt=<0,0,0>;

#macro SCS(lng,lat) <cos(radians(lat))*cos(radians(lng)),cos(radians(lat))*sin(radians(lng)),sin(radians(lat))> #end
#declare AspectRatio=image_width/image_height;
#declare Z=SCS(Lng,Lat);
#declare X=vaxis_rotate(<-sin(radians(Lng)),cos(radians(Lng)),0>,Z,Tilt);
#declare Y=vcross(Z,X);
#if(Pers)
    #declare Loc=LookAt+SCS(Lng,Lat)/(Zoom*Pers);
    camera{
        perspective
        location Loc
        right -2*X*sqrt(AspectRatio)/Zoom
        up 2*Y/(sqrt(AspectRatio)*Zoom)
        direction Z/(Zoom*Pers)
        sky Y
        look_at LookAt
    }
    light_source{
        Loc
        color rgb<1,0,1>
    }
#else
    #declare Loc=SCS(Lng,Lat);
    camera{
        orthographic
        location Loc*100
        right -2*X*sqrt(AspectRatio)/Zoom
        up 2*Y/(sqrt(AspectRatio)*Zoom)
        sky Y
        look_at LookAt
    }
    light_source{
        SCS(Lng,Lat)
        color rgb<1,0,1>
        parallel
        point_at 0
    }
#end
background{rgb<1.0,1.0,1.0>}

light_source{
    <3,3,5>
    color rgb<0.8,0,0>
}

light_source{
    <-3,3,5>
    color rgb<0,0.5,0>
}

light_source{
    <3,-3,5>
    color rgb<0,0,0.4>
}

// background
#declare SEED = seed(3);
#declare n = 2;
#declare i = -n;
#while (i <= n)
    #declare j = -n;
    #while (j <= n)
        sphere{<i,j,-1>,0.5 pigment{rgb<rand(SEED),rand(SEED),rand(SEED)>}}
        #declare j = j+1;
    #end
    #declare i = i+1;
#end

// overlap
#declare P = polygon{5,<-n-1,-n-1,0>,<n+1,-n-1,0>,<n+1,n+1,0>,<-n-1,n+1,0>,<-n-1,-n-1,0>
    texture{
        pigment{rgbft<R,G,B,F,T>}
        finish{
            ambient A
            diffuse D
        }
    }
}


/* #declare i = 0;
#while (i < N)
    object{P translate<0,0,i/100>}
    #declare i = i+1;
#end */

// overlap2
#declare S = sphere{0,3.3
    texture{
        pigment{rgbft<R,G,B,F,T>}
        finish{
            ambient A
            diffuse D
            /* phong 0.2 */
        }
    }
}


#declare i = 0;
#while (i < N)
    object{S scale (1+i/1000)}
    #declare i = i+1;
#end
