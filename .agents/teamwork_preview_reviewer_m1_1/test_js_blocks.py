import re
import subprocess
import tempfile
import sys

doc_path = "/home/lan/dotfiles/templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md"
with open(doc_path, "r", encoding="utf-8") as f:
    content = f.read()

# Find all JS blocks
pattern = re.compile(r"```(?:javascript|js)\n(.*?)```", re.DOTALL)
js_blocks = pattern.findall(content)

print(f"Total JS code blocks found: {len(js_blocks)}")

passed = 0
failed = 0
errors = []

for idx, code in enumerate(js_blocks, 1):
    with tempfile.NamedTemporaryFile("w", suffix=".js", delete=False) as tf:
        tf.write(code)
        tf_name = tf.name
    res = subprocess.run(["node", "--check", tf_name], capture_output=True, text=True)
    if res.returncode == 0:
        passed += 1
    else:
        failed += 1
        errors.append((idx, res.stderr, code[:150]))

print(f"Node syntax check: {passed}/{len(js_blocks)} PASSED, {failed} FAILED.")
if errors:
    for idx, err, snippet in errors:
        print(f"--- Error in JS Block {idx} ---")
        print(f"Snippet:\n{snippet}")
        print(f"Error:\n{err}\n")
    sys.exit(1)
else:
    print("ALL JS CODE BLOCKS ARE SYNTACTICALLY VALID!")
