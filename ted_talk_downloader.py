import requests
from bs4 import BeautifulSoup

#url = "https://www.ted.com/talks/jia_jiang_what_i_learned_from_100_days_of_rejection"

url = "https://www.ted.com/talks/ken_robinson_says_schools_kill_creativity"

r = requests.get(url)

print("Download about to start")

soup = BeautifulSoup(r.content)

for val in soup.findAll("script"):
    if(re.search("talkPage.init",str(val))) is not None:
        result = str(val)

print(re.search("(?P<url>https?://[^\s]+)(mp4)", result).group("url"))
