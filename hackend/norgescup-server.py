from flask import Flask, jsonify
from tinydb import TinyDB, Query

from itertools import groupby

app = Flask(__name__)

@app.route('/api/sb', methods=["GET"])
@app.route('/api/scoreboard', methods=['GET'])
def get_scoreboard():
    db = TinyDB('db.json')
    rt = db.table('results')
    et = db.table('events')
    at = db.table('archers')

    all_events_list = et.all()
    all_events = {}
    for e in all_events_list:
        all_events[e["id"]] = e
    

    intermediated_grouped_results = { "divisions" : []}
    results = rt.all()
    results.sort(key=lambda x: x.get("category"))

    grouped_participants = {}
    for p in sorted(at.all(), key=lambda p: p["division"]):
        print("Now grouping %s into %s" % (p, p["division"]))
        if not p["division"] in grouped_participants.keys():
            grouped_participants[p["division"]] = []

        grouped_participants[p["division"]].append({
            "id": p["ianseo"],
            "name": p["name"],
            "club": p["club"],
            "total": 0,
            "individual_results": []
        })

    for key, group in groupby(results, lambda x: x.get("category")):
        returnable_group = {
            "division": key,
            "archers": []
        }
        group_content = list(group)
        group_content.sort(key=lambda x: x.get("archer_id"))
        for archer_id, archer_group in groupby(group_content, lambda x: x.get("archer_id")):
            archer_group_content = sorted(list(archer_group), key=lambda x: int(x["score"]))
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

        intermediated_grouped_results.get("divisions").append(returnable_group)

    # Add all missing divisions
    returnable_results = intermediated_grouped_results["divisions"]
    for division_name in ["Compound", "Recurve", "Barebow", "Langbue", "Instinktiv"]:
        if not division_name in [x["division"] for x in returnable_results]:
            returnable_results.append({"division": division_name, "archers": []})

    # Add all missing archers
    for group in returnable_results:
        for unscored_archer in grouped_participants[group["division"]]:
            if not unscored_archer["id"] in [x["id"] for x in group["archers"]]:
                group["archers"].append(unscored_archer)


    db.close()

    return jsonify(returnable_results)

@app.after_request
def apply_caching(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

if __name__ == '__main__':
    app.run(debug=False)
