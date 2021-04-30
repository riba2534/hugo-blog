init:
	git submodule init
	git submodule update

run:
	hugo server

build:
	hugo --theme=diary

test:
	rm -rf docs
	hugo --theme=diary --baseUrl="http://127.0.0.1" -d docs
	python3 -m http.server --directory docs 80
