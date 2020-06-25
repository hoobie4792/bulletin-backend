require 'news-api'



def create_news_sources
  sources = [ 
    { name: "USA Today", url: "http://www.usatoday.com/news"},
    { name: "The Wall Street Journal", url: "http://www.wsj.com"},
    { name: "The Huffington Post", url: "http://www.huffingtonpost.com"},
    { name: "The Washington Post", url: "https://www.washingtonpost.com"},
    { name: "Bloomberg", url: "http://www.bloomberg.com" },
    { name: "ABC News", url: "https://abcnews.go.com" },
    { name: "CNN", url: "http://us.cnn.com" },
    { name: "CBS News", url: "http://www.cbsnews.com" },
    { name: "Fox News", url: "http://www.foxnews.com" },
    { name: "MSNBC", url: "http://www.msnbc.com" },
    { name: "NBC News", url: "http://www.nbcnews.com" },
    { name: "ESPN", url: "http://espn.go.com" },
    { name: "Fox Sports", url: "http://www.foxsports.com" },
    { name: "Bleacher Report", url: "http://www.bleacherreport.com" },
    { name: "NFL News", url: "http://www.nfl.com/news" },
    { name: "NHL News", url: "https://www.nhl.com/news" },
    { name: "Newsweek", url: "https://www.newsweek.com" },
    { name: "Associated Press", url: "https://apnews.com/" },
    { name: "Wired", url: "https://www.wired.com" },
    { name: "TechRadar", url: "http://www.techradar.com" },
    { name: "The Verge", url: "http://www.theverge.com" },
    { name: "TechCrunch", url: "https://techcrunch.com" },
    { name: "Engadget", url: "https://www.engadget.com" },
    { name: "Crypto Coins News", url: "https://www.ccn.com" },
    { name: "IGN", url: "http://www.ign.com" },
    { name: "Polygon", url: "http://www.polygon.com" },
    { name: "Fortune", url: "http://fortune.com" },
    { name: "Business Insider", url: "http://www.businessinsider.com" },
    { name: "The Washington Times", url: "https://www.washingtontimes.com/" },
    { name: "The American Conservative", url: "http://www.theamericanconservative.com/" },
    { name: "National Review", url: "https://www.nationalreview.com/" },
    { name: "Politico", url: "https://www.politico.com" },
    { name: "Time", url: "http://time.com" },
    { name: "New York Magazine", url: "http://nymag.com" },
    { name: "Google News", url: "https://news.google.com" },
    { name: "Buzzfeed", url: "https://www.buzzfeed.com" },
    { name: "Vice News", url: "https://news.vice.com" },
    { name: "National Geographic", url: "http://news.nationalgeographic.com" },
    { name: "Entertainment Weekly", url: "http://www.ew.com" },
    { name: "Medical News Today", url: "http://www.medicalnewstoday.com" },
    { name: "MTV News", url: "http://www.mtv.com/news" },
    { name: "New Scientist", url: "https://www.newscientist.com/section/news" }
  ]

  sources.each { |s| NewsSource.create(s)}
end