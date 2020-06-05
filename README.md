# CLI Tools for CSV, JSON, & HTML

Welcome! This is a tutorial for using command-line tools to work with data. It
will focus on data encoded in CSV, JSON, and HTML -- popular formats if you work
in technology.

This is really meant for anyone who works in tech. If you're a programmer, this
gives you some ideas for when _not_ to use code to solve a problem. If you are
not a programmer and frustrated by a lack of tools to solve data problems, this
shows you how to get a job done using tools probably already on your computer.

## Viewing the Presentation

The contents of the presentation are in the `index.html` file in this
repository. It uses [reveal.js](https://revealjs.com/) to run the slideshow in
your browser.

If you'd like to view it on your own computer, first clone this repository to
your computer:

```
git@github.com:TheDahv/cli-data-processing.git
```

If you don't already have `git` installed, you can learn more about that on [the
git website](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Once you have this repository on your computer, open `index.html` in a web
browser.

## Running the Examples

This repository includes scripts and sample data to help you try what you see in
the presentation yourself. I'll list the installation pages for the programs
we'll use:

- [csvkit](https://csvkit.readthedocs.io/en/latest/tutorial/1_getting_started.html#installing-csvkit)
- [jq](https://stedolan.github.io/jq/download/)
- [pup](https://github.com/ericchiang/pup)

The rest of the tools are likely already on your computer if you use a Mac or
Linux system. I haven't tried it myself, but I understand [Windows Subsystem for
Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) should get
you an environment where you can follow along on Windows. Again, I haven't been
able to try it myself, so I can't make strong guarantees.

Another option would be to run these commands within a pre-configured, isolated
playground. That's something [Docker](https://www.docker.com/) can help with!
Check out the [Docker Desktop](https://www.docker.com/products/docker-desktop)
documentation to learn to install it on your system.

This repository contains a `Dockerfile` that contains instructions for building
an image that has all the tools, scripts, and sample data you will need.

To use it, make sure Docker is installed and running. Then open a terminal
application in the same directory to which you've downloaded this repository.

To build the image, type this in your terminal and press Enter to run it: `./build-docker.sh`.
To run a container based on that image, run `./run-docker.sh`.
