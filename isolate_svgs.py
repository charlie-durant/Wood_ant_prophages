#!/bin/python3
from bs4 import BeautifulSoup
import sys
import urllib.request
import re
import csv
import os

def get_from_local( filename ):
    return open( filename ).read();

def parse_website( website ):
    return BeautifulSoup( website, 'html.parser' )

def delete_group( soup, group, attr, attr_name ):
    for ele in soup.find_all( group, attrs={ attr:attr_name } ):
        ele.decompose()
    return soup

def delete_last_item( soup, group, attr, attr_name ):
    items = soup.find_all( group, attrs={ attr:attr_name } );
    items[ -1 ].decompose()
    return soup;

print( "Running" );
if __name__ == '__main__':
    path = sys.argv[ 1 ];
    print( path )
    soup = parse_website( get_from_local( path ) );
    soup = delete_group( soup, 'rect', 'id', re.compile( '.*minimap.*' ) );
    soup = delete_group( soup, 'g', 'class', re.compile( '.*minimap.*' ) );
    soup = delete_last_item( soup, 'line', 'class', 'centerline' );

    dirname = os.path.dirname( path );
    basename = os.path.basename( path );
    basename = os.path.splitext( basename );

    res_path = os.path.join( dirname, 'FIXED_' + basename[ 0 ] + basename[ 1 ] );
    print( "Result file : " + res_path );

    with open( res_path, 'w' ) as f:
        f.write( str( soup ) );
