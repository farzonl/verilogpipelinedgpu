movi.f r8 0.0f
loopcount -1
startloop
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
