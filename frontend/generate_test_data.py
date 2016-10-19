#!/usr/bin/env python


import random
import json

from datetime import date


def random_date_string():
  start_date = date.today().replace(day=1, month=1).toordinal()
  end_date = date.today().toordinal()
  random_day = date.fromordinal(random.randint(start_date, end_date))
  return random_day.strftime('%Y-%m-%d')


def main():

  divisions = [ 'Compound 1', 'Langbue', 'Instinktiv', 'Barebow', 'Recurve' ]
  clubs = [ 'Club ' + str(x) for x in range(1,11) ]
  archers = [ { 'id' : x, 'name' : 'Archer ' + str(x), 'club' : random.choice(clubs) } for x in range(1, 100)]
  competitions = [ { 'id' : x, 'location' : 'Competition ' + str(x), 'date' : random_date_string() } for x in range(1, 11) ]

  def create_archers():
    found = set()
    archer_list = []
    while len(archer_list) < 10:
      archer = random.choice(archers)
      if archer['id'] not in found:
        results = create_results()
        archer['total'] = sum(item['result'] for item in results)
        archer['individual_results'] = results
        archer_list.append(archer)
        found.add(archer['id'])
    return archer_list


  def create_results():
    found = set()
    comp_list = []
    while len(comp_list) < 3:
      comp = random.choice(competitions)
      if comp['id'] not in found:
        comp_list.append(comp)
        found.add(comp['id'])
    return [{
        'competition_id' : str(competition['id']),
        'location' : competition['location'],
        'date' : competition['date'],
        'result' : random.randint(250, 600)
        } for competition in comp_list]

  # print divisions
  # print archers
  # print competitions

  json_data = {}
  json_data['divisions'] = []
  for division in divisions:
    json_data['divisions'].append({'division' : division, 'archers' : create_archers()})

  with open('db.json', 'w') as outfile:
    json.dump(json_data, outfile)

if __name__ == '__main__':
  main()
