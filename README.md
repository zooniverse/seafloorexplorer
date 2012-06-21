Seafloor Zoo
============

Install
-------

Install the `src/scripts/lib/zooniverse` submodule:

```bash
git submodule init
git submodule update
```

Then install the assets:

```bash
grabass install
```

You'll also need the `zoo` script. Currently you have to build its gem manually:

```bash
git clone git@github.com:zooniverse/Front-End-Assets.git -b app
cd Front-End-Assets
gem build zoo.gemspec
gem install zoo-x.y.z.gem
```

Server
------

```bash
zoo serve 8080
```
