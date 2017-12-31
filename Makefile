HOST=127.0.0.1
SRCPATH=./

docker-test:
	#docker run -it --rm -v $(pwd)/build:/opt/ node:9.3 /bin/bash
	docker run -it --rm fullbright/hubot /bin/bash

docker-build:
	docker build -t fullbright/hubot .

docker-run:
	docker run -it fullbright/hubot


