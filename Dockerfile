FROM golang:1.19.1-buster as builder

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && apt-get install -y build-essential wget libvips-dev

ADD . /bimg
WORKDIR /bimg
RUN mkdir /bimg_fuzz
WORKDIR /bimg_fuzz
ADD main.go .
#RUN /usr/local/go/bin/go install github.com/h2non/bimg@latest
RUN go mod init bimg_go_fuzz
RUN go mod tidy
RUN go build
#RUN cp -r /bimg/testdata/ ./testsuite/

RUN rm -f ./testdata/*.heic
RUN rm -f ./testdata/*.pdf
RUN rm -f ./testdata/vertical.jpg
RUN rm -f ./testdata/*.webp
RUN rm -f ./testdata/*.jp2
RUN rm -f ./testdata/*.avif
RUN rm -f ./testdata/test_exif_full.jpg
RUN rm -f ./testdata/northern_cardinal_bird.jpg

FROM golang:1.19.1-buster
RUN apt update -y && apt install -y libvips-dev --no-install-recommends
COPY --from=builder /bimg_fuzz/bimg_go_fuzz /
COPY --from=builder /bimg/testdata/*.jpg /testsuite/

ENTRYPOINT []
CMD /bimg_go_fuzz 
