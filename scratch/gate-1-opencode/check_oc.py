#!/usr/bin/env python3
"""check_oc.py — extract latest opencode session tool evidence from tmphome db.
Usage: check_oc.py [dbpath]. Prints tool parts (tool/input/status/output-head)
and trailing assistant text. Read-only."""
import sqlite3
import json
import sys

dbp = sys.argv[1] if len(sys.argv) > 1 else "/g1work/tmphome/.local/share/opencode/opencode.db"
db = sqlite3.connect(dbp)
row = db.execute("select id from session order by rowid desc limit 1").fetchone()
if not row:
    print("NO-SESSIONS")
    sys.exit(1)
sid = row[0]
print("SESSION", sid)
for (pid, data) in db.execute(
        "select id, data from part where session_id=? order by time_created", (sid,)):
    d = json.loads(data)
    t = d.get("type")
    if t == "tool":
        st = d.get("state", {})
        out = st.get("output", st.get("error", ""))
        print(f"TOOL {d.get('tool')} call={d.get('callID')} status={st.get('status')}")
        print(f"  input={json.dumps(st.get('input'))[:160]}")
        print(f"  result={str(out)[:200]}")
    elif t == "text":
        print("TEXT:", (d.get("text") or "")[:100])
