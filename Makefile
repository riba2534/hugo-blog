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
	# hugo --theme=diary --baseUrl="http://127.0.0.1:8080" -d docs
	rm -rf docs
	hugo --theme=diary -d docs
	python3 -m http.server --directory docs 80
