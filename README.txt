Would recommend setting up a virtual environment with python using
python3 -m venv NAME_OF_ENV

when in there, run:
pip install -r requirements.txt

From there, add the URLs you want to download to the run_parser.sh file.
The python arguments are:
1st            | Webpage to scrape
2nd (Optional) | Filename for CSV file
