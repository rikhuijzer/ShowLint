# display-lint

Linters have obvious benefits but, like any tool, can be hard to use.
Not all users have the time to install a linter and inspect its output.
Also, some linters show many false-positives and cause the code to be littered with ignore X comments.
Another problem is that any suggestion by the linter is only interesting once.
After a decision is made on applying the suggestion, the suggestion should not come back.

The aim of this repository is to periodically generate the lint results for many repositories and show the results on a website.
