init:
	git submodule init
	git submodule update

run-localhost:
	hugo server --bind="0.0.0.0" --buildDrafts --baseURL=http://localhost:1313/

run:
	hugo server

build:
	hugo --theme=diary

test:
	hugo --theme=diary --baseUrl="http://localhost" -d docs
	python3 -m http.server --directory docs 80
