#!/bin/python3
from bs4 import BeautifulSoup
import sys
import urllib.request
import re
import csv
import os

def get_website( url ):
    user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
    headers={'User-Agent':user_agent,}

    request=urllib.request.Request(url,None,headers) #The assembled request
    response = urllib.request.urlopen(request)
    return response.read()

def get_from_local( filename ):
    return open( filename ).read();

def get_div( soup, div_class ):
    return soup.find( 'div', attrs={'id':div_class } );

def get_table( soup, table_class ):
    return soup.find( 'table', attrs={'class':table_class } );


def parse_website( website ):
    return BeautifulSoup( website, 'html.parser' )

def get_header( table ):
    return table.find( 'thead');

def get_table_body( table ):
    return table.find( 'tbody' );

def get_data_from_row( row ):
    cols = row.find_all( 'td' );
    values = []
    for col in cols:
        if( col.get( 'colspan' ) is not None ):
            for i in range( 0, int( col.get( 'colspan' ) ) ):
                values.append( col.text.strip() );
        else:
            values.append( col.text.strip() );

    # Strip out any empty entries
    return values;

def get_data_from_table_body( table_body ):
    data = []
    # Only get rows that have class attr. This relates to incompelte etc.
    rows = table_body.find_all( 'tr' );
    for row in rows:
        data.append( get_data_from_row( row ) )
    return data;

def get_header_values( table_head ):
    row = table_head.find( 'tr' );
    values = []
    cols = row.find_all('th' );
    for col in cols:
        if( col.get( 'colspan' ) is not None ):
            for i in range( 0, int( col.get( 'colspan' ) ) ):
                values.append( col.text.strip() );
        else:
            values.append( col.text.strip() );

    # Strip out any empty entries
    return [ ele for ele in values if ele ];

def write_to_csv( filename, header, data ):
    with open( filename, 'w', newline='' ) as csvFile:
        writer = csv.writer( csvFile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        writer.writerow( header );
        for row in data:
            writer.writerow( row );


print( "Running" );
if __name__ == '__main__':
    urls = sys.argv[ 1 ];
    urls = urls.split( ',' );
    print( "Isolates : " );
    print( urls );
    for i in range( 0, len( urls ) ):
        path = os.path.join( "antiSMASH", "Isolate_"+urls[ i ], "index.html" )
        print( path )
        soup = parse_website( get_from_local( path ) );
        div = get_div( soup, 'compact-record-table' );
        table = get_table( div, 'region-table' );
        headers = get_header_values( get_header( table ) );
        print( headers )
        body = get_table_body( table );
        data = get_data_from_table_body( body );
        print( data );
        write_to_csv( 'Isolate_' + urls[ i ] + '.csv', headers, data )
