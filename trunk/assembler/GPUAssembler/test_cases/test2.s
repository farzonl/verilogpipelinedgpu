movi.f r8 0.0f
loopcount -1
startloop
	loadidentity

	pushmatrix

	vcompmovi v1 1 -1.5f
	vcompmovi v1 2 -1.0f
	translate v1

	pushmatrix

	vcompmov v0 0 r8
	vcompmovi v0 1 0.0f
	vcompmovi v0 2 0.0f
	vcompmovi v0 3 1.0f
	rotate v0

	startprimitive 4

		vcompmovi v2 0 255
		vcompmovi v2 1 0
		vcompmovi v2 2 0
		color v2

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 0.0f
		setvertex v3
		
		vcompmovi v2 0 0
		vcompmovi v2 1 255
		vcompmovi v2 2 0
		color v2

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 0.0f
		setvertex v3
		
		vcompmovi v2 0 0
		vcompmovi v2 1 0
		vcompmovi v2 2 255
		color v2

		vcompmovi v3 1 0.0f
		vcompmovi v3 2 -1.0f
		vcompmovi v3 3 0.0f
		setvertex v3		

	endprimitive

	popmatrix

	vcompmovi v1 1 0.0f
	vcompmovi v1 2 2.0f
	translate v1
	
	vcompmov v0 0 r8
	vcompmovi v0 1 0.0f
	vcompmovi v0 2 0.0f
	vcompmovi v0 3 1.0f
	rotate v0

	startprimitive 7

		vcompmovi v2 0 255
		vcompmovi v2 1 255
		vcompmovi v2 2 255
		color v2

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 0.5f
		vcompmovi v3 3 1.0f
		setvertex v3

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 0.5f
		vcompmovi v3 3 1.0f
		setvertex v3

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 -0.5f
		vcompmovi v3 3 1.0f
		setvertex v3		
		
		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 -0.5f
		vcompmovi v3 3 1.0f
		setvertex v3		

	endprimitive

	addi.f r8 r8 1.0f	

	popmatrix

	loadidentity

	pushmatrix

	vcompmovi v1 1 1.5f
	vcompmovi v1 2 0.0f
	translate v1

	pushmatrix

	vcompmovi v5 1 1.2f
	vcompmovi v5 2 1.2f
	scale v5

	pushmatrix

	vcompmovi v5 1 1.2f
	vcompmovi v5 2 1.2f
	scale v5

	startprimitive 4

		vcompmovi v2 0 255
		vcompmovi v2 1 0
		vcompmovi v2 2 0
		color v2

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 2.0f
		setvertex v3

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 2.0f
		setvertex v3

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 -1.0f
		vcompmovi v3 3 2.0f
		setvertex v3		

	endprimitive

	popmatrix

	startprimitive 4

		vcompmovi v2 0 0
		vcompmovi v2 1 255
		vcompmovi v2 2 0
		color v2

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 1.0f
		setvertex v3

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 1.0f
		setvertex v3

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 -1.0f
		vcompmovi v3 3 1.0f
		setvertex v3		

	endprimitive

	popmatrix

	startprimitive 4

		vcompmovi v2 0 0
		vcompmovi v2 1 0
		vcompmovi v2 2 255
		color v2

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 0.0f
		setvertex v3

		vcompmovi v3 1 1.0f
		vcompmovi v3 2 1.0f
		vcompmovi v3 3 0.0f
		setvertex v3

		vcompmovi v3 1 -1.0f
		vcompmovi v3 2 -1.0f
		vcompmovi v3 3 0.0f
		setvertex v3		

	endprimitive

	popmatrix

	draw
endloop
