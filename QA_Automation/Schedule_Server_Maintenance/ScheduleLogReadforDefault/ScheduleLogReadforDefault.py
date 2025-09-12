import os
import re
from datetime import datetime

# Get paths
base_path = input("Enter base path where log files are located: ").strip()
output_file = input("Enter full path for output result.txt file: ").strip()

# Regex patterns
start_pattern = re.compile(
    r"(?P<datetime>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d+.*?ReportExecuteStart: Name: (?P<report>.*?),"
)
end_pattern = re.compile(
    r"(?P<datetime>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d+.*?ReportExecuteEnd: Name: (?P<report>.*?),"
)

# Log data
start_entries = []
end_entries = []

# Read log files
log_files = ["eWebReportsScheduler.log"] + [f"eWebReportsScheduler.log.{i}" for i in range(1, 11)]

for fname in log_files:
    full_path = os.path.join(base_path, fname)
    if not os.path.exists(full_path):
        continue

    try:
        with open(full_path, "r", encoding="utf-8") as file:
            for line in file:
                sm = start_pattern.search(line)
                if sm:
                    start_entries.append({
                        "report": sm.group("report").strip(),
                        "datetime": datetime.strptime(sm.group("datetime"), "%Y-%m-%d %H:%M:%S"),
                        "line": line.strip()
                    })
                    continue

                em = end_pattern.search(line)
                if em:
                    end_entries.append({
                        "report": em.group("report").strip(),
                        "datetime": datetime.strptime(em.group("datetime"), "%Y-%m-%d %H:%M:%S"),
                        "line": line.strip()
                    })

    except Exception as e:
        print(f"⚠️ Error reading file {fname}: {e}")

# Match start and end entries
completed = []
wip = []
orphan_end = []

used_end_indexes = set()

for s in start_entries:
    matched = False
    for idx, e in enumerate(end_entries):
        if idx in used_end_indexes:
            continue
        if s["report"] == e["report"] and e["datetime"] > s["datetime"]:
            duration = e["datetime"] - s["datetime"]
            completed.append(f"{s['line']} | {e['line']} | ExecuteTime: {duration}")
            used_end_indexes.add(idx)
            matched = True
            break
    if not matched:
        wip.append(s["line"])

for idx, e in enumerate(end_entries):
    if idx not in used_end_indexes:
        orphan_end.append(e["line"])

# Write result
try:
    with open(output_file, "w", encoding="utf-8") as out:
        out.write("=== Completed Executions ===\n")
        for line in completed:
            out.write(line + "\n")

        out.write("\n=== In-Progress (Start Found, End Missing) ===\n")
        for line in wip:
            out.write(line + "\n")

        out.write("\n=== Orphan End Entries (End Found, Start Missing) ===\n")
        for line in orphan_end:
            out.write(line + "\n")

    print(f"\n✅ Done! Output written to: {output_file}")

except Exception as e:
    print(f"❌ Failed to write result file: {e}")
