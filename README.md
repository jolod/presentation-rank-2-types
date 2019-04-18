# Notes on rank-2 types - Why you need them and why you don't want them

By Johan Lodin, presented 2017-11-29 at [Got.λ](https://www.meetup.com/got-lambda/).

The template and makefile is adapted from https://github.com/ocramz/talks/tree/master/GotLambda_26112017, with slight modifications.

## Building the slide deck

The slide template is based on Reveal.js, and uses Highlight.js for syntax highlighting.

Running

    make

in this directory will run `pandoc` on `slides.md`, which in populates the `template-revealjs.html` template file and produces `slides.md`.

All the dependencies are local, so make sure to copy the `css/`, `lib/`, `js/` and `highlight/` directories.

### Requirements

* `pandoc`

## Copyright and license

Copyright © 2017 Johan Lodin

Distributed under CC BY-NC-SA 4.0.
