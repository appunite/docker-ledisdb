default: build

clean:
	docker rmi appunite/ledisdb-build
	docker rmi appunite/ledisdb

setup:
	go get github.com/siddontang/ledisdb/cmd/ledis-server

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o ledis-server ./go/src/github.com/siddontang/ledisdb/cmd/ledis-server

build:
	docker build --no-cache --rm=true -t appunite/ledisdb-build -f ./Dockerfile.build .
	docker run -t appunite/ledisdb-build /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=appunite/ledisdb-build -f status=exited`:/ledis-server .
	docker rm `docker ps -q -n=1 -f ancestor=appunite/ledisdb-build -f status=exited`
	docker build --no-cache --rm=true --tag=appunite/ledisdb -f Dockerfile.static .
	rm ledis-server

run:
	docker run -p 6380:6380 -p 11181:11181 appunite/ledisdb

upload:
	docker push appunite/ledisdb
