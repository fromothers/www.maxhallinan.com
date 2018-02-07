# www.maxhallinan.com

## Install

```shell
gem install jekyll bundler
bundler install
```

Start running site locally:

```shell
bundler exec jekyll serve
```

## Deploy

### Dat

**Setup**

```shell
# Create Dat build directory in project root.
mkdir _dat

# Create a Dat archive in build directory.
dat share --directory _dat

# Move Dat keys to project root.
mv _dat/.dat .

# Symlink Dat keys to build directory.
ln -s $PWD/.dat $PWD/_dat/
```

**Manual deploy**

```shell
# Clean build directory.
rm -rf _dat

# Build project into build directory.
bundle exec jekyll build \
  --config "_config.yml,_config.dat.yml" \
  --destination _dat

# Symlink Dat keys to build directory. 
ln -s $PWD/.dat $PWD/_dat

# Share changes with the network. 
dat share --directory _dat
```

**Scripted deploy**

```shell
# Configure deploy script.
cp .env.example .env

# Run deploy script.
_scripts/deploy-dat.sh
```
