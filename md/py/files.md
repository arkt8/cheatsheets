
# Read

	with open('file', 'r') as f:
		x = f.read()

or

	f = open('file', 'r')
	line = f.readline()
	while line :
		print(line)
		line = f.readline()
	f.close()

	


