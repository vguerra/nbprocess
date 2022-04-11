.ONESHELL:
SHELL := /bin/bash
SRC = $(wildcard nbs/*.ipynb)

all: nbprocess docexp

nbprocess: $(SRC)
	nbprocess_export
	touch nbprocess

sync:
	nbdev_update_lib

docs_serve:
	cd docs
	mkdocs serve

docs: $(SRC)
	nbdev2_docs --path nbs --dest docs

test:
	nbdev_test_nbs

release: pypi conda_release
	nbdev_bump_version

conda_release:
	fastrelease_conda_package

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist

install_quarto:
	wget `curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases | grep browser_download_url | grep '64[.]deb' | head -n 1 | cut -d '"' -f 4`
	dpkg -i *64.deb
	rm *64.deb

