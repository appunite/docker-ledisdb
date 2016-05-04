default: build

clean:
	docker rmi bborbe/ledisdb-build
	docker rmi bborbe/ledisdb

setup:
	go get github.com/siddontang/ledisdb/cmd/ledis-server

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o ledis-server ./go/src/github.com/siddontang/ledisdb/cmd/ledis-server

build:
	docker build --no-cache --rm=true -t bborbe/ledisdb-build -f ./Dockerfile.build .
	docker run -t bborbe/ledisdb-build /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=bborbe/ledisdb-build -f status=exited`:/ledis-server .
	docker rm `docker ps -q -n=1 -f ancestor=bborbe/ledisdb-build -f status=exited`
	docker build --no-cache --rm=true --tag=bborbe/ledisdb -f Dockerfile.static .
	rm ledis-server

run:
	docker run -p 6380:6380 -p 11181:11181 bborbe/ledisdb

upload:
	docker push bborbe/ledisdb
