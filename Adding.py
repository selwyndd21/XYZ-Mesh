#!/usr/bin/python
import sys
import numpy as np
import os.path

print "Py: Start Python script"
print "Py: Python Input: %s    Output: %s." %( sys.argv[1], sys.argv[2] )
print "Py: core size: %d x %d." %( int(sys.argv[3]), int(sys.argv[4]) )
RawData = np.loadtxt( sys.argv[1] , skiprows=0)

print 'Py: Input Data format: {} (time step, location)'.format(RawData.shape)
print "Py: input data is"
print RawData

coremap=np.zeros(( RawData.size/RawData[0].size - 2, int(sys.argv[3]), int(sys.argv[4])  ))
print 'Py: Output Data format: {} (time step, x, y)'.format(coremap.shape)

# XYZ mapping data
print "Py: mapping XYZ data"
for time in range( 0, RawData.size/RawData[0].size -2 ):
    for i in range( 0, RawData[0].size ):
        print "Py:   coordinate (% 2d,% 2d) at time %4d has value %5.1f" \
            %(RawData[0][i]/4, (RawData[1][i]-1)/4, time, RawData[time+2][i])
        coremap[ time ][ int( (RawData[1][i]-1)/4 ) ][ int(RawData[0][i]/4) ] \
            = RawData[ time+2 ][ i ]
#print coremap[0]

# adding core coordinate
print "Py: Adding XY core coordinate"
for time in range( 0, RawData.size/RawData[0].size -2 ):
    coremap[ time ][ 0 ][ 0 ] = time
    print "Py:   produse XY-Lables for time %d" %(time)
    # X-Lable
    for i in range( 1, coremap[0][0].size ):
        coremap[ time ][ 0 ][ i ] = (i)*4
    # Y-Lable
    for i in range( 1, coremap[0].size/coremap[0][0].size):
        coremap[ time ][ i ][ 0 ] = (i)*4+1

print "Py: Writing into output file: %stotal.txt" %( sys.argv[2] )
with file('%stotal.txt' %( sys.argv[2] ), 'w') as outfile:
    # header for each 2D array
    # line starting with "#" will be ignored by numpy.loadtxt
    outfile.write( '# Array shape: {0}\n'.format(coremap.shape) )

    # Iterating through a ndimensional array produces slices along
    # the last axis. This is equivalent to data[i,:,:] in this case
    time=0
    for data_slice in coremap:

        # Writing a break to indicate different slices...
        outfile.write('# Time % 4d\n' %(time) )

        # The formatting string indicates that I'm writing out
        # the values in left-justified columns 7 characters in width
        # with 2 decimal places.  
        np.savetxt(outfile, data_slice, fmt='% 5.1f')

        time=time+1

print "Py: End Python script"


