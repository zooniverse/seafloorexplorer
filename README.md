Seafloor Zoo
============

Install
-------

Install the `src/scripts/lib/zooniverse` submodule:

```bash
git submodule init
git submodule update
```

You'll also need the `zoo` script. Currently you have to build its gem manually:

```bash
git clone git@github.com:zooniverse/Front-End-Assets.git -b app
cd Front-End-Assets
gem buidl zoo.gemspec
gem install zoo-0.0.3.gem
```

Server
------

```bash
zoo serve 8080
```
