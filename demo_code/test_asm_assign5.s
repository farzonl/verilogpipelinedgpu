movi.f r8 0.0f
movi.f r9 0.0f
loopcount 10	
startloop
pushmatrix
loadidentity
vcompmovi v1 1 -1.5f
vcompmovi v1 2 0.0f
translate v1
vcompmov v0 0 r8
vcompmovi v0 1 0.0f
vcompmovi v0 2 0.0f
vcompmovi v0 3 1.0f
rotate v0
startprimitive 4
vcompmovi v2 0 255
vcompmovi v2 1 255
vcompmovi v2 2 255
color v2
vcompmovi v3 1 -1.0f
vcompmovi v3 2 1.0f
vcompmovi v3 3 1.0f
setvertex v3
vcompmovi v3 1 1.0f
vcompmovi v3 2 1.0f
vcompmovi v3 3 1.0f
setvertex v3
vcompmovi v3 1 0.0f
vcompmovi v3 2 -1.0f
vcompmovi v3 3 1.0f
setvertex v3		
endprimitive
addi.f r8 r8 20.0f	
popmatrix	

pushmatrix
loadidentity
vcompmovi v8 1 0.0f
vcompmovi v8 2 0.5f
translate v8
vcompmov v9 0 r9
vcompmovi v9 1 0.0f
vcompmovi v9 2 0.0f
vcompmovi v9 3 -1.0f
rotate v9
startprimitive 7
vcompmovi v10 0 0
vcompmovi v10 1 255
vcompmovi v10 2 0
color v10
vcompmovi v11 1 0.0f
vcompmovi v11 2 0.0f
vcompmovi v11 3 -1.0f
setvertex v11
vcompmovi v11 1 0.0f
vcompmovi v11 2 1.0f
vcompmovi v11 3 -1.0f
setvertex v11
vcompmovi v11 1 1.0f
vcompmovi v11 2 1.0f
vcompmovi v11 3 -1.0f
setvertex v11		
vcompmovi v11 1 1.0f
vcompmovi v11 2 0.0f
vcompmovi v11 3 -1.0f
setvertex v11	
endprimitive
addi.f r9 r9 20.0f
popmatrix	

draw
endloop
