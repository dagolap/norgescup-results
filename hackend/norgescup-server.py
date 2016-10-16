from flask import Flask, jsonify
from tinydb import TinyDB, Query

from itertools import groupby

app = Flask(__name__)

@app.route('/api/scoreboard', methods=['GET'])
def get_scoreboard():
    db = TinyDB('db.json')
    rt = db.table('results')
    et = db.table('events')

    all_events_list = et.all()
    all_events = {}
    for e in all_events_list:
        all_events[e["id"]] = e
    

    returnable_results = { "divisions" : []}
    results = rt.all()
    results.sort(key=lambda x: x.get("category"))
    
    for key, group in groupby(results, lambda x: x.get("category")):
        returnable_group = {
            "division": key,
            "archers": []
        }
        group_content = list(group)
        group_content.sort(key=lambda x: x.get("archer_id"))
        for archer_id, archer_group in groupby(group_content, lambda x: x.get("archer_id")):
            archer_group_content = list(archer_group)
            archer_group_content.sort(lambda x: int(x["score"]))
            returnable_archer = {
                "id": archer_id,
                "name": archer_group_content[0]["name"],
                "club": archer_group_content[0]["club"],
                "total": sum([int(x["score"]) for x in archer_group_content[:3]]),
                "individual_results": []
            }
            for archer_result in archer_group_content:
                returnable_archer["individual_results"].append({
                    "competition_id": archer_result["event"],
                    "location": all_events[archer_result["event"]]["location"],
                    "result": archer_result["score"],
                    "date": all_events[archer_result["event"]]["date"]
                })
            returnable_group["archers"].append(returnable_archer)

        returnable_results.get("divisions").append(returnable_group)




    db.close()

    return jsonify(returnable_results)

if __name__ == '__main__':
    app.run(debug=True)