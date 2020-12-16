#!/usr/bin/env bash

docker run --rm --volume $PWD:/pwd --workdir="/pwd" -it comby/comby 'swap(:[1], :[2])' 'swap(:[2], :[1])' -stdin .js <<< 'swap(x, y)'
