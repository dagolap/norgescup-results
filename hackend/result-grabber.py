from bs4 import BeautifulSoup
from collections import defaultdict
from tinydb import TinyDB, Query
from datetime import datetime
import pprint
import urllib2

pp = pprint.PrettyPrinter(indent=4)
db = TinyDB('db.json')
et = db.table('events')
at = db.table('archers')
rt = db.table('results')

def get_archers():
    return [a.get("ianseo") for a in at.all()]

def get_results(comp_number):
    if not comp_number: return None

    eventQ = Query()
    ev = et.search(eventQ.id == comp_number)
    if (not ev):
        print("Event not found")
        return
    if len(ev) > 1:
        print("Too many events found. Corrupted data.")
        return
    if ev[0].get("handled"):
        print("Event already handled")
        return

    url = "http://nor.service.ianseo.net/General/CompetitionDetail.php?Competition=%s&Lang=en" % (comp_number)
    page = urllib2.urlopen(url)
    soup = BeautifulSoup(page.read(), 'html.parser')
    # soup = BeautifulSoup(open("test-data.html").read(), 'html.parser')

    category_map = defaultdict(None, {
        "Compound 1": "Compound",
        "Compound 2": "Compound",
        "Recurve 1": "Recurve",
        "Recurve 2": "Recurve",
        "Langbue 1": "Langbue",
        "Instinktiv 1": "Instinktiv",
        "Barebow 1": "Barebow"
    })

    if (soup.find(text='Qualification rank')):
        print("Found results for event %s - parsing..." % (comp_number))
        competition_code = soup.find(text="Competition Code").parent.parent.find("td").text

        results_tbody = soup.find(text='Qualification rank').parent.parent.parent
        results_rows = results_tbody.findAll('tr')

        category = None
        results = []
        for row in results_rows:
            if row.find(name='th', attrs={"colspan": 7}):
                print("Setting category to: %s" % (row.find(name='th', attrs={"colspan": 7}).text))
                category = row.find(name='th', attrs={"colspan": 7}).text
            elif category_map.get(category):
                tds = row.findAll('td')
                results.append({
                    "event": competition_code,
                    "category": category_map.get(category),
                    "name": tds[1].text,
                    "archer_id": tds[1].find('a').attrs.get("href")[-4:],
                    "club": tds[2].text[tds[2].text.index(" ") + 1:],
                    "score": int(tds[3].text) if tds[3].text.isdigit() else 0
                    })

        print("Found %d results total." % len(results))
            
        valid_archers = get_archers()
        print("There are %d archers competing in Norgescupen" % (len(valid_archers)))
        print(valid_archers)

        results = [r for r in results if r.get("archer_id") in valid_archers]
        
        if results:
            rt.insert_multiple(results)
            et.update({'handled': True}, eventQ.id == competition_code)
            print("Inserted " + str(len(results)) + " results")

        return results
    
    print("No results found for event %s" % (comp_number))
    return

def date_less_than_today(date):
    parts = date.split("-")
    parsed_date = datetime(int(parts[0]), int(parts[1]), int(parts[2]))

    return parsed_date < datetime.today()


if __name__ == '__main__':
    eq = Query()
    events_to_handle = [e for e in et.all() if (not e.get("handled")) and (date_less_than_today(e.get("date")))]
    print("Events to handle:")
    pp.pprint(events_to_handle)

    for e in events_to_handle:
        pp.pprint(e)
        print("Trying event: " + e.get("id"))
        get_results(e.get("id"))
    
    db.close()