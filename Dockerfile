FROM golang:1.19.1-buster as builder

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && apt-get install -y build-essential wget libvips-dev

ADD . /bimg
WORKDIR /bimg
RUN mkdir /bimg_fuzz
WORKDIR /bimg_fuzz
ADD main.go .
RUN go mod init bimg_go_fuzz
RUN go mod tidy
RUN go build
# just in case added a testsuite here too
RUN cp -r /bimg/testdata/ ./testsuite/

FROM golang:1.19.1-buster
COPY --from=builder /bimg_fuzz/bimg_go_fuzz /
COPY --from=builder /bimg/testdata /testsuite/

ENTRYPOINT []
CMD /bimg_go_fuzz @@
