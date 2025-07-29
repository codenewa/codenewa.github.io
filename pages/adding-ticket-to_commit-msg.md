

Adding VSTS Ticket# to the commits

When we add the vsts ticket# to the commit, it gives following benefits:

The commit, build, pr, release, etc all get attached to the ticket.

Each commit can be seen on the ticket history page itself.

However, if it's manual, it'll likely be forgotten. So, here's a code snippet to automate the process.

1. Save the following with name: prepare-commit-msg in an accessible something like crveit

#!/bin/bash

FILE-51 MESSAGE $(cat SFILE)

TICKET-[#$(git rev-parse abbrev-ref HEAD grep -Eo: ^(\w/)?(\w+(-_1)}[0-9]++ grep Bo (\w+[-][0-9]+' | tr "[:lower:]" "[:upper:]")]

If [ STICKET"[]" || "SMESSAGE" "STICKET ]]; then

exit e;

echo "STICKET SMESSAGE"> SFILE

2. Run:

git config --global core.hooksPath/path/to/git_hooks

3. Your branch should be named as follows: feature/23451-some-description hotfix/11111-test dev-test/12345-apple

1 visit in last 30 days