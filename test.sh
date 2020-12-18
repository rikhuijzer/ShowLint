#!/usr/bin/env bash

comby 'a :[1] c d' '' -stdin .txt -newline-separated -stdout <<< "a b c d"

exit(0)
