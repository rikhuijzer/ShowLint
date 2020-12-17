+++
title = "ShowLint"
tags = ["syntax", "lint"]
+++

# ShowLint

Linters have obvious benefits but, like any tool, can be hard to use.
Not all users have the time to install a linter and inspect its output.
Also, some linters show many false-positives and cause the code to be littered with ignore X comments.
Another problem is that any suggestion by the linter is only interesting once.
After a decision is made on applying the suggestion, the suggestion should not come back.

So, I figured that it might be useful to periodically generate the lint results for many repositories and show the results on a website.

This website shows linting results for

- [patterns](/patterns) on 
- [repositories](/repositories) 

by using [Comby](https://github.com/comby-tools/comby).

If the linter shows useful rewrites, then you can use Comby to create a pull request manually.
All the required information is available on this website and in Comby's documentation.
To automate pull request creation, see [Sourcegraph Campaigns](https://sourcegraph.com/campaigns).
