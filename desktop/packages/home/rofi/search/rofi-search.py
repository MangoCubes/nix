import sys
from subprocess import Popen, PIPE

process = Popen(["rofi-input", "Keyword"], stdout=PIPE)
(output, err) = process.communicate()
exit_code = process.wait()

if(exit_code):
    sys.exit(exit_code)

query = str(output.decode('utf-8')).strip()

if(len(query) == 0):
    sys.exit(1)

engine = Popen(["rofi-engines"], stdout=PIPE)
(output, err) = engine.communicate()
exit_code = engine.wait()

if(exit_code):
    sys.exit(exit_code)

website = str(output.decode('utf-8')).strip()

if(len(website) == 0):
    sys.exit(1)

Popen(["browser", "--new-window", website + query], stdout=PIPE, stderr=PIPE)
sys.exit(0)


