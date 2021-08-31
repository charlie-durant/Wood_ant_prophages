import svgutils.transform as st
import sys

if __name__ == '__main__':
    # Setup figure
    fig = st.SVGFigure()

    # Setup iteration and offset
    i = 1;
    offset = 150; # how far down the image is offset

    # For each filename provided, add it to the figure at a fixed offset
    while i < len( sys.argv ):
        svg = st.fromfile( sys.argv[ i ] );
        root = svg.getroot()
        root.moveto( 0, (i - 1 ) * offset );
        fig.append( root )
        i = i + 1;
    # save figure
    fig.save( "res.svg" );


