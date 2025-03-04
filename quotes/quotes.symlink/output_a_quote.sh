#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat $DIR/wing_chun_principles.txt $DIR/quotes.txt $DIR/oblique_strategies.txt > /tmp/fortunes.txt

$DIR/rand.sh /tmp/fortunes.txt | cowsay -W 78; echo
