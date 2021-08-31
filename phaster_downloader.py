#!/bin/python3
from bs4 import BeautifulSoup
import sys
import urllib.request
import re
import csv

def get_website( url ):
    user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
    headers={'User-Agent':user_agent,}

    request=urllib.request.Request(url,None,headers) #The assembled request
    response = urllib.request.urlopen(request)
    return response.read()

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
    cols = [ ele.text.strip() for ele in cols ];
    # Strip out any empty entries
    return [ ele for ele in cols if ele ];

def get_data_from_table_body( table_body ):
    data = []
    # Only get rows that have class attr. This relates to incompelte etc.
    rows = table_body.find_all( 'tr', {"class":re.compile(".*")} );
    for row in rows:
        data.append( get_data_from_row( row ) )
    return data;

def get_header_values( table_head ):
    row = table_head.find( 'tr' );
    cols = row.find_all('th' );
    cols = [ ele.text.strip() for ele in cols ];
    # Strip out any empty entries
    return [ ele for ele in cols if ele ];

def append_isolate_title_to_header( header ):
    header.append( 'Isolate' )
    return header

def append_isolate_to_rows( data, isolate ):
    ret_data = []
    for row in data:
        row.append( isolate );
        ret_data.append( row );

    return ret_data



def write_to_csv( filename, header, data ):
    with open( filename, 'w', newline='' ) as csvFile:
        writer = csv.writer( csvFile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        writer.writerow( header );
        for row in data:
            writer.writerow( row );


print( "Running" );
if __name__ == '__main__':
    url = sys.argv [ 1 ];
    print( "Website to scrape : " + url );
    website_data = get_website( url );
    print( "Got the data!" );
    soup = parse_website( website_data );
    print( "Parsed the website" );
    table = get_table( soup, 'result-table');
    print( "Got table" );
    table_header = get_header( table );
    print( "Got header" );
    table_body = get_table_body( table );
    print( "Got body" );
    data = get_data_from_table_body( table_body );
    header = get_header_values( table_header );
    print( header )
    print( data )


    # Filename is second argument provided
    # If it doesnt exist, make one from the URL
    if( len( sys.argv ) <= 2 ):
        filename = url.rsplit('/', 1)[ -1 ] + '.csv'
    else:
        isolate_name = sys.argv[ 2 ]
        header = append_isolate_title_to_header( header );
        data = append_isolate_to_rows( data, isolate_name );
        filename = isolate_name + '.csv';
    write_to_csv( filename, header, data );
