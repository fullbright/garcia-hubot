HOST=127.0.0.1
SRCPATH=./

docker-build:
	docker build -t fullbright/hubot .

docker-run:
	docker run -it fullbright/hubot


